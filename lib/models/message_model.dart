// class Message {
//   final String msg;
//   final String sender;
//   final String timestamp;
//   String messageDate;

//   Message({
//     required this.msg,
//     required this.sender,
//     required this.timestamp,
//     this.messageDate = '',
//   });

//   // Factory constructor to create a Message from JSON
//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       timestamp: DateTime.now().toString(),
//       msg: json['messageText'],
//       sender: json['senderId'].toString(),  // Use senderId as a string for now
//       messageDate:json['messageDate'],  // Convert timestamp
//     );
//   }
// }

import 'package:chat/core/utils/utilities.dart';
class Message {
  final String msg;
  final String sender;
  final String timestamp;
  final String messageDate;
  final bool isNewMessage;

  Message({
    required this.msg,
    required this.sender,
    required this.timestamp,
    required this.messageDate,
    this.isNewMessage = false,
  });

  // Factory constructor to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      timestamp: json['messageDate'],
      msg: json['messageText'],
      sender: json['senderId'].toString(),
      messageDate: json['messageDate'],
      isNewMessage: false,
    );
  }

  // Factory constructor for messages from the DB
  factory Message.fromDB({
    required String msg,
    required String sender,
    required String timestamp,
    required String messageDate,
  }) {
    return Message(
      msg: msg,
      sender: sender,
      timestamp: timestamp,
      messageDate: messageDate,
      isNewMessage: false,
    );
  }

  // Factory constructor for new messages
  factory Message.newMessage({
    required String msg,
    required String sender,
  }) {
    final currentTime = DateTime.now().toString();
    final currentMessageDate = getTimeNow();

    return Message(
      msg: msg,
      sender: sender,
      timestamp: currentTime,
      messageDate: currentMessageDate,
      isNewMessage: true,
    );
  }
}
