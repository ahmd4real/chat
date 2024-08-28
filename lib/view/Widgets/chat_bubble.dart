import 'package:chat/core/utils/constants.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:flutter/material.dart';
import '../../models/message_model.dart';

// class ChatBubble extends StatelessWidget {
//   const ChatBubble({
//     required this.message,
//     required this.isSentByUser,
//     required this.tapped,
//     super.key,
//   });

//   final Message message;
//   final bool isSentByUser, tapped;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment:
//               isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//           children: [
//             ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.75,
//               ),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 margin: const EdgeInsets.only(
//                     right: 16, left: 16, bottom: 4, top: 16),
//                 decoration: BoxDecoration(
//                   color: isSentByUser ? mainColor : Colors.grey[700],
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(isSentByUser ? 16 : 0),
//                     topRight: Radius.circular(isSentByUser ? 0 : 16),
//                     bottomRight: const Radius.circular(20),
//                     bottomLeft: const Radius.circular(20),
//                   ),
//                 ),
//                 child: Text(
//                   message.msg,
//                   style: TextStyle(
//                     fontFamily: font,
//                     color: kWhite,
//                     fontSize: 16,
//                   ),
//                   overflow: TextOverflow.visible,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Padding(
//           padding: EdgeInsets.only(
//             right: isSentByUser ? 16 : 0,
//             left: isSentByUser ? 0 : 16,
//           ),
//           child: Row(
//             mainAxisAlignment:
//                 isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//             children: [
//               Text(
//                 textAlign: isSentByUser ? TextAlign.end : TextAlign.start,
//                tapped ? getTimeNow() 
//                 : handleTimeFromDB(message.messageDate),
//                 style: const TextStyle(
//                   fontSize: 10,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.message,
    required this.isSentByUser,
    super.key, //required bool tapped,
  });

  final Message message;
  final bool isSentByUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(
                    right: 16, left: 16, bottom: 4, top: 16),
                decoration: BoxDecoration(
                  color: isSentByUser ? mainColor : Colors.grey[700],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSentByUser ? 16 : 0),
                    topRight: Radius.circular(isSentByUser ? 0 : 16),
                    bottomRight: const Radius.circular(20),
                    bottomLeft: const Radius.circular(20),
                  ),
                ),
                child: Text(
                  message.msg,
                  style: TextStyle(
                    fontFamily: font,
                    color: kWhite,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            right: isSentByUser ? 16 : 0,
            left: isSentByUser ? 0 : 16,
          ),
          child: Row(
            mainAxisAlignment:
                isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                textAlign: isSentByUser ? TextAlign.end : TextAlign.start,
                message.isNewMessage ? getTimeNow() : handleTimeFromDB(message.messageDate),
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
