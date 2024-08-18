import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/BLoCs/Verification/verification_bloc.dart';
import 'package:chat/models/BLoCs/Verification/verification_event.dart';
import 'package:chat/models/BLoCs/Verification/verification_state.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../home_page.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage({
    super.key,
    required this.email,
    this.resetPass = false,
    this.newPassword = "",
  });
  static String id = 'VerificationCodePage';
  final String email;
  final bool resetPass;
  late String newPassword;

  TextEditingController verifyCodeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCodeBloc, VerificationCodeState>(
      listener: (context, state) {
        if (state is VerificationCodeLoading) {
          // Show loading
        } else if (state is VerificationCodeSuccess) {
          if (resetPass) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            // Handle password reset success
          } else {}
        } else if (state is VerificationCodeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(color: mainColor,),
        inAsyncCall: context.watch<VerificationCodeBloc>().state
            is VerificationCodeLoading,
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
                    child:  Text('Verification Code',
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
                        prefixIcon: Icons.verified_user_outlined,
                        keyboardType: TextInputType.number,
                        controller: verifyCodeController,
                        hidden: false,
                        labelText: 'Enter your verification code',
                      ),
                      CustomButton(
                        text: 'Continue',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            context
                                .read<VerificationCodeBloc>()
                                .add(VerifyCodeSubmitted(
                                  email: email,
                                  code: verifyCodeController.text,
                                  isForResetPassword: resetPass,
                                  newPassword: newPassword,
                                ));
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
      ),
    );
  }
}
