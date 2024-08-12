import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class ActivePeopleWidget extends StatelessWidget {
  const ActivePeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child:  Column(
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage(kAvatar),
            radius: 35,
            backgroundColor: noColor,
          ),
          const SizedBox(height: 4),
          const Text('Ahmed ')]
      ),
    );
  }
}