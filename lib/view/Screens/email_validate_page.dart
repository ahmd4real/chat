import 'package:chat/API/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:chat/view/Screens/register_page.dart';
import 'package:chat/view/Screens/verificaton_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_form_field.dart';

class EmailValidatePage extends StatefulWidget {
  const EmailValidatePage({super.key});
  static String id = 'emailValidatePage';

  @override
  State<EmailValidatePage> createState() => _EmailValidatePageState();
}

class _EmailValidatePageState extends State<EmailValidatePage> {
  TextEditingController emailController = TextEditingController();

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
                        controller: emailController,
                        hidden: false,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomButton(
                        text: 'Continue',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            loading = true;
                            setState(() {});
                            sendVerifyCode(emailController.text, false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerificationCodePage(
                                        email: emailController.text,
                                      )),
                            );
                            loading = false;
                            setState(() {});
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
                      'Already have an account? ',
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginPage.id);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600),
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

  void sendVerifyCode(String email, bool reset) {
    API().post(
      url: '${baseUrl}SendCode',
      body: {
        "email": email,
        "reset": reset, //true reset password false send code/verify email
      },
    );
  }
}
