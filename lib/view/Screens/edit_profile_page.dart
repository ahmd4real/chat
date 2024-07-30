import 'package:chat/models/BLoCs/SignUp/sign_up_bloc.dart';

import 'package:chat/models/BLoCs/SignUp/sign_up_state.dart';
import 'package:chat/services/services.dart';
import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/Auth/login_page.dart';

import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  static String id = 'EditProfilePage';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  late String oldFname, oldLname, oldBio;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getdatatobeupdated();
  }

  getdatatobeupdated() async {
    oldFname = await getData('firstName') ?? '';
    oldLname = await getData('lastName') ?? '';
    oldBio = await getData('bio') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: context.watch<SignUpBloc>().state is SignUpLoading,
        child: Scaffold(
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                Image.asset('assets/images/logo.png',
                    height: MediaQuery.of(context).size.height / 4),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                
                    child: Column(

                      children: [
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: nameController,
                          hidden: false,
                          labelText: 'New First Name',
                          hintText: oldFname,
                        ),
                        CustomTextFormField(
                          controller: lastNameController,
                          hidden: false,
                          labelText: 'New Last Name',
                         hintText: oldLname,
                        ),
                        CustomTextFormField(
                          controller: bioController,
                          hidden: false,
                          labelText: 'New Bio',
                          hintText: oldBio,
                        ),
                        CustomButton(
                          text: 'Save',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              updateUserData(
                                  updateFirstName:
                                      oldFname != nameController.text,
                                  updateLastName:
                                      oldLname != lastNameController.text,
                                  updateBio: oldBio != bioController.text,
                                  newFirstName: nameController.text,
                                  newLastName: lastNameController.text,
                                  newBio: bioController.text);
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
