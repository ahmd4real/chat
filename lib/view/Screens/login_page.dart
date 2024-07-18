import 'package:chat/API/api.dart';
import 'package:chat/constants.dart';


import 'package:chat/view/Screens/signup_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'loginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Image.asset('assets/images/logo.png'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      const SizedBox(height: 16,),
                      CustomTextFormField(
                        controller: emailController,
                        hidden: false,
                        hintText: 'Email',
                      ),
                      CustomTextFormField(
                        controller: passwordController,
                        hidden: true,
                        hintText: 'Password',
                      ),
                      CustomButton(
                        text: 'Login',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            login(
                                emailController.text, passwordController.text);

                            setState(() {
                              loading = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.id);
                              
                        },
                        child: const Text(
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600),
                          'Sign Up',
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login(String email, String password) {
    API().post(
      url: '${baseUrl}Login',
      body: {
        "email": email,
        "password": password,
      },
    );
  }
}
