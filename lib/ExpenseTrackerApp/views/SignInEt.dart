import 'package:firebaselearning/ExpenseTrackerApp/Widgets/ButtonWidgetEt.dart';
import 'package:firebaselearning/ExpenseTrackerApp/Widgets/TextFormEtWidget.dart';
import 'package:firebaselearning/ExpenseTrackerApp/services/AuthControllerEt.dart';
import 'package:firebaselearning/ExpenseTrackerApp/views/SignUpEt.dart';
import 'package:flutter/material.dart';

class SignInEt extends StatefulWidget {
  const SignInEt({super.key});

  @override
  State<SignInEt> createState() => _SignInEtState();
}

class _SignInEtState extends State<SignInEt> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthControllerEt authController = AuthControllerEt();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false ,
      body: Padding(padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormEtWidget(label: "Email", hint: "Enter your email", controller: emailController, validator: (value) => value!.isEmpty ? 'Enter an email' : null, ),
            const SizedBox(height: 20,),
            TextFormEtWidget(label: "Password", hint: "Enter your password", controller: passwordController, validator: (value) => value!.isEmpty ? 'Enter an password' : null, ),
            const SizedBox(height: 40,),
            ButtonWidgetEt(text: "Sign In", onPress: ()async{
              if(formKey.currentState!.validate()){
              await authController.login(email: emailController.text, password: passwordController.text, context: context);
              }
            }),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpEt()));
                }, child: const Text("Sign Up", style: TextStyle(color: Colors.pinkAccent),),)
              ],
            )
          ],
        ),
      )),
    );
  }
}