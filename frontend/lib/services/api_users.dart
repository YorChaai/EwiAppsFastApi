import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceUsersExt on ApiService {
  Future<Map<String, dynamic>> getUsers() async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/auth/users'),
          headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getUserDetail(int userId) async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/auth/users/$userId'),
          headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createUser({
    required String username,
    required String password,
    required String fullName,
    required String role,
    String? phoneNumber,
    String? workplace,
    List<String>? companyAccess,
  }) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/auth/users'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'password': password,
          'full_name': fullName,
          'role': role,
          'phone_number': phoneNumber,
          'workplace': workplace,
          'company_access': companyAccess,
        }),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? workplace,
    String? oldPassword,
    String? newPassword,
    String? profileImagePath,
    bool removeProfileImage = false,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiService.baseUrl}/auth/profile'),
    );
    request.headers.addAll(authHeaders);

    if (fullName != null) request.fields['full_name'] = fullName;
    if (phoneNumber != null) request.fields['phone_number'] = phoneNumber;
    if (workplace != null) request.fields['workplace'] = workplace;
    if (oldPassword != null) request.fields['old_password'] = oldPassword;
    if (newPassword != null) request.fields['new_password'] = newPassword;
    if (removeProfileImage) request.fields['remove_profile_image'] = 'true';

    if (profileImagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', profileImagePath),
      );
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateUser(
    int userId, {
    String? fullName,
    String? phoneNumber,
    String? workplace,
    String? role,
    String? password,
    List<String>? companyAccess,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (phoneNumber != null) body['phone_number'] = phoneNumber;
    if (workplace != null) body['workplace'] = workplace;
    if (role != null) body['role'] = role;
    if (password != null) body['password'] = password;
    if (companyAccess != null) body['company_access'] = companyAccess;

    final res = await ApiService.retryRequest(
      () => http.put(
        Uri.parse('${ApiService.baseUrl}/auth/users/$userId'),
        headers: headers,
        body: jsonEncode(body),
      ),
    );
    return handleResponse(res);
  }
  // settlements
}
