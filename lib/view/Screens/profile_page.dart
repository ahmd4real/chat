import 'package:chat/constants.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:chat/utilities.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildUserInfo(context),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      //color: const Color(0xffF8F8F8),
      child: Column(
        children: [
          Row(
            children:  [
              const CircleAvatar(
                radius: 50,
               backgroundImage: AssetImage(kAvatar),
               
              ),
               const SizedBox(
                width: 16,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 130,
                            child: FutureBuilder(
                              future: _getUserFullName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Error',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    snapshot.data ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
                    Navigator.pushNamed(context, LoginPage.id);

                }
                setState(() {
                  loading = false;
                });
              },
              child: const Text('Logout')),

              
        ],
      ),
    );
  }

  Future<String> _getUserFullName() async {
    final firstName = await getData('firstName');
    final lastName = await getData('lastName');
    return '$firstName $lastName';
  }
}
