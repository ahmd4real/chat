import 'package:chat/core/utils/constants.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage(
      {super.key, required this.userName, this.profilePic, this.bio});
  final String userName;
  String? profilePic;
  String? bio;
  static String id = 'UserProfilePageId';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: Center(
        child: Column(
          
          children: [
            CircleAvatar(
              backgroundColor: kGreen,
              radius: 100,
              backgroundImage: profilePic != null
                  ? NetworkImage('https://chat-app.runasp.net/${profilePic!}')
                  : const AssetImage(kAvatar) as ImageProvider,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Text(
                
              userName,
                style: const TextStyle(
                  fontFamily: font,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),

              
            ),
            Text(
              bio ?? '',
              style: const TextStyle(
                fontFamily: font,
              ),
            )
          ],
        ),
      ),
    );
  }
}
