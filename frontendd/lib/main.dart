import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/home/homescreen.dart';
import 'package:frontendd/services/notificationservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await NotificationService().initialize();
    await NotificationService().requestPermissions();
  } catch (e) {
    print('❌ Error initializing Notification Service: $e');
  }
  runApp(const ProviderScope(child: MainApp()));
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
        body: Center(
          child: CircularProgressIndicator(),
        ),
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