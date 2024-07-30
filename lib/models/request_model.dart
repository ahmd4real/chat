class Request {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String? biography;

  Request({
    required this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.biography,
  });

  factory Request.fromSignalR(int id, String fullName, String? profilePicture, String? biography) {
    var names = fullName.split(' ');
    var firstName = names.isNotEmpty ? names[0] : 'Unknown';
    var lastName = names.length > 1 ? names[1] : '';
    return Request(
      id: id,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      biography: biography,
    );
  }

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] as int,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePicture: json['profilePicture'] as String?,
      biography: json['biography'] as String?,
    );
  }
}
