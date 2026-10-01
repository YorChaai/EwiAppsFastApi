import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/transactions/revenue_provider.dart';
import 'package:expense_app/providers/master_data/tax_provider.dart';
import 'package:expense_app/providers/transactions/dividend_provider.dart';
import 'package:expense_app/providers/core/theme_provider.dart';
import 'package:expense_app/providers/core/notification_provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/providers/master_data/bank_status_provider.dart';
import 'package:expense_app/providers/transactions/asset_provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/screens/auth/login_screen.dart';
import 'package:expense_app/screens/auth/loading_screen.dart';
import 'package:expense_app/screens/auth/server_error_screen.dart';
import 'package:expense_app/screens/dashboard/dashboard_screen.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_snackbar.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // DISABLE scrollbar on mobile - tidak perlu scrollbar di Android/iOS
    // Scrollbar hanya untuk desktop/web
    if (kIsWeb) {
      // Keep scrollbar for web with proper controller
      return AppScrollbar(
        controller: details.controller,
        interactive: true,
        child: child,
      );
    }
    return child;
  }
}

void main() async {
  // Ensure Flutter binding is initialized before calling SystemChrome
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("[DotEnv Warning] Could not load .env file directly: $e");
  }

  // Workaround Windows desktop key event glitch (Alt key modifier mismatch in debug)
  FlutterError.onError = (FlutterErrorDetails details) {
    final msg = details.exceptionAsString();
    if (msg.contains(
      'Attempted to send a key down event when no keys are in keysPressed',
    )) {
      debugPrint('[Keyboard Warning Suppressed] $msg');
      return;
    }
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    final msg = error.toString();
    if (msg.contains(
      'Attempted to send a key down event when no keys are in keysPressed',
    )) {
      debugPrint('[Keyboard Platform Error Suppressed] $msg');
      return true;
    }
    return false;
  };

  // Initialize window manager for desktop
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    try {
      await windowManager.ensureInitialized();

      final isAlreadyVisible = await windowManager.isVisible();

      if (!isAlreadyVisible) {
        // Cold Start (Aplikasi Baru Dibuka): Default Layar Penuh (Maximized)
        WindowOptions windowOptions = const WindowOptions(
          size: Size(1440, 900),
          minimumSize: Size(400, 700),
          center: true,
          backgroundColor: Colors.transparent,
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.normal,
        );

        await windowManager.waitUntilReadyToShow(windowOptions, () async {
          await windowManager.show();
          await windowManager.focus();
          await windowManager.maximize();
        });
      } else {
        // Hot Restart (Sedang Berjalan): Pertahankan ukuran jendela yang sedang aktif tanpa dipaksa ubah
        await windowManager.show();
        await windowManager.focus();
      }
    } catch (e) {
      debugPrint('Window Manager failed to initialize: $e');
    }
  }

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set error widget builder for better error handling
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: AppTheme.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.danger,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Terjadi kesalahan pada aplikasi',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Silakan restart aplikasi atau hubungi support jika masalah berlanjut.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const DashboardScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Aplikasi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, auth, themeProvider, _) {
          return MultiProvider(
            key: ValueKey(auth
                .activeCompany), // Recreate all data providers when company changes
            providers: [
              ChangeNotifierProxyProvider<AuthProvider, NotificationProvider>(
                create: (context) =>
                    NotificationProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? NotificationProvider(auth.api);
                  p.updateStatus(auth.isLoggedIn);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, SettlementProvider>(
                create: (context) => SettlementProvider(),
                update: (context, auth, prev) => prev!..updateToken(auth.token),
              ),
              ChangeNotifierProxyProvider<AuthProvider, AdvanceProvider>(
                create: (context) =>
                    AdvanceProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? AdvanceProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, RevenueProvider>(
                create: (context) =>
                    RevenueProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? RevenueProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, TaxProvider>(
                create: (context) =>
                    TaxProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? TaxProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, DividendProvider>(
                create: (context) =>
                    DividendProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? DividendProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, BankManagementProvider>(
                create: (context) =>
                    BankManagementProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? BankManagementProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, BankStatusProvider>(
                create: (context) =>
                    BankStatusProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? BankStatusProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProxyProvider<AuthProvider, AssetProvider>(
                create: (context) =>
                    AssetProvider(context.read<AuthProvider>().api),
                update: (context, auth, prev) {
                  final p = prev ?? AssetProvider(auth.api);
                  p.updateToken(auth.token);
                  return p;
                },
              ),
              ChangeNotifierProvider(create: (_) => CascadeProvider()),
            ],
            child: MaterialApp(
              title: 'ExspanApp',
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              navigatorKey: navigatorKey,
              scrollBehavior: MyCustomScrollBehavior(),
              home: !auth.isInitialized
                  ? const LoadingScreen()
                  : (auth.isServerDown
                      ? const ServerErrorScreen()
                      : const AuthWrapper()),
            ),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoggedIn) {
      return const DashboardScreen();
    }
    return const LoginScreen();
  }
}
