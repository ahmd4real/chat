import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    required this.message,
    required this.isSentByUser, // Add this parameter to indicate if the message was sent by the user
    super.key,
  });

  final Message message;
  final bool isSentByUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 32, left: 16, bottom: 4, top: 16),
            decoration: BoxDecoration(
              color: isSentByUser ? mainColor : Colors.grey[700],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(32),
                topRight: const Radius.circular(32),
                bottomRight: Radius.circular(isSentByUser ? 0 : 32),
                bottomLeft: Radius.circular(isSentByUser ? 32 : 0),
              ),
            ),
            child: Text(
              message.msg,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            
          ),
          Text(
            textAlign: isSentByUser ? TextAlign.end : TextAlign.start,
            message.messageDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
      
    );
  }
}
