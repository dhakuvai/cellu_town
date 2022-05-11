import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cellu_town/components/background.dart';
import 'package:cellu_town/components/custom_button.dart';
import 'package:cellu_town/components/custom_textformfield.dart';
import 'package:cellu_town/controllers/auth_controller.dart';
import 'package:cellu_town/screens/signup_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: Get.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.grey,
                  Colors.white,
                  Colors.green,
                ])),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: Get.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('LOGIN',
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Login To Your Account',
                        style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )),
                        SizedBox(height: 10.0),
                        CustomTextField(
                          customValidator: (value) {
                            //email validation
                            final bool isValid = EmailValidator.validate(value);
                            if (!isValid) {
                              return 'Please enter a valid email';
                            }
                          },
                          controller: user,
                          obscureText: false,
                          hintText: 'Please enter your email',
                        ),
                        SizedBox(height: 20.0),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )),
                        SizedBox(height: 10.0),
                        CustomTextField(
                          controller: pass,
                          obscureText: true,
                          hintText: 'Please enter your password',
                        ),
                        SizedBox(height: 40.0),
                        CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                authController.login(
                                    email: user.text, password: pass.text);
                              }
                            },
                            label: 'Login'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Doesn't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(SignupScreen());
                        },
                        child: const Text(' Sign Up',
                            style: TextStyle(color: Colors.red, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
