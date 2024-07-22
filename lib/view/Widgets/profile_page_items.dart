import 'package:flutter/material.dart';

class ProfilePageItems extends StatelessWidget {
   ProfilePageItems({super.key, required this.icon, required this.text,  this.navigateScreens});
  final IconData icon;
  final String text;
   void Function()? navigateScreens;

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      decoration: 
      BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color.fromARGB(41, 158, 158, 158),
      ),
      
      child: ListTile(

        leading: Icon(icon)
        ,
        title: Text(text),
        trailing: Icon(Icons.chevron_right),
        onTap: navigateScreens,
        
      ),
    );
  }
}