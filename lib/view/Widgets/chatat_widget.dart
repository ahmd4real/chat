import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class ChatatWidget extends StatelessWidget {
  const ChatatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return 

     ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(kAvatar),
        radius: 30,
      ),
      title: const Text('Ahmed'),
      subtitle: const Text('hello bithces'),
      trailing: Text('3 mins ago'),

    );
  }
}
  