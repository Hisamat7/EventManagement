import 'package:firebaselearning/controllers/SignUpController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    required hint,
  }) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightGreenAccent),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(10.r),
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  bool _isObscure = false;
  SignUpController signUpcontroller = SignUpController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.yellowAccent),
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          "Sign Up Page",
          style: TextStyle(color: Colors.yellowAccent),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField(
                label: "Name",
                controller: nameController,
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                hint: "enter your name",
              ),
              SizedBox(height: 20.h),
              buildTextField(
                label: "Email",
                controller: emailController,
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                hint: "enter your email",
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
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await signUpcontroller.signUp(
                      context: context,
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  }
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
