import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_bloc.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_event.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_state.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:chat/view/Screens/Auth/login_page.dart';
import 'package:chat/view/Screens/Auth/verificaton_code_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  static String id = 'SignUpPage';

  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          // Show loading
        } else if (state is SignUpSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodePage(
                email: emailController.text,
              ),
            ),
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ModalProgressHUD(
       progressIndicator: CircularProgressIndicator(color: mainColor,),
        inAsyncCall: context.watch<SignUpBloc>().state is SignUpLoading,
        child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: background,
          ),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08 + 16,
                  ),
                  child: Text('Sign Up',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: nameController,
                          hidden: false,
                          labelText: 'First Name',
                          prefixIcon: Icons.person_outlined,
                        ),
                        CustomTextFormField(
                          controller: lastNameController,
                          hidden: false,
                          labelText: 'Last Name',
                          prefixIcon: Icons.person_outlined,
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          hidden: false,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                          prefixIcon: Icons.mail_outlined,
                        ),
                        CustomTextFormField(
                          controller: passwordController,
                          hidden: true,
                          labelText: 'Password',
                          prefixIcon: Icons.key_outlined,
                        ),
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          hidden: true,
                          labelText: 'Confirm Password',
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
                          prefixIcon: Icons.key_outlined,
                        ),
                        CustomButton(
                          text: 'Sign Up',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              context.read<SignUpBloc>().add(SignUpSubmitted(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    firstName: nameController.text,
                                    lastName: lastNameController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                  ));
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
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, LoginPage.id);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
