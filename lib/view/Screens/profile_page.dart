import 'package:chat/core/utils/constants.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/models/BLoCs/ImageCubit/image_cubit.dart';
import 'package:chat/view/Screens/Auth/login_page.dart';
import 'package:chat/view/Screens/edit_profile_page.dart';
import 'package:chat/view/Screens/manage_profile_page.dart';
import 'package:chat/view/Widgets/profile_page_items.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePic,
    this.bio,
  });

  static String id = 'ProfilePage';
  final String firstName, lastName, email;
  String? profilePic, bio;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    final imageState = context.watch<ImageCubit>().state;

    return ModalProgressHUD(
      inAsyncCall: loading,
      progressIndicator: CircularProgressIndicator(
        color: mainColor,
      ),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: font,
              color: mainColor,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: imageState.avatarImg.image,
                    radius: MediaQuery.of(context).size.width * 0.25,
                    backgroundColor: noColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.firstName} ${widget.lastName}',
                    style: const TextStyle(
                      fontFamily: font,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.bio ?? '',
                    style: const TextStyle(
                      fontFamily: font,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ProfilePageItems(
                    icon: Icons.edit_outlined,
                    text: "Edit Profile",
                    navigateScreens: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  EditProfilePage(
                            profilePic: widget.profilePic,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfilePageItems(
                    icon: Icons.person_outlined,
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
                    icon: Icons.settings_outlined,
                    text: "Settings",
                    navigateScreens: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirm Logout'),
                                content: const Text(
                                    'Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      setState(() {
                                        loading = true;
                                      });

                                      // Perform logout operations
                                      bool loggedOut = await signOut();

                                      // Check if widget is still mounted before navigating
                                      if (loggedOut && mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, LoginPage.id);
                                      }

                                 
                                      if (mounted) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    },
                                    child: const Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 38,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color.fromARGB(164, 133, 2, 2),
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: font,
                                color: Color.fromARGB(164, 133, 2, 2),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
