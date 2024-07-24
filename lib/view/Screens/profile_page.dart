import 'package:chat/constants.dart';
import 'package:chat/models/BLoCs/imageCubit/image_cubit.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/edit_profile_page.dart';

import 'package:chat/view/Screens/login_page.dart';
import 'package:chat/view/Screens/manage_profile_page.dart';
import 'package:chat/view/Screens/settings_page.dart';

import 'package:chat/view/Widgets/profile_page_items.dart';
import 'package:flutter/material.dart';
import 'package:chat/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfilePage extends StatefulWidget {
   ProfilePage({super.key, required this.firstName, required this.lastName, required this.email});
  static String id = 'ProfilePage';
  String? firstName , lastName, email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;
  

 


  
  @override
  Widget build(BuildContext context) {
     final imageCubit = context.read<ImageCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: _buildUserInfo(context,imageCubit)),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context,final imageCubit) {
     final imageState = context.watch<ImageCubit>().state;
    return Column(
      children: [
         CircleAvatar(
          radius: 70,
          backgroundImage: imageState.avatarImg.image,//AssetImage(kAvatar),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          '${widget.firstName} ${widget.lastName}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        ProfilePageItems(
            icon: Icons.settings,
            text: "Settings",
            navigateScreens: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const 
                  SettingsPage()));
            }),
        const SizedBox(
          height: 8,
        ),
        ProfilePageItems(
          icon: Icons.person,
          text: "Manage Profile",
          navigateScreens: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManageProfilePage()));
          },
        ),
        const SizedBox(
          height: 8,
        ),
        ProfilePageItems(
          icon: Icons.edit,
          text: "Edit Profile",
          navigateScreens: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()));
          },
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              if (await signOut()) {
                Navigator.pushReplacementNamed(context, LoginPage.id);
              }
              setState(() {
                loading = false;
              });
            },
            child: const Text('Logout')),

            SizedBox(height: 32,),
            InkWell(onTap: (){
              print('hello');
         
                 showImagePicker(context, 
                 (Image newImage) {
                              imageCubit.setAvatarImg(newImage);
                            });
             
              //startTokenRefreshTimer();
            }, child: Icon(Icons.image,size: 50,)
            )
      ],
    );
  }
}
