import 'package:chat/core/utils/constants.dart';
import 'package:flutter/material.dart';

class ActivePeopleWidget extends StatelessWidget {
  const ActivePeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child:  Column(
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage(kAvatar),
            radius: 35,
            backgroundColor: kGreen,
          ),
          const SizedBox(height: 4),
          const Text('Ahmed ')]
      ),
    );
  }
}