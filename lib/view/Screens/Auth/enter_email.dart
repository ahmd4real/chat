import 'package:chat/core/utils/constants.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:chat/view/Screens/Auth/verificaton_code_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EnterYourEmail extends StatefulWidget {
  const EnterYourEmail({super.key});
  static String id = 'EnterYourEmail';
  
  @override
  State<EnterYourEmail> createState() => _EnterYourEmailState();
}

class _EnterYourEmailState extends State<EnterYourEmail> {
  TextEditingController verifyCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  final AuthServices authService = AuthServices(baseUrl: baseUrl);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(color: mainColor,),
      inAsyncCall: loading,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.08 + 16,
                    ),
                    child:  Text('Reset Password',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: kDarkGrey,
                            fontSize: 48, fontWeight: FontWeight.bold)),
                  
                  ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: emailController,
                      hidden: false,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                      prefixIcon:Icons.email_outlined,
                    ),
                    CustomTextFormField(
                       prefixIcon:Icons.key_outlined,
                      controller: passwordController,
                      hidden: true,
                      labelText: 'New Password',
                    ),
                    CustomTextFormField(
                       prefixIcon:Icons.key_outlined,
                      controller: confirmPasswordController,
                      hidden: true,
                      labelText: 'Confirm New Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is Required';
                        }
                        if (!passwordMatched(
                            passwordController.text, value)) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    CustomButton(
                      text: 'Continue',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          await authService.sendVerifyCode(
                            emailController.text,
                            true,
                          )
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerificationCodePage(
                                            email: emailController.text,
                                            resetPass: true,
                                            newPassword:
                                                passwordController.text,
                                          )),
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Failed to send verification code, please try again'),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
