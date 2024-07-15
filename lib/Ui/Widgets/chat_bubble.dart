import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {required this.messgae,
      required this.align,
      required this.bottomLeft,
      required this.bottomRight,
      required this.msgColor,
      super.key});
  final Message messgae;
  final double bottomLeft;
  final double bottomRight;
  final Alignment align;
  Color msgColor;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 64, left: 16, bottom: 16, top: 16),
        decoration: BoxDecoration(
            color: msgColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(32),
                topRight: const Radius.circular(32),
                bottomRight: Radius.circular(bottomRight),
                bottomLeft: Radius.circular(bottomLeft))),
        child: Text(messgae.msg,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
      ),
    );
  }
}
