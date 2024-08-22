
import 'package:chat/core/utils/constants.dart';
import 'package:chat/services/services.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:chat/view/Screens/profile_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  static String id = 'ChangePasswordPage';

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      
      progressIndicator:  CircularProgressIndicator(
        color: mainColor,
      ),
      inAsyncCall: loading,
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
                    child:  Text('Change Password',
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
                      controller: oldPasswordController,
                      hidden: false,
                      labelText: 'Enter old Password',
                      prefixIcon: Icons.key_off_outlined,
                    ),
                    CustomTextFormField(
                      controller: newPasswordController,
                      hidden: false,
                      labelText: 'Enter New Password',
                      prefixIcon: Icons.key_outlined,
                    ),
                    CustomTextFormField(
                       prefixIcon: Icons.key_outlined,
                      controller: confirmPasswordController,
                      hidden: true,
                      labelText: 'Confirm New Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is Required';
                        }
                        if (!passwordMatched(
                            newPasswordController.text, value)) {
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
                
                          if (await changePassword(
                            oldPasswordController.text,
                              newPasswordController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Your Password Changed')),
                            );
                            Navigator.pushReplacementNamed(
                                context, ProfilePage.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('failed  Change your password')),
                            );
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
            ],
          ),
        ),
      ),
    );
  }
}
