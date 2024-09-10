import 'package:chat/core/utils/constants.dart';
import 'package:chat/view/Screens/Auth/change_password_page.dart';
import 'package:chat/view/Widgets/profile_page_items.dart';
import 'package:chat/view/Widgets/toggle_button.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Settings',style:TextStyle(
              fontFamily: font,
              color: mainColor,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),),
        backgroundColor: background,
        
      ),
      backgroundColor: background,
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 16,
            ),
           
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: ProfilePageItems(
                  icon: Icons.settings_outlined,
                  text: "change Password",
                  navigateScreens: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage(),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: ProfilePageItems(
                  icon: Icons.brightness_6_outlined,
                  text: "Change Theme",
                  trailing: ChangeThemeButton()),
            )
          ],
        ),
      ),
    );
  }
}
