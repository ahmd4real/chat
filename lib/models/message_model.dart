import 'package:chat/helper/constants.dart';


class Message{
  final String msg;
  final String id;
  Message(this.msg,this.id);

  factory Message.fromJson(jsonData){
    return Message(jsonData[kMessage],jsonData[kMessageId]);
  }
}