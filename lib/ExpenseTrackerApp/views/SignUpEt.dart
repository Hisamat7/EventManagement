import 'package:firebaselearning/ExpenseTrackerApp/Widgets/ButtonWidgetEt.dart';
import 'package:firebaselearning/ExpenseTrackerApp/Widgets/TextFormEtWidget.dart';
import 'package:firebaselearning/ExpenseTrackerApp/services/AuthControllerEt.dart';
import 'package:firebaselearning/NotePadApp/Src/controllers/AuthController.dart';
import 'package:flutter/material.dart';

class SignUpEt extends StatefulWidget {
  const SignUpEt({super.key});

  @override
  State<SignUpEt> createState() => _SignUpEtState();
}

class _SignUpEtState extends State<SignUpEt> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthControllerEt authController = AuthControllerEt();
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
            TextFormEtWidget(label: "Name", hint: "Enter your name", controller: nameController, validator: (value) => value!.isEmpty ? 'Enter an name' : null, ),
            const SizedBox(height: 20,),
            TextFormEtWidget(label: "Email", hint: "Enter your email", controller: emailController, validator: (value) => value!.isEmpty ? 'Enter an email' : null, ),
            const SizedBox(height: 20,),
            TextFormEtWidget(label: "Password", hint: "Enter your password", controller: passwordController, validator: (value) => value!.isEmpty ? 'Enter an password' : null, ),
            SizedBox(
              height: 40,
            ),
            ButtonWidgetEt(text: "Sign Up", onPress: ()async{
              if(formKey.currentState!.validate()){
             await   authController.register( email: emailController.text, password: passwordController.text, context: context);
              }
            }),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(onPressed: (){}, child: const Text("Sign in", style: TextStyle(color: Colors.pinkAccent),),)
              ],
            )
          ],
        ),
      ),
      ),
    );
  }
}