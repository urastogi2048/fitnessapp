import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:frontendd/features/auth/questionnaire.dart';
import 'package:frontendd/features/home/homescreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontendd/features/auth/authprovider.dart';

class SignUpPage extends ConsumerWidget {
   SignUpPage({super.key});
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  return emailRegex.hasMatch(email);
}
 bool isValidPassword(String password) {
  return password.length >= 6;
}

  @override
  
  Widget build(BuildContext context, WidgetRef ref) {
    final authstate = ref.watch(authProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
  if (authstate.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(authstate.error!)),
    );
  }
  
});

    if(authstate.isLoading) {
      return Scaffold ( body : Center(
        child: CircularProgressIndicator(),
      ));
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
                          "Start Training",
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
                        _inputField("Username",  usernameCtrl, isPassword: false),
                        const SizedBox(height: 16),
                        _inputField("Email", emailCtrl, isPassword: false),
                        const SizedBox(height: 16),
                        _inputField("Password", passwordCtrl, isPassword: true),

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
                              final email = emailCtrl.text.trim();
                                final password = passwordCtrl.text;
                                final username = usernameCtrl.text.trim();

                                if (username.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Username cannot be empty")),
                                  );
                                  return;
                                }

                                if (!isValidEmail(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please enter a valid email address")),
                                  );
                                  return;
                                }

                                    if (!isValidPassword(password)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Password must be at least 6 characters long"),
                                        ),
                                      );
                                      return;
                                    }

                              ref.read(authProvider.notifier).signup(
                                usernameCtrl.text,
                               
                                emailCtrl.text,
                                passwordCtrl.text,
                              );
                              if ( authstate.error == null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => LoginPage()),
                                      );
                                    }
                              },
                            child:  Text(
                              "Sign Up",
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
                                "Already have an account? ",
                                style: TextStyle(color: Colors.white70, fontFamily: GoogleFonts.poppins().fontFamily,),
                              ),
                              GestureDetector(
                                onTap: () {
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  LoginPage()),
                                  );
                                },
                                child: Text(
                                  "Log In",
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

  static Widget _inputField(String hint, TextEditingController controller,{bool isPassword = false} ) {
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
