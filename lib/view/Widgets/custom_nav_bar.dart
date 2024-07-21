

import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  CustomNavBar({super.key, this.onTabChange});
  void Function(int)? onTabChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  16.0),
      child: GNav(
          onTabChange: (index) => onTabChange!(index),
          duration: const Duration(milliseconds: 500),
      
          tabBackgroundColor: kButtonsColor,
          mainAxisAlignment: MainAxisAlignment.center,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ]),
    );
  }
}
