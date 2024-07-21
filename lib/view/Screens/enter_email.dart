import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:chat/view/Screens/verificaton_code_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EnterYourEmail extends StatelessWidget {
   EnterYourEmail({super.key});
   static String id = 'EnterYourEmail';
   TextEditingController verifyCodeController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        validator: emailValidator,
                      ),

                      CustomTextFormField(
                        controller: passwordController,
                        hidden: true,
                        hintText: 'New Password',
                        
                      ),
                       CustomTextFormField(
                        controller: confirmPasswordController,
                        hidden: true,
                        hintText: 'Confirm New Password',
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
                            
                           await sendVerifyCode(
                                emailController.text, true,)?
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  VerificationCodePage
                                  (
                                    email: emailController.text,
                                    resetPass: true,
                                       newPassword: passwordController.text,
                                      )),
                            ):ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to send verification code, please try again'),
                              ),
                            );
                            
                            
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
      );
  }
}