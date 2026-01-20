import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontendd/features/auth/authprovider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late TextEditingController usernameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController passwordCtrl;

  @override
  void initState() {
    super.initState();
    usernameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final authstate = ref.watch(authProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authstate.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(authstate.error!)),
    );
  }
  
});

    // Don't show loading here - it breaks the flow
    // The signup button has inline success/error handling
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
                            onPressed: () async {
  final email = emailCtrl.text.trim();
  final password = passwordCtrl.text;
  final username = usernameCtrl.text.trim();

  if (username.isEmpty || !isValidEmail(email) || !isValidPassword(password)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields correctly")),
    );
    return;
  }

  await ref.read(authProvider.notifier).signup(username, email, password);

  // Use the latest state to check if signup was successful
  final currentState = ref.read(authProvider);
  if (currentState.error == null && !currentState.isLoading) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please Log In.")),
      );
      // Pop back to LoginPage (previous page on stack)
      Navigator.pop(context);
    }
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
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  LoginPage()),
                                    );
                                  }
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
