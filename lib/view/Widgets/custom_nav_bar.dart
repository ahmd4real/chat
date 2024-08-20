

import 'package:chat/core/utils/constants.dart';
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
        //rippleColor: kWhite,
        tabBorderRadius: 50,
      // backgroundColor: kBlack,
        style: GnavStyle.google,//GnavStyle.google,
          onTabChange: (index) => onTabChange!(index),
          duration: const Duration(milliseconds: 200),
      gap: 1,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabBackgroundColor: searchBack,//mainColor,
          mainAxisAlignment: MainAxisAlignment.center,
          tabs:  const [
            GButton(
              
              icon: Icons.chat_outlined,
              text: 'Chats',
             
            ),

             GButton(
              icon: Icons.search_outlined,
              text: 'Explore',
            ),
           
            GButton(
              icon: Icons.people_outlined,
              text: 'Requests',
            ),
            

             GButton(
              icon: Icons.person_outlined,
              text: 'Profile',
            ),
           
          ]),
    );
  }
}
