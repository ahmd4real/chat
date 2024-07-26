
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/verificaton_code_page.dart';
import 'package:flutter/material.dart';

import 'package:chat/constants.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });
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

  bool loading = false;

  // Function to handle user sign up
  Future<void> handleSignUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      try {
       final worked= await signUp(
          emailController.text,
          passwordController.text,
          nameController.text,
          lastNameController.text,
          confirmPasswordController.text,
          context
        );
        if(worked){
        await sendVerifyCode(emailController.text, false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodePage(
              email: emailController.text,
            ),
          ),
        );
        }
      } catch (e) {
        print('Error in handleSignUp: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Image.asset(kLogo,
                  height: MediaQuery.of(context).size.height / 4),
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
                          if (!passwordMatched(
                              passwordController.text, value)) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      CustomButton(
                        text: 'Sign Up',
                        onTap: handleSignUp,
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
    );
  }
}
