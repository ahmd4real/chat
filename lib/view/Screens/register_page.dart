import 'package:chat/API/api.dart';
import 'package:chat/constants.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.email});
  static String id = 'registerPage';
   final String email;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;

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
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            loading = true;
                            setState(() {});
                            // try {
                            //   await registerUser();
                            //   Navigator.pushNamed(context, ChatPage.id);
                            // } on catch (e) {
                            //   if (e.code == 'weak-password') {
                            //     snackBar(context, 'Weak password');
                            //   } else if (e.code == 'email-already-in-use') {
                            //     snackBar(context,
                            //         'Email already in use try another one');
                            //   }
                            // }
                             addUser(
                                widget.email,
                                passwordController.text,
                                nameController.text,
                                lastNameController.text,
                                confirmPasswordController.text);
                            loading = false;
                            setState(() {});

                           
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
                      'Already have an account? ',
                      // style:
                      //     TextStyle(color: Color.fromARGB(255, 206, 230, 218))
                    ),
                    GestureDetector(
                        onTap: () {
                        Navigator.popUntil(context, (ModalRoute.withName(LoginPage.id)));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600),
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

  void addUser(String email, String password, String firstName, String lastName,
      String confirmPassword) {
    API().post(
      url: '${baseUrl}SignUp',
      body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword
      },
    );
  }
  // bool passwordMatched(String password, String confirmPassword) {
  //   return password==confirmPassword;
  // }

  // Future<void> registerUser() async {
  //   UserCredential user = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email!, password: password!);
  // }
}
