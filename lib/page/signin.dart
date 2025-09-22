import 'package:feszora/layout/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _obscurePassword = true; // 👈 track password visibility

  // Fake login function (replace with Firebase/Django/etc.)
  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $email")),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In: ${account.displayName}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back 👋",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 30),
               OutlinedButton.icon(
                onPressed: _loginWithGoogle,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: SvgPicture.asset(
                  "animations/google.svg", // 👈 use downloaded Google SVG
                  height: 24,
                ),
                label:  Text(
                  "Sign in with Google",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
                const SizedBox(height: 30),
                // ignore: prefer_const_constructors
                Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),


              // Email field
             TextField(
  controller: _emailController,
  decoration: InputDecoration(
    hintText: "Email",
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 1.5), // 👈 normal
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black87, width: 2), // 👈 focused
    ),
  ),
),

              const SizedBox(height: 16),

              // Password field with toggle
TextField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    hintText: "Password",
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 1.5), // 👈 normal
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black87, width: 2), // 👈 focused
    ),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey[600], // 👈 optional color for icon
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),
),

               const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                        Text("Forget Password ?",
                        style: Theme.of(context).textTheme.bodySmall ,
                        )
                ],
              ),
              const SizedBox(height: 30),

              // Login button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  

                ),
                child: const Text("Login",style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),),
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                          Text("Don't have an accout?",
                          style: Theme.of(context).textTheme.bodySmall ,
                          ),
                          Text("Sign Up",
                          style: Theme.of(context).textTheme.bodySmall ,
                          )
                  ],
                               ),
               ),
              // Divider
            
              // Google Sign-In button
             
            ],
          ),
        ),
      ),
    );
  }
}
