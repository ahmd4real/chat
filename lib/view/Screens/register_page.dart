
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = 'registerPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;

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
                        text: 'Sign Up',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            loading = true;
                            setState(() {});
                            // try {
                            //   await registerUser();
                            //   Navigator.pushNamed(context, ChatPage.id);
                            // } on catch (e) {
                            //   if (e.code == 'weak-password') {
                            //     snackBar(context, 'Weak password');
                            //   } else if (e.code == 'email-already-in-use') {
                            //     snackBar(context,
                            //         'Email already in use try another one');
                            //   }
                            // }
                            loading = false;
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      // style:
                      //     TextStyle(color: Color.fromARGB(255, 206, 230, 218))
                          ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> registerUser() async {
  //   UserCredential user = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email!, password: password!);
  // }
}
