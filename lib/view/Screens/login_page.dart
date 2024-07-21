import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/enter_email.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/view/Screens/signup_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widgets/custom_text_form_field.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'loginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).size.height / 4,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextFormField(
                        controller: emailController,
                        hidden: false,
                        hintText: 'Email',
                        validator: emailValidator,
                      ),
                      CustomTextFormField(
                        controller: passwordController,
                        hidden: true,
                        hintText: 'Password',
                      ),
                      Padding(
                         padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08, vertical: 8),
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
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],),
                      ),
                      CustomButton(
                        text: 'Login',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            await login(
                                emailController.text, passwordController.text);
                            if (await isLoggedIn()) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.id);
                        },
                        child: const Text(
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600),
                          'Sign Up',
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
