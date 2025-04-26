import 'package:firebaselearning/NotePadApp/Src/widgets/ButtonWidget.dart';
import 'package:firebaselearning/NotePadApp/Src/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/RegisterScreenPage.dart';
import 'package:firebaselearning/NotePadApp/Src/controllers/AuthController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = AuthController(); // Renamed from LoginController for consistency

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldWidget(
                  labeltext: "Email",
                  hinttext: "Enter your email",
                  controller: emailController,
                  validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  labeltext: "Password",
                  hinttext: "Enter your password",
                  controller: passwordController,
                 
                  validator: (value) => value!.isEmpty ? 'Enter a password' : null,
                ),
                const SizedBox(height: 30),
                ButtonWidget(
                  text: "Login",
                  onClicked: () async {
                    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }
                    await authController.login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      context: context,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreenPage()),
                      ),
                      child: const Text(
                        " Register",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}