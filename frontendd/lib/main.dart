import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/home/homescreen.dart';
import 'package:frontendd/services/notificationservice.dart';
import 'dart:async';
import 'package:frontendd/core/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global handlers to prevent stack traces / sensitive data from being
  // printed in release builds. In debug non-release mode details are
  // still available via Logger.
  FlutterError.onError = (details) {
    Logger.error('Flutter framework error', details.exception, details.stack);
    if (!isInDebugMode) {
      // swallow in non-debug (release) mode
      return;
    }
    FlutterError.presentError(details);
  };

  await runZonedGuarded(() async {
    try {
      await NotificationService().initialize();
      final granted = await NotificationService().requestPermissions();
      if (granted) {
        await NotificationService().scheduleDailyStreakReminder();
        Logger.debug('Daily streak reminder scheduled automatically on app start');
      }
    } catch (e, st) {
      Logger.error('Error initializing Notification Service', e, st);
    }

    runApp(const ProviderScope(child: MainApp()));
  }, (error, stack) {
    Logger.error('Uncaught error', error, stack);
  });
}

bool get isInDebugMode {
  var inDebug = false;
  assert(inDebug = true);
  return inDebug;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
        );
      },
    );
  }
}

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _isInitialCheck = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authProvider.notifier).checkAuthStatus();
      if (mounted) {
        setState(() => _isInitialCheck = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (_isInitialCheck) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!auth.isAuthenticated) {
      return LoginPage();
    }

    if (!auth.onboardingCompleted) {
      return QuestionnairePage();
    }

    return HomeScreen();
  }
}
