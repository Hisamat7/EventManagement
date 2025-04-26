import 'package:firebaselearning/controllers/LoginController.dart';
import 'package:firebaselearning/views/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LoginController loginController = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text("Login Page", style: TextStyle(color: Colors.yellowAccent)),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: emailController,
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "enter your email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreenAccent),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: passwordController,
                obscureText: _isObscure,
                style: TextStyle(color: Colors.white),
                validator:
                    (value) => value!.isEmpty ? 'Enter a password' : null,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "enter your password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreenAccent),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200.w, 50.h),
                  backgroundColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () async{
                  if(formKey.currentState!.validate()){
                    await loginController.login(email: emailController.text, password: passwordController.text, context: context);
                  }
                },
                child: Text("Login", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 40.h),
             
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 GestureDetector(
                  onTap: ()async{
                 await   loginController.googleLogin(context: context);
                  },
                   child: Container(
                     height: 50.h,
                     width: 50.w,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: Colors.white
                     ),
                    child: Image.asset("asset/image/google-icon 1.png", )),
                 ),
                 SizedBox(width: 20.w),
                 Container(
                   height: 50.h,
                   width: 50.w,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color: Colors.white
                   ),
                  child: Image.asset("asset/image/facebook-3 1.png", )),
               ],
             ),
             SizedBox(
               height: 20.h,
             ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.tealAccent),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
