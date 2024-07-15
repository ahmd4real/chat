import 'package:chat/constants.dart';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, this.onTap, this.text});
  String? text;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: kButtonsColor),
          child: Center(
              child: Text(
            '$text',
            style: const TextStyle(color: Color.fromARGB(239, 242, 242, 243),fontSize: 20),
          )),
        ),
      ),
    );
  }
}
