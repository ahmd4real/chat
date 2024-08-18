import 'package:chat/core/utils/constants.dart';
import 'package:flutter/material.dart';

class ChatatWidget extends StatelessWidget {
  ChatatWidget(
      {super.key,
      required this.userName,
      this.timeAgo = '',
      this.onTap,
      //required this.isOnline,
      this.picUrl,
      this.lastMsg = '',
      this.whoSentMsg = '',
      this.numberOfUnread = 7,
      this.onLongpress});
  final String userName;

  void Function()? onTap;
  void Function()? onLongpress;
  String? picUrl;
  //final String isOnline;
  String lastMsg, whoSentMsg, timeAgo;
  int numberOfUnread;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongpress,
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: picUrl != null
              ? NetworkImage('https://chat-app.runasp.net/${picUrl!}')
              : const AssetImage(kAvatar),
          backgroundColor: noColor,
          radius: 30,
        ),
        title: Text(
          userName,
          style: TextStyle(color: kWhite,fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$whoSentMsg $lastMsg',
        
        
        maxLines: 1,
  overflow: TextOverflow.ellipsis,),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              
              timeAgo,
              style: TextStyle(
                color: timeAgoColor,

              ),
            ),
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
                ))
          ],
        ),
      ),
    );
  }
}
