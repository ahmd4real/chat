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
  String? firstName = '', lastName = '', email = '';

  @override
  void initState() {
    super.initState();
    _getUserFullName();
  }

  Future<void> _getUserFullName() async {
    setState(() {
      loading = true;
    });

    firstName = await getData('firstName');
    lastName = await getData('lastName');
    email = await getData('email');
      setState(() {
      loading = false;
    });
  }

  @override
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
          child: Center(child: _buildUserInfo(context)),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage(kAvatar),
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: 130,
            child: Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        ],
      ),
    );
  }
}
