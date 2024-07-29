import 'package:chat/view/Screens/Auth/change_password_page.dart';
import 'package:chat/view/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child:
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                child: Text(
                  'Change Password',
              
                ),
                onTap: (){
                  Navigator.pushNamed(context, ChangePasswordPage.id);
                },
              ),
            ),
            Container(
              color: Colors.grey,
              width: double.infinity,
              height: 1,
            )
          ],
        )
      ),
    );
  }
}