import 'package:chat/constants.dart';
import 'package:chat/models/BLoCs/Login/login_bloc.dart';
import 'package:chat/models/BLoCs/Login/login_event.dart';
import 'package:chat/models/BLoCs/Login/login_state.dart';
import 'package:chat/models/BLoCs/cubit/friend_request_cubit.dart';

import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/view/Screens/Auth/enter_email.dart';
import 'package:chat/view/Screens/Auth/signup_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  static String id = 'loginPage';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
        } else if (state is AuthSuccess) {
          context.read<FriendRequestCubit>().loadFriendRequestStates();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: mainColor,
        ),
        inAsyncCall: context.watch<AuthBloc>().state is AuthLoading,
        child: Scaffold(
          appBar: AppBar(),
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
                  child: Text(
                    'Login',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                        validator: emailValidator,
                        prefixIcon: Icons.mail_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextFormField(
                        controller: passwordController,
                        hidden: true,
                        labelText: 'Password',
                        prefixIcon: Icons.key_outlined,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.08,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, EnterYourEmail.id);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  decorationColor: Colors.grey,
                                  color: Colors.grey,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomButton(
                        text: 'Login',
                        onTap: () {
                          print(emailController.text + passwordController.text);
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(LoginEvent(
                                emailController.text, passwordController.text));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.id);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            decorationColor: Colors.grey,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
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
