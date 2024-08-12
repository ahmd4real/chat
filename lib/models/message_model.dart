class Message {
  final String msg;
  final String sender;
  final DateTime timestamp;
  String messageDate;

  Message({
    required this.msg,
    required this.sender,
    required this.timestamp,
    this.messageDate = '',
  });

  // Factory constructor to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      timestamp: DateTime.now(),
      msg: json['messageText'],
      sender: json['senderId'].toString(),  // Use senderId as a string for now
      messageDate:json['messageDate'],  // Convert timestamp
    );
  }
}
