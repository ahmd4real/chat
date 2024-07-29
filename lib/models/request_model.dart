class Request{
  int id;
  String firstName;
  String lastName;
  String profilePicture;
  String bio;
  Request({required this.id,required this.firstName,required this.lastName,required this.profilePicture,required this.bio});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
        id: json['id'], 
        firstName: json['firstName'],
        lastName: json['lastName'],
        profilePicture: json['profilePicture'],
        bio: json['bio']  
    );
  }
}