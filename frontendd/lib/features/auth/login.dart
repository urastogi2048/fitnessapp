import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/core/onboardingstorage.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/auth/signup.dart';
import 'package:frontendd/features/home/homescreen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends ConsumerWidget {
   LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
@override
Widget build(BuildContext context, WidgetRef ref) {
  
  final authstate = ref.watch(authProvider);
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (authstate.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authstate.error!)),
      );
    }
    if (authstate.isAuthenticated)  {
      final onboardingCompleted = await  OnboardingStorage.isCompleted();
      if(!onboardingCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => QuestionnairePage()),
        );
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  });

  if (authstate.isLoading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  return Scaffold(
      body: Stack(
        children: [
         
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bgg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

         
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.oswald().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          "Build strength. Stay consistent.",
                          style: TextStyle(color: Colors.white70, fontFamily: GoogleFonts.poppins().fontFamily,),
                        ),

                        const SizedBox(height: 24),
                        
                        _inputField("Email", emailController),
                        const SizedBox(height: 16),
                        _inputField("Password", passwordController, isPassword: true),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 145, 3, 3),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              ref.read(authProvider.notifier).login(
                            emailController.text.trim(),
                                  passwordController.text.trim(),
                               );
                            },
                            child:  Text(
                              "Login",
                              style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: GoogleFonts.poppins().fontFamily,),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.white70, fontFamily: GoogleFonts.poppins().fontFamily,),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to signup page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _inputField(String hint, TextEditingController controller,{bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style:  TextStyle(color: Colors.white, fontFamily: GoogleFonts.poppins().fontFamily,),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white60, fontFamily: GoogleFonts.poppins().fontFamily,),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
