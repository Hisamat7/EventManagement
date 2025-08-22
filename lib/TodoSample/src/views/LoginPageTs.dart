import 'package:firebaselearning/TodoSample/src/controllers/AuthTs.dart';
import 'package:firebaselearning/TodoSample/src/views/RegisterPageTs.dart';
import 'package:firebaselearning/TodoSample/src/widgets/ButtonWidgetTs.dart';
import 'package:firebaselearning/TodoSample/src/widgets/TextFieldTs.dart';
import 'package:flutter/material.dart';

class LoginPageTs extends StatefulWidget {
  

  @override
  State<LoginPageTs> createState() => _LoginPageTsState();
}

class _LoginPageTsState extends State<LoginPageTs> {
  final auth = AuthTs();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldTs(text: "Email", controller: emailController,hintText: "Enter your email",validator: (p0) => p0!.isEmpty ? 'Enter an email' : null,),
            SizedBox(height: 20,),
            TextFieldTs(text: "Password", controller: passwordController,hintText: "Enter your password",validator: (p0) => p0!.isEmpty ? 'Enter an password' : null,),
            SizedBox(height: 50,),
            ButtonWidgetTs(text: "Login", onClicked: (){
              auth.login(email: emailController.text, password: passwordController.text, context: context);
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>RegisterPageTs()));
                }, child: Text("Sign Up"))
              ],
            )
          ],
        ),
      ),
    );
  }
}