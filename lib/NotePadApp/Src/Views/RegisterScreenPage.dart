import 'package:firebaselearning/NotePadApp/Src/controllers/AuthController.dart';
import 'package:firebaselearning/NotePadApp/Src/widgets/ButtonWidget.dart';
import 'package:firebaselearning/NotePadApp/Src/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';

class RegisterScreenPage extends StatefulWidget {
  const RegisterScreenPage({super.key});

  @override
  State<RegisterScreenPage> createState() => _RegisterScreenPageState();
}

class _RegisterScreenPageState extends State<RegisterScreenPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldWidget(
              controller:nameController,
              labeltext: "Name",
              hinttext: "Enter your name",
              validator: (value) => value!.isEmpty ? 'Enter an name' : null,
            ),
            SizedBox(height: 20),
            TextFieldWidget(
              controller: emailController,
              labeltext: "Email",
              hinttext: "Enter your email",
              validator: (value) => value!.isEmpty ? 'Enter an email' : null,
            ),
            SizedBox(height: 20),
            TextFieldWidget(
              controller: passwordController,
              labeltext: "Password",
              hinttext: "Enter an Password",
              validator: (value) => value!.isEmpty ? 'Enter an password' : null,
            ),
            SizedBox(height: 40),
            ButtonWidget(text: "Register", onClicked: () async{
          await    authController.register(email: emailController.text, password: passwordController.text, context: context);
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
