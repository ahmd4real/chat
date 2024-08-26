import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/chat_model.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:chat/models/request_model.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> storeTokens(String jwt, String refreshToken, String jwtExpiry,
    String refreshTokenExpiry) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt', jwt);
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString('expirationOfJwt', jwtExpiry);
  await prefs.setString('expirationOfRefreshToken', refreshTokenExpiry);
}

Future<bool> isTokenExpired() async {
  final prefs = await SharedPreferences.getInstance();
  final jwtExpiryString = prefs.getString('expirationOfJwt');

  if (jwtExpiryString != null) {
    final expiryDate = DateTime.parse(jwtExpiryString);
    return DateTime.now().isAfter(expiryDate);
  }
  return true;
}

Future<void> ensureJwtToken() async {
  if (await isTokenExpired()) {
    await refreshJwtToken();
  }
}

Future<bool> refreshJwtToken() async {
  final refreshToken = await getData('refreshToken');
  final email = await getData('email');
  if (refreshToken != null) {
    final response = await http.post(
      Uri.parse('${baseUrl}tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken, 'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jwt = data['jwt'];
      final newRefreshToken = data['refreshToken'];
      final jwtExpiry = data['expirationOfJwt'];
      final refreshTokenExpiry = data['expirationOfRefreshToken'];

      await storeTokens(jwt, newRefreshToken, jwtExpiry, refreshTokenExpiry);

      print("Refreshed successfully");
      return true;
    } else {
      throw Exception('Failed to refresh token');
    }
  } else {
    throw Exception('No refresh token found');
  }
}

Future<bool> signOut() async {
  //await ensureJwtToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? refreshToken = prefs.getString('refreshToken');
  String? email = prefs.getString('email');
  final response = await http.delete(
    Uri.parse('${baseUrl}SignOut'),
    headers: {'Content-Type': 'application/json-patch+json'},
    body: jsonEncode({'email': email, 'refreshToken': refreshToken}),
  );

  if (response.statusCode == 200) {
    print('Account Deleted');
    prefs.clear().then((value) => print('Shared preferences cleared'));
    print('profile Picture after delete $profilePic');
    final profilePicFromStorage = await getData('profilePic');
    print('profile Picture from storage after delete $profilePicFromStorage');
    return true;
  } else {
    print('Failed to delete account');
    return false;
  }
}

Future<bool> changePassword(String oldPassword, String newPassword) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  print('jwt: $jwt');
  final response = await http.post(Uri.parse('${baseUrl}settings/password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt'
      },
      body:
          jsonEncode({"oldPassword": oldPassword, "newPassword": newPassword}));

  if (response.statusCode == 200) {
    print('Password changed successfully');
    return true;
  }
  print(response.statusCode);
  return false;
}

Future<int?> updateUserData({
  required bool updateFirstName,
  required bool updateLastName,
  required bool updateBio,
  String? newFirstName,
  String? newLastName,
  String? newBio,
}) async {
  await ensureJwtToken();

  List<Map<String, dynamic>> updateData =
      List<Map<String, dynamic>>.empty(growable: true);
  if (updateFirstName) {
    updateData.add({
      "operationType": 0,
      "path": "firstName",
      "op": "replace",
      "from": "string",
      "value": newFirstName
    });
  }
  if (updateLastName) {
    updateData.add({
      "operationType": 0,
      "path": "lastName",
      "op": "replace",
      "from": "string",
      "value": newLastName
    });
  }
  if (updateBio) {
    updateData.add({
      "operationType": 0,
      "path": "biography",
      "op": "replace",
      "from": "string",
      "value": newBio
    });
  }

  try {
    final url = Uri.parse('${baseUrl}settings/insensitive-data');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final headers = {
      'Content-Type': 'application/json-patch+json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode(updateData);

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('User data updated successfully');
      return response.statusCode;
    } else {
      print('Failed to update user data: ${response.statusCode}');
      return response.statusCode;
    }
  } catch (error) {
    print('Error updating user data: $error');
    return null;
  }
}


Future<List<Request>> getRequests(String jwtToken) async {
    final url = Uri.parse('https://chat-app.runasp.net/api/FriendRequest');
    final response = await http.get(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Request.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load friend requests');
    }
  }

Future<void> uploadImage(CroppedFile croppedFile) async {
  File imageFile = File(croppedFile.path);
  if (imageFile != null) {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${baseUrl}settings/profile-picture'), // Replace with your upload URL
    );
    request.headers.addAll(
      {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${await getData('jwt')}'
      },
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'newPicture',
        imageFile.path,
        filename: imageFile.path,
      ),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      print("File uploaded successfully!");
      profilePic = imageFile.path;
      print('profile picture form service uploadeImage: $profilePic');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profilePicture', profilePic!);
    } else {
      print("File upload failed: ${response.statusCode}");
    }
  }
}

Future<bool> friendRequestResponse(bool isAccepted, int id) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  final response = await http.post(
      Uri.parse('https://chat-app.runasp.net/api/FriendRequest/response'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt'
      },
      body: jsonEncode({"isAccepted": isAccepted, "id": id}));

  if (response.statusCode == 200) {
    if (isAccepted)
      print('Friend request accepted successfully');
    else
      print('Friend request declined successfully');
    return true;
  }
  print(response.statusCode);
  return false;
}

Future<List<Chat>> fetchChats(String jwtToken) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  final url = Uri.parse('https://chat-app.runasp.net/api/Chat');
  final response = await http.get(
    url,
    headers: {
      'accept': '*/*',
      'Authorization': 'Bearer $jwt',
    },
  );
  print(response.body);

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    List<dynamic> people = body['chats'];
    return people.map((chatJson) => Chat.fromJson(chatJson)).toList();
  } else {
    throw Exception('Failed to load chats');
  }
}

Future<List<dynamic>> explore(String jwtToken) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  final url = Uri.parse('https://chat-app.runasp.net/api/Search');
  final response = await http.get(
    url,
    headers: {
      'accept': '*/*',
      'Authorization': 'Bearer $jwt',
    },
  );
  print(response.body);

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    List<dynamic> people = body;
    print(people);
    return people;
  } else {
    throw Exception('Failed to load people');
  }
}

Future<bool> addFriend(int id) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  final response = await http.post(
    Uri.parse('https://chat-app.runasp.net/api/FriendRequest/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt',
    },
    body: jsonEncode({"id": id}),
  );

  if (response.statusCode == 200) {
    print(
      'sent successfully',
    );
    return true;
  }
  return false;
}

Future<bool> cancelFriend(int id) async {
  await ensureJwtToken();
  final jwt = await getData('jwt');

  final response = await http.delete(
    Uri.parse('https://chat-app.runasp.net/api/FriendRequest/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt',
    },
    body: jsonEncode({"id": id}),
  );

  if (response.statusCode == 200) {
    print(
      'cancelled successfully',
    );
    return true;
  }
  return false;
}

 Future<List<Message>> fetchMessages(String chatId, String token) async {
    final response = await http.get(
      Uri.parse('https://chat-app.runasp.net/api/Chat/message?chatId=$chatId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Message> messages = jsonList.map((json) => Message.fromJson(json)).toList();
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }