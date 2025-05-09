import 'package:firebaselearning/TodoApp/src/Controller/AuthControllerTodo.dart';
import 'package:firebaselearning/TodoApp/src/widgets/ButtonWidgetTodo.dart';
import 'package:firebaselearning/TodoApp/src/widgets/TextFieldWidgetTodo.dart';
import 'package:flutter/material.dart';

class RegisterTodo extends StatefulWidget {
  const RegisterTodo({super.key});

  @override
  State<RegisterTodo> createState() => _RegisterTodoState();
}

class _RegisterTodoState extends State<RegisterTodo> {
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthControllerTodo();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldWidgetTodo(controller: nameController, hintText: "enter your name", validator: (value) => value!.isEmpty ? 'Enter an name' : null, label: "Name",),
              SizedBox(
                height: 20,
              ),
              TextFieldWidgetTodo(controller: emailController, hintText: "enter your email", validator: (value) => value!.isEmpty ? 'Enter an email' : null, label: "Email",),
              SizedBox(
                height: 20,
              ),
              TextFieldWidgetTodo(controller: passwordController, hintText: "enter your password", validator: (value) => value!.isEmpty ? 'Enter an password' : null, label: "Password",),
              SizedBox(
                height: 20,
              ),
              ButtonWidgetTodo(onPress: () async{
                if (_formKey.currentState!.validate()) {
                await  _authController.register(email: emailController.text, password: passwordController.text, context: context);
                }
              }, text: "Register"),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("Login"),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}