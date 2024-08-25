class User {
  final String firstName;
  final String lastName;
  final String? profilePicture;

  User({
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }
}

class Chat {
  final String id;
  final bool isRead;
  final List<User> users;
  final String lastMessage;
  final String lastMessageDate;
  final int senderId;

  Chat({
    required this.lastMessage,
    required this.lastMessageDate,
    required this.senderId,
    required this.id,
    required this.isRead,
    required this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id']??'',
      isRead: json['isRead']??false,
      users: (json['users'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
      lastMessage: json['lastMessage']??'',
      lastMessageDate: json['lastMessageDate']??'',
      senderId: json['senderId']??0,
    );
  }
}
