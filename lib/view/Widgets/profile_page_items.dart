import 'package:chat/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePageItems extends StatelessWidget {
  ProfilePageItems(
      {super.key,
      required this.icon,
      required this.text,
      this.trailing,
      this.navigateScreens});
  final IconData icon;
  Widget? trailing;
  final String text;
  void Function()? navigateScreens;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color.fromARGB(41, 158, 158, 158),
      ),
      child: Center(
        child: ListTile(
          leading: Icon(icon,color: kWhite,),
          title: Text(
            text,
            style: TextStyle(color:mainColor,fontFamily: font ,fontWeight: FontWeight.bold),
            
          ),
          trailing: trailing?? Icon(Icons.chevron_right,color: kWhite,),
          onTap: navigateScreens,
        ),
      ),
    );
  }
}
