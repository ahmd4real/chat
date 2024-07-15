import 'package:chatapp/Ui/Screens/chat_page.dart';
import 'package:chatapp/Ui/Screens/register_page.dart';
import 'package:chatapp/Ui/Widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../helper/show_snackbar.dart';
import '../Widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'loginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;
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
                  hidden: false,
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                      CustomTextFormField(
                  hidden: true,
                  hintText: 'Password',
                  onChanged: (data) {
                    password = data;
                  },
                ),
                CustomButton(
                  text: 'Login',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          snackBar(context, 'User not found');
                        } else if (e.code == 'wrong-password') {
                          snackBar(context, 'Wrong password');
                        }
                      }
                
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

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
