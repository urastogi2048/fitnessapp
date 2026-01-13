import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/home/homescreen.dart';
import 'package:frontendd/features/weeklyworkout/exercisemodel.dart';
import 'package:frontendd/features/weeklyworkout/exerciseui.dart';

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
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      ref.read(authProvider.notifier).checkAuthStatus();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!auth.isAuthenticated) {
      return LoginPage();
    }

    if (!auth.onboardingCompleted) {
      return  QuestionnairePage();
    }

    return  HomeScreen();
  }
}