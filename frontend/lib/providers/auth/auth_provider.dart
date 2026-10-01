import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '223768746501-hsdbjv9lv7cro5u9arts3dble52i7q27.apps.googleusercontent.com',
  );
  String? _token;
  Map<String, dynamic>? _user;
  bool _loading = false;
  bool _isInitialized = false;
  bool _isServerDown = false;
  String? _error;

  ApiService get api => _api;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;
  bool get isInitialized => _isInitialized;
  bool get isServerDown => _isServerDown;
  bool get isManager =>
      _user?['role'] == 'manager' || _user?['role'] == 'super_manager';
  bool get isSuperManager => _user?['role'] == 'super_manager';
  bool get isStaff => _user?['role'] == 'staff';
  bool get isMitraEks => _user?['role'] == 'mitra_eks';
  String get fullName => _user?['full_name'] ?? '';
  String get role => _user?['role'] ?? '';
  String? get profileImageUrl {
    if (_user?['profile_image'] == null) return null;
    return '${ApiService.baseUrl}/uploads/${_user?['profile_image']}';
  }

  String get roleDisplayName {
    switch (_user?['role']) {
      case 'super_manager':
        return 'Super Manager';
      case 'manager':
        return 'Manager';
      case 'staff':
        return 'Staff';
      case 'mitra_eks':
        return 'Mitra Eksternal';
      default:
        return _user?['role'] ?? '';
    }
  }

  String _activeCompany = '';
  String get activeCompany => _activeCompany;

  List<String> _systemCompanies = ['EWI Foundation', 'Exspan Wireless Indo'];
  List<String> get systemCompanies => _systemCompanies;

  List<String> get accessibleCompanies {
    if (_user == null) return [];
    if (_user!['company_access'] != null) {
      return List<String>.from(_user!['company_access']);
    }
    // Fallback if DB not updated yet
    if (isSuperManager) {
      return _systemCompanies;
    }
    return _systemCompanies.isNotEmpty
        ? [_systemCompanies.first]
        : ['EWI Foundation'];
  }

  void clearActiveCompany() {
    _activeCompany = '';
    _api.setCompany(null);
    notifyListeners();
  }

  void setActiveCompany(String company) {
    if (accessibleCompanies.contains(company)) {
      _activeCompany = company;
      _api.setCompany(company);
      notifyListeners();
    }
  }

  bool _disposed = false;
  bool get disposed => _disposed;

  bool get loading => _loading;
  String? get error => _error;

  void resetLoading() {
    _loading = false;
    notifyListeners();
  }

  bool get isGoogleSignInSupported {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS ||
      TargetPlatform.windows =>
        true,
      _ => false,
    };
  }

  AuthProvider() {
    _loadToken();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadToken() async {
    try {
      await ApiService.loadSavedBaseUrl();

      // Step 1: Check connectivity FIRST with short timeout
      _isServerDown = !await ApiService.checkConnectivity();

      if (_isServerDown) {
        // Stop here, let the UI show Error Screen
        debugPrint(
            'Init Error: Server is unreachable at ${ApiService.baseUrl}');
        return;
      }

      try {
        _systemCompanies = await _api.getSystemCompanies();
      } catch (e) {
        debugPrint('Failed to load system companies: $e');
      }

      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');

      if (_token != null && !_disposed) {
        // refresh user dari api
        try {
          _api.setToken(_token);
          final res = await _api.getMe();
          if (!_disposed) {
            _user = res['user'];
          }
        } catch (e) {
          // Cek jenis error: Auth vs Network
          final errorStr = e.toString().toLowerCase();
          final isAuthError = errorStr.contains('401') ||
              errorStr.contains('unauthorized') ||
              errorStr.contains('sesi expired');

          debugPrint('Init Load Error: $e (isAuthError: $isAuthError)');

          if (!_disposed) {
            if (isAuthError) {
              // Token beneran expired/invalid -> Hapus permanen
              await logout();
            } else {
              // Mungkin masalah jaringan atau server down
              // Set _token null di memori agar ke LoginScreen,
              // tapi JANGAN hapus dari SharedPreferences (biar "Ingat Saya" tetap kerja nanti)
              _token = null;
            }
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading initial token: $e');
    } finally {
      if (!_disposed) {
        _isInitialized = true;
        notifyListeners();
      }
    }
  }

  Future<bool> login(String username, String password,
      {bool rememberMe = false}) async {
    if (_loading) return false;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.login(username, password);
      _token = res['token'];
      _user = res['user'];
      _api.setToken(_token);

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString('token', _token!);
      } else {
        await prefs.remove('token');
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginWithGoogle(
      {bool rememberMe = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      if (!isGoogleSignInSupported) {
        throw Exception(
          'Login Gmail belum didukung di perangkat ini. Gunakan login username/password.',
        );
      }

      // 1. Sign in with Google
      // Paksa logout dulu supaya muncul pilihan akun (Account Picker)
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _loading = false;
        notifyListeners();
        return null; // User cancelled
      }

      // 2. Get ID Token
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Gagal mendapatkan ID Token dari Google');
      }

      // 3. Send token to backend
      final res = await _api.googleLogin(idToken);

      if (res['new_user'] == true) {
        _loading = false;
        notifyListeners();
        return res; // Registration info for new user
      }

      // 4. Handle successful login
      _token = res['token'];
      _user = res['user'];
      _api.setToken(_token);

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString('token', _token!);
        // Save flag as true so next app launch knows remember me was used
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('token');
        await prefs.remove('remember_me');
      }

      _loading = false;
      notifyListeners();
      return {'success': true};
    } on MissingPluginException {
      _error =
          'Login Gmail belum tersedia di platform ini. Gunakan login username/password.';
      _loading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.forgotPassword(email);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String username,
    String password,
    String fullName,
    String role, {
    String? email,
    String? googleId,
    String? phoneNumber,
    String? workplace,
    List<String>? companyAccess,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.register(
        username,
        password,
        fullName,
        role,
        email: email,
        googleId: googleId,
        phoneNumber: phoneNumber,
        workplace: workplace,
        companyAccess: companyAccess,
      );
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createUser({
    required String username,
    required String password,
    required String fullName,
    required String role,
    String? phoneNumber,
    String? workplace,
    List<String>? companyAccess,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.createUser(
        username: username,
        password: password,
        fullName: fullName,
        role: role,
        phoneNumber: phoneNumber,
        workplace: workplace,
        companyAccess: companyAccess,
      );
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final res = await _api.getUsers();
      return List<Map<String, dynamic>>.from(res['users'] ?? []);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return [];
    }
  }

  Future<bool> reloadUser() async {
    if (_token == null) return false;
    try {
      final res = await _api.getMe();
      if (!_disposed) {
        _user = res['user'];
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error reloading user: $e');
      return false;
    }
  }

  Future<bool> updateUser(int userId, Map<String, dynamic> data) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.updateUser(
        userId,
        fullName: data['full_name'],
        phoneNumber: data['phone_number'],
        workplace: data['workplace'],
        role: data['role'],
        password: data['password'],
        companyAccess: data['company_access'],
      );

      // If updating self, update local _user data
      if (res['success'] == true && _user != null && _user!['id'] == userId) {
        _user = res['user'];
        // Ensure active company is still accessible
        if (_activeCompany.isNotEmpty &&
            !accessibleCompanies.contains(_activeCompany)) {
          _activeCompany = '';
          _api.setCompany(null);
        }
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data,
      {String? imagePath, bool removeImage = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.updateProfile(
        fullName: data['full_name'],
        phoneNumber: data['phone_number'],
        workplace: data['workplace'],
        oldPassword: data['old_password'],
        newPassword: data['new_password'],
        profileImagePath: imagePath,
        removeProfileImage: removeImage,
      );
      _user = res['user'];
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  void updateUserData(Map<String, dynamic> userData) {
    _user = userData;
    notifyListeners();
  }

  Future<bool> linkGoogleAccount() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      if (!isGoogleSignInSupported) {
        throw Exception('Fitur ini belum didukung di perangkat ini.');
      }

      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) {
        _loading = false;
        notifyListeners();
        return false;
      }

      final auth = await account.authentication;
      if (auth.idToken == null) {
        throw Exception('Gagal mendapatkan ID Token dari Google');
      }

      final res = await _api.linkGoogleAccount(auth.idToken!);
      _user = res['user'];

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> unlinkGoogleAccount() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.unlinkGoogleAccount();
      _user = res['user'];

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    // 1. Hapus data sesi lokal (STATE) segera agar UI langsung update ke LoginScreen
    _token = null;
    _user = null;
    _activeCompany = '';
    _api.setToken(null);
    _loading = false;
    notifyListeners();

    // 2. Hapus dari SharedPreferences secara background
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_data');
      await prefs.remove('remember_me');
      await prefs.remove('saved_username');
      await prefs.remove('saved_password');
    } catch (e) {
      debugPrint('Logout prefs error: $e');
    }

    // 3. Pastikan Google Sign In juga terputus
    try {
      final isWindows =
          !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
      if (isGoogleSignInSupported && !isWindows) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      debugPrint('Google SignOut minor error: $e');
    }
  }

  Future<void> retryInitialization() async {
    _isInitialized = false;
    _isServerDown = false;
    _loading = true; // Set loading true while checking
    notifyListeners();

    // Slight delay to show loading state
    await Future.delayed(const Duration(milliseconds: 500));
    await _loadToken();

    // Ensure loading is off after token load attempt
    _loading = false;
    notifyListeners();
  }
  // --- DEBUG METHODS UNTUK TESTING ---

  Future<bool> debugLogin() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _token = 'debug_token_123';
    _user = {
      'id': 1,
      'username': 'admin',
      'full_name': 'Anevril Chairu (DEBUG)',
      'role': 'manager',
      'email': 'anevril@debug.com',
      'phone_number': '08118861201',
      'workplace': 'Mercu Buana',
    };
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<bool> debugLinkGoogle() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    if (_user != null) {
      _user!['google_id'] = 'debug_google_id_999';
      _user!['email'] = 'anevril@gmail.com';
    }
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<bool> debugForgotPassword(String email) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loading = false;
    notifyListeners();
    return true; // Selalu anggap berhasil
  }

  Future<bool> debugResetPassword() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loading = false;
    notifyListeners();
    return true; // Selalu anggap berhasil
  }
}
