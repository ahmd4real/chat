import 'package:chat/models/BLoCs/SignUp/sign_up_bloc.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_event.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_state.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/Auth/login_page.dart';
import 'package:chat/view/Screens/Auth/verificaton_code_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static String id = 'SignUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
        inAsyncCall: context.watch<SignUpBloc>().state is SignUpLoading,
        child: Scaffold(
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                Image.asset('assets/images/logo.png', height: MediaQuery.of(context).size.height / 4),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: nameController,
                          hidden: false,
                          hintText: 'First Name',
                        ),
                        CustomTextFormField(
                          controller: lastNameController,
                          hidden: false,
                          hintText: 'Last Name',
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          hidden: false,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        CustomTextFormField(
                          controller: passwordController,
                          hidden: true,
                          hintText: 'Password',
                        ),
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          hidden: true,
                          hintText: 'Confirm Password',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field is Required';
                            }
                            if (!passwordMatched(passwordController.text, value)) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
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
                                confirmPassword: confirmPasswordController.text,
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
