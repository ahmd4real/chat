
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/services/services.dart';

import 'package:chat/view/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/custom_text_form_field.dart';

class VerificationCodePage extends StatefulWidget {
  VerificationCodePage(
      {super.key,
      required this.email,
      this.resetPass = false,
      this.newPassword = ""});
      static String id = 'VerificationCodePage';
      final String email;
      final bool resetPass;
      late String newPassword;

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
                            if (await validateCode(
                              widget.email,
                              verifyCodeController.text,
                              isForResetPassword: widget.resetPass
                            )) {
                              if (widget.resetPass) {
                                if (await resetPassword(
                                    widget.email, widget.newPassword)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Password Reset Successful'),
                                  ));
                                  await login(widget.email, widget.newPassword);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Failed to Reset Password'),
                                  ));
                                }
                              } else {
                                await login(widget.email, widget.newPassword);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Invalid verification code'),
                              ));
                              
                              
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
            ],
          ),
        ),
      ),
    );
  }
}
