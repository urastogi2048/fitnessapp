
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/core/onboardingstorage.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:frontendd/features/auth/signup.dart';
import 'package:frontendd/features/home/homescreen.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/auth/authstate.dart';

void main() {
  runApp(
  const ProviderScope(
    child: MainApp(),
  ),
  );

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

   
     
     
        
        if (authState.isLoading || authState.isuserloading ) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
       // final onboardingDone = snapshot.data ?? false;
        if (!authState.isAuthenticated) {
          return LoginPage();
        }
//       if (authState.onboardingCompleted == null) {
// //          ////////////////////////////////// ref.read(authProvider.notifier).fetchCurrentUser();
//    return const Scaffold(
//      body: Center(child: Text("Loading...")),
//    );
//  }
if (authState.onboardingCompleted == null) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

if (authState.onboardingCompleted == false) {
  return QuestionnairePage();
}

return const HomeScreen();

      
    
  }
}

  