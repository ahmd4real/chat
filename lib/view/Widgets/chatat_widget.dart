import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class ChatatWidget extends StatelessWidget {
  ChatatWidget(
      {super.key,
      required this.userName,
      this.message,
      this.timeAgo,
      this.onTap,
      this.picUrl,
      this.onLongpress});
  final String userName;
  String? message, timeAgo;
  void Function()? onTap;
  void Function()? onLongpress;
  String? picUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress:onLongpress ,
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: picUrl != null
              ? NetworkImage('https://chat-app.runasp.net/${picUrl!}')
              : const AssetImage(kAvatar),
              backgroundColor: noColor,
          radius: 30,
        ),
        title: Text(userName),
        subtitle: Text(message ?? ''),
        trailing: Text(timeAgo ?? ''),
      ),
    );
  }
}
