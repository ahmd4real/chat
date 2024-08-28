import 'package:chat/core/utils/constants.dart';
import 'package:flutter/material.dart';

class ChatatWidget extends StatelessWidget {
  ChatatWidget({
    super.key,
    required this.userName,
    this.timeAgo = '',
    this.onTap,
    required this.isOnline,
    this.picUrl,
    this.lastMsg = '',
    this.whoSentMsg = '',
    this.numberOfUnread = 0,
    this.onLongpress,
  });

  final String userName;
  final void Function()? onTap;
  final void Function()? onLongpress;
  final String? picUrl;
  final bool isOnline;
  final String lastMsg, whoSentMsg, timeAgo;
  final int numberOfUnread;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongpress,
      onTap: onTap,
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: picUrl != null
                  ? NetworkImage('https://chat-app.runasp.net/${picUrl!}')
                  : const AssetImage(kAvatar),
              backgroundColor: noColor,
              radius: 30,
            ),
            if (isOnline)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kWhite, // Adds a white border around the dot
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          userName,
          style: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$whoSentMsg $lastMsg',
          style: TextStyle(color: Colors.grey[500]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              timeAgo,
              style: TextStyle(
                color: timeAgoColor,
              ),
            ),
            if (numberOfUnread > 0)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    numberOfUnread.toString(),
                    style: TextStyle(color: kWhite),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
