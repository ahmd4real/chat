import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class ChatatWidget extends StatelessWidget {
   ChatatWidget({super.key, required this.userName,this.message,this.timeAgo,this.onTap});
  final String userName;
  String ?message,timeAgo;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return 

      GestureDetector(
        onTap:onTap ,
        child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage(kAvatar),
          radius: 30,
        ),
        title: Text(userName),
        subtitle: Text(message ?? ''),
        trailing: Text(timeAgo ?? ''),
        
            ),
      );
  }
}
  