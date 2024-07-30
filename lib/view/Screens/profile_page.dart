
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/freindsRequests.dart';
import 'package:chat/view/Screens/requests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/models/BLoCs/ImageCubit/image_cubit.dart';
import 'package:chat/view/Screens/Auth/login_page.dart';
import 'package:chat/view/Screens/edit_profile_page.dart';
import 'package:chat/view/Screens/manage_profile_page.dart';
import 'package:chat/view/Screens/settings_page.dart';
import 'package:chat/view/Widgets/profile_page_items.dart';
import 'package:chat/utilities.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  static String id = 'ProfilePage';
  final String firstName, lastName, email;

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
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Center(child: _buildUserInfo(context, imageCubit)),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, ImageCubit imageCubit) {
    final imageState = context.watch<ImageCubit>().state;
    return ListView(
      children: [
        Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage:  NetworkImage('https://chat-app.runasp.net/Users//c4e7b7ee-c0d6-4fa6-9359-c305bf6a354c.jpg'),//imageState.avatarImg.image,
              ),
              const SizedBox(height: 24),
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ProfilePageItems(
                icon: Icons.edit,
                text: "Edit Profile",
                navigateScreens: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfilePageItems(
                icon: Icons.person,
                text: "Manage Profile",
                navigateScreens: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageProfilePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfilePageItems(
                icon: Icons.settings,
                text: "FreindsRequests",
                navigateScreens: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  FriendsRequests(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
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
                child: const Text('Logout'),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  InkWell(
                    onTap: () {
                    
                      showImagePicker(context, (Image newImage) {
                        imageCubit.setAvatarImg(newImage);
                      });
                    },
                    child: const Icon(Icons.image, size: 50),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
