import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.message,
    required this.isSentByUser,
    super.key,
  });

  final Message message;
  final bool isSentByUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin:
                const EdgeInsets.only(right: 32, left: 16, bottom: 4, top: 16),
            decoration: BoxDecoration(
              color: isSentByUser ? mainColor : Colors.grey[700],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomRight: Radius.circular(isSentByUser ? 0 : 16),
                bottomLeft: Radius.circular(isSentByUser ? 16 : 0),
              ),
            ),
            child: Text(
              message.msg,
              style: TextStyle(
                fontFamily: font2,
                color: kWhite,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            textAlign: isSentByUser ? TextAlign.end : TextAlign.start,
            message.messageDate,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
