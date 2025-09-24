import 'package:feszora/ApI/signupapi.dart';
import 'package:feszora/layout/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}
bool _obscurePassword = true;








class _SignupPageState extends State<SignupPage> {
  final _fullName = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _comfirmpasswordController = TextEditingController();


String? _fullNameError;
String? _emailError;
String? _passwordError;
String? _confirmError;
String? _bannerError;



Future<void> _signup() async {
  setState(() {
    _fullNameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmError = null;
    _bannerError = null;
  });

  final fullname = _fullName.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _comfirmpasswordController.text.trim();

  if (fullname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    setState(() {
      if (fullname.isEmpty) _fullNameError = "Full name is required";
      if (email.isEmpty) _emailError = "Email is required";
      if (password.isEmpty) _passwordError = "Password is required";
      if (confirmPassword.isEmpty) _confirmError = "Confirm password is required";
      _bannerError = "Please fill in all required fields";
    });
    return;
  }



  if (password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password != confirmPassword) {
    _bannerError = "Passwords do not match";
  }

 final result = await SignupApi.signup(
    fullname: fullname,
    email: email,
    password: password,
  );

  if (result["success"]) {
    // ✅ Success → navigate to login
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully! Please login."),
          backgroundColor: Colors.green,
        ),
      );

      // Replace current screen with login page
      Navigator.pushReplacementNamed(context, "/login");
    }
  } else {
    // ❌ API returned error
    setState(() {
      _bannerError = result["error"]["detail"] ?? "Signup failed, try again";
    });
  }


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create Account", style:Theme.of(context).textTheme.displayLarge,),
                  const SizedBox(height: 20),
          
                   if (_bannerError != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade400),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_outlined, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _bannerError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: _fullName,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      error: _fullNameError == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_outlined, size: 16, color:AppColors.error),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _fullNameError!,
                    style: const TextStyle(color:AppColors.error),
                  ),
                ),
              ],
            ),
                     
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black87, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.red.shade400, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                       error: _emailError == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_outlined, size: 16, color:AppColors.error),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _emailError!,
                    style: const TextStyle(color:AppColors.error),
                  ),
                ),
              ],
            ),
                     
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black87, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.red.shade400, width: 2),
                      ),
                    ),
                  ),
          
          
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      error: _passwordError == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_outlined, size: 16, color:AppColors.error),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _passwordError!,
                    style: const TextStyle(color:AppColors.error),
                  ),
                ),
              ],
            ),
                     
                     
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black87, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.red.shade400, width: 2),
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      }, icon:Icon(_obscurePassword
                      ?Icons.visibility_off:
                      Icons.visibility,
                      ) )
                    ),
                  ),
          
                  const SizedBox(height: 16),
          
                  TextField(
                    controller: _comfirmpasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      
                      error: _confirmError == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_outlined, size: 16, color:AppColors.error),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _confirmError!,
                    style: const TextStyle(color:AppColors.error),
                  ),
                ),
              ],
            ),
                   
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black87, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.red.shade400, width: 2),
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          _obscurePassword =!_obscurePassword;
                        });
                      }, icon: Icon(
                        _obscurePassword 
                        ? Icons.visibility_off
                        :Icons.visibility
                      ))
                    ),
                  ),
          
                  const SizedBox(height: 16),
                   ElevatedButton(
                    onPressed:_signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          const SizedBox(height: 16),
                const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("OR SignUp With"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
          
                   OutlinedButton.icon(
                    onPressed: (){},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: SvgPicture.asset("assets/animations/google.svg",
                        height: 24),
                    label: Text("Sign in with Google",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
          
                   
                ],
              ),
            ),
          ),
        ),
      ),  
    );
  }
}