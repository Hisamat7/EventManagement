import 'package:firebaselearning/TodoSample/src/controllers/AuthTs.dart';
import 'package:firebaselearning/TodoSample/src/widgets/ButtonWidgetTs.dart';
import 'package:firebaselearning/TodoSample/src/widgets/TextFieldTs.dart';
import 'package:flutter/material.dart';

class RegisterPageTs extends StatefulWidget {
  const RegisterPageTs({super.key});

  @override
  State<RegisterPageTs> createState() => _RegisterPageTsState();
}

class _RegisterPageTsState extends State<RegisterPageTs> {
  final auth = AuthTs();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldTs(text: "Email", controller: emailController, hintText: "Enter your email", validator: (p0) => p0!.isEmpty ? 'Enter an email' : null,),
            const SizedBox(height: 20,),
            TextFieldTs(text: "Password", controller: passwordController, hintText: "Enter your password", validator: (p0) => p0!.isEmpty ? 'Enter an password' : null,),
            const SizedBox(height: 50,),
            ButtonWidgetTs(text: "Register", onClicked: (){
              auth.register(email: emailController.text, password: passwordController.text, context: context);
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("Sign In"))
              ],
            )
          ],
        ),
      ),
    );
  }
}