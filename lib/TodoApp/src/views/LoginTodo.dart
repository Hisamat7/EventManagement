import 'package:firebaselearning/TodoApp/src/Controller/AuthControllerTodo.dart';
import 'package:firebaselearning/TodoApp/src/views/RegisterTodo.dart';
import 'package:firebaselearning/TodoApp/src/widgets/ButtonWidgetTodo.dart';
import 'package:firebaselearning/TodoApp/src/widgets/TextFieldWidgetTodo.dart';
import 'package:flutter/material.dart';

class LoginTodo extends StatefulWidget {
  const LoginTodo({super.key});

  @override
  State<LoginTodo> createState() => _LoginTodoState();
}

class _LoginTodoState extends State<LoginTodo> {
  final formKey = GlobalKey<FormState>();
  final _auth = AuthControllerTodo();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldWidgetTodo(
                controller: emailController,
                hintText: "enter your email",
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                label: "Email",
              ),
              const SizedBox(height: 20),
              TextFieldWidgetTodo(
                controller: passwordController,
                hintText: "enter your password",
                validator: (value) => value!.isEmpty ? 'Enter an password' : null,
                label: "Password",
              ),
              const SizedBox(height: 20),
              ButtonWidgetTodo(onPress: () async{
                if (formKey.currentState!.validate()) {
               await   _auth.login(
                      email: emailController.text,
                      password: passwordController.text,
                      context: context);
                }
              }, text: "Login"),
              SizedBox(
                height: 30,
              ),
              Row(
          
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterTodo()));
                  }, child: Text("Sign Up", style: TextStyle(color: Colors.orange),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
