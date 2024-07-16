import 'package:chat/view/Screens/register_page.dart';
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
                  
                  child: Column(
                    children: [
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
                      // try {
                      //   await loginUser();
                      //   Navigator.pushNamed(context, ChatPage.id,
                      //       arguments: email);
                      // } on FirebaseAuthException catch (e) {
                      //   if (e.code == 'user-not-found') {
                      //     snackBar(context, 'User not found');
                      //   } else if (e.code == 'wrong-password') {
                      //     snackBar(context, 'Wrong password');
                      //   }
                      // }
                
                      setState(() {
                        loading = false;
                      });
                       print(
                            'email ${emailController.text} password ${passwordController.text}',
                          );
                    }
                  },
                ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:16.0),
                child: Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                    ),
                    GestureDetector(
                        onTap: () {
                         
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          style: TextStyle(decoration:TextDecoration.underline ,fontWeight: FontWeight.w600),
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

  // Future<void> loginUser() async {
  //   UserCredential user = await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(email: email!, password: password!);
  // }
}
