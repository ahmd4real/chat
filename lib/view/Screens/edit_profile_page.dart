import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/BLoCs/ImageCubit/image_cubit.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_bloc.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_state.dart';
import 'package:chat/services/services.dart';
import 'package:chat/core/utils/utilities.dart';

import 'package:chat/view/Widgets/custom_button.dart';
import 'package:chat/view/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoggedIn = false;

  String oldFname = '';
  String oldLname = '';
  String oldBio = '';
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getdatatobeupdated();

  }

  getdatatobeupdated() async {
    final fname = await getData('firstName') ?? '';
    final lname = await getData('lastName') ?? '';
    final bio = await getData('bio') ?? '';
    final prefs=SharedPreferences.getInstance();

    isLoggedIn = await prefs.then((value) => value.getBool('isLoggedIn') ?? false);

    setState(() {
      oldFname = fname;
      oldLname = lname;
      oldBio = bio;
      nameController.text = oldFname;
      lastNameController.text = oldLname;
      bioController.text = oldBio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    return Scaffold(
      body: ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(color: mainColor,),
        inAsyncCall: context.watch<SignUpBloc>().state is SignUpLoading,
        child: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage:  imageCubit.state.avatarImg.image ,
                        radius: MediaQuery.of(context).size.width * 0.25,
                        backgroundColor: noColor,
                      ),
                      Positioned(
                        top: 120,
                        left: 110,
                        child: editWidget(imageCubit),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08 + 16,
                  ),
                  child: Text('Edit Profile',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: kDarkGrey,
                          fontSize: 48,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: nameController,
                        hidden: false,
                        labelText: 'New First Name',
                        hintText: oldFname,
                         prefixIcon: Icons.person_outlined,
                      ),
                      CustomTextFormField(
                        controller: lastNameController,
                        hidden: false,
                        labelText: 'New Last Name',
                        hintText: oldLname,
                        prefixIcon: Icons.person_outlined,
                      ),
                      CustomTextFormField(
                        controller: bioController,
                        hidden: false,
                        labelText: 'New Bio',
                        hintText: oldBio,
                        keyboardType: TextInputType.multiline,
                        prefixIcon: Icons.book_outlined,
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

                            Navigator.pop(context);
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

  Widget editWidget( imageCubit) {
    return IconButton(
      onPressed: () {
        showImagePicker(context, (Image newImage) {
          imageCubit.setAvatarImg(newImage);
        });
      },
      icon: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhite,
            border: Border.all(color: mainColor, width: 2),
          ),
          child: Icon(
            Icons.edit,
            color: mainColor,
            size: 30,
          )),
    );
  }
}