import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/home/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
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
    // Check auth status once on app startup
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

    // Show loading during initial check or during login/signup
    if (_isInitialCheck) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Not authenticated -> show login
    if (!auth.isAuthenticated) {
      return LoginPage();
    }

    // Authenticated but not onboarded -> show questionnaire
    if (!auth.onboardingCompleted) {
      return QuestionnairePage();
    }

    // Authenticated and onboarded -> show home
    return HomeScreen();
  }
}