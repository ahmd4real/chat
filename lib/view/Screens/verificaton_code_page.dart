import 'package:chat/API/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/services/services.dart';

import 'package:chat/view/Widgets/custom_button.dart';

import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/custom_text_form_field.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key, required this.email});
  static String id = 'VerificationCodePage';
  final String email;
  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  TextEditingController verifyCodeController = TextEditingController();
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
                        controller: verifyCodeController,
                        hidden: false,
                        hintText: 'Enter your verification code',
                      ),
                      CustomButton(
                        text: 'Continue',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            validateVerificationCode(
                                widget.email, verifyCodeController.text,);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage(
                                       
                                      )),
                            );
                            
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
            ],
          ),
        ),
      ),
    );
  }

  
}
