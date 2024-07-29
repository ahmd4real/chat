import 'package:chat/models/BLoCs/Verification/verification_bloc.dart';
import 'package:chat/models/BLoCs/Verification/verification_event.dart';
import 'package:chat/models/BLoCs/Verification/verification_state.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


import '../home_page.dart';

class VerificationCodePage extends StatefulWidget {
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

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  TextEditingController verifyCodeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCodeBloc, VerificationCodeState>(
      listener: (context, state) {
        if (state is VerificationCodeLoading) {
          // Show loading
        } else if (state is VerificationCodeSuccess) {
          if (widget.resetPass) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            // Handle password reset success
          } else {
            
          }
        } else if (state is VerificationCodeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: context.watch<VerificationCodeBloc>().state is VerificationCodeLoading,
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
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              context.read<VerificationCodeBloc>().add(VerifyCodeSubmitted(
                                email: widget.email,
                                code: verifyCodeController.text,
                                isForResetPassword: widget.resetPass,
                                newPassword: widget.newPassword,
                              ));
                              
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
      ),
    );
  }
}
