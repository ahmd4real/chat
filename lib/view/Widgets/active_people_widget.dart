import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class ActivePeopleWidget extends StatelessWidget {
  const ActivePeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: const Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(kAvatar),
            radius: 35,
          ),
          SizedBox(height: 4),
          Text('Ahmed ')]
      ),
    );
  }
}