import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/constants.dart';
import 'package:chat/utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Sign Up
Future<bool> signUp(String email, String password, String firstName,
    String lastName, String confirmPassword, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}SignUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'confirmPassword': confirmPassword
      }),
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('firstName', firstName);
      prefs.setString('lastName', lastName);
      return true;
    } else {
      if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This Email Already Exists')),
        );
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up')),
      );
      return false;
    }
  } catch (e) {
    print('Error in addUser: $e');
    return false;
  }
}

// Send Verification Code
Future<bool> sendVerifyCode(String email, bool reset) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}SendCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'reset': reset}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Send Code Failed form sendVerifyCode Function: Empty response');
      return false;
    }
  } catch (e) {
    print('Error in sendVerifyCode from sendVerifyCode Function: $e');
    return false;
  }
}

// Validate Verification Code
Future<bool> validateCode(String email, String code,
    {bool isForResetPassword = false}) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}ValidateCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'isForResetPassword': isForResetPassword
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Validate Code Failed: Empty response');
      return false;
    }
  } catch (e) {
    print('Error in validateVerificationCode: $e');
    return false;
  }
}

Future<bool> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', data['jwt']);
      prefs.setString('refreshToken', data['refreshToken']);
      prefs.setString('email', data['email']);
      prefs.setString('firstName', data['firstName']);
      prefs.setString('lastName', data['lastName']);
      prefs.setBool('isLoggedIn', true);
      prefs.setString('expirationOfJwt', data['expirationOfJwt']);
      print(response.body);
      return true;
    } else {
      if (response.statusCode == 404) {
        print('email or password is incorrect');
        return false;
      }
      print('Login Failed: Empty response');
      return false;
    }
  } catch (e) {
    print('Error in login: $e');
    return false;
  }
}

Future<void> refreshJwtToken() async {
  final refreshToken = await getData('refreshToken');
  final email = await getData('email');
  if (refreshToken != null) {
    final response = await http.post(
      Uri.parse('${baseUrl}tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken, 'email': email}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      final oldToken = prefs.getString('jwt');
      final oldRefreshToken = prefs.getString('refreshToken');
      await prefs.setString('jwt', data['jwt']);
      await prefs.setString('refreshToken', data['refreshToken']);

      print("Refreshed successfully");

      print('''Token Data:
    oldToken: $oldToken
    newToken: ${data['jwt']}
    oldRefreshToken: $oldRefreshToken
    newRefreshToken: ${data['refreshToken']}
    ''');
    } else {
      throw Exception('Failed to refresh token');
    }
  } else {
    throw Exception('No refresh token found');
  }
}

Future<bool> signOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? refreshToken = prefs.getString('refreshToken');
  String? email = prefs.getString('email');
  final response = await http.delete(
    Uri.parse('${baseUrl}SignOut'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'refreshToken': refreshToken}),
  );

  if (response.statusCode == 200) {
    print('Account Deleted');
    prefs.clear();
    return true;
  } else {
    print('Failed to delete account');
    return false;
  }
}

Future<bool> resetPassword(String email, String newPassword) async {
  final response = await http.post(
    Uri.parse('${baseUrl}resetpassword'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    },
    body: jsonEncode({'email': email, 'newPassword': newPassword}),
  );

  if (response.statusCode == 200) {
    print('Password reset successful');
    return true;
  }
  return false;
}

Future<bool> changePassword(String oldPassword, String newPassword) async {
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
    final url = Uri.parse(
        'https://chat-app.runasp.net/api/Accounts/settings/insensitive-data');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
        'jwtToken'); // Assume you store the JWT token in SharedPreferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiNTk4NmZiNy1kMmUxLTQ1ODEtODU4Yi1iMjdjMzJjZDY3ZTYiLCJlbWFpbCI6ImFobWVkYWwwMTE2MDVAZ21haWwuY29tIiwiaWQiOiIyMSIsImZpcnN0TmFtZSI6Im9tYXIiLCJsYXN0TmFtZSI6IkFsYWEiLCJleHAiOjE3MjE5MDcxNTYsImlzcyI6IkF1dGhlbnRpY2F0aW9uL0JhY2tFbmQiLCJhdWQiOiJBdXRoZW50aWNhdGlvbi9Gcm9udEVuZCJ9.A2sbapVmQLeEaigXNsulu9KiedzC_T3i9tTIxGwvFb0',
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
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4YzUwNDA1Ny0xZTg2LTQ1MTAtOWM3Yy0zOWY0NDc4OTJmYTMiLCJlbWFpbCI6ImFobWVkYWwwMTE2MDVAZ21haWwuY29tIiwiaWQiOiIyMSIsImZpcnN0TmFtZSI6IkFobWVkIiwibGFzdE5hbWUiOiJBbGFhIiwiZXhwIjoxNzIxODIzNTE0LCJpc3MiOiJBdXRoZW50aWNhdGlvbi9CYWNrRW5kIiwiYXVkIjoiQXV0aGVudGljYXRpb24vRnJvbnRFbmQifQ.J5jJDaXqCVw_TORy_OZBHubG4E7hqF_jBLURi5ld8KU'
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
    } else {
      print("File upload failed: ${response.statusCode}");
    }
  }
}

void startTokenRefreshTimer() async {
  //haredPreferences prefs = await SharedPreferences.getInstance();
  final expirationOfJwt = await getData('expirationOfJwt');
  print(expirationOfJwt);
  if (expirationOfJwt != null) {
    DateTime jwtExpiration = DateTime.parse(expirationOfJwt);
    print(
        'before Parsing jwtExpiration: $expirationOfJwt After Parsing jwtExpiration: $jwtExpiration');
    Duration timeUntilExpiration = jwtExpiration.difference(DateTime.now());
    print('timeUntilExpiration: $timeUntilExpiration');
    // Set the timer to refresh the token a few minutes before it expires
    Timer(timeUntilExpiration - Duration(minutes: 10), () async {
      await refreshJwtToken();
      // Restart the timer after refreshing the token
      startTokenRefreshTimer();
    });
  }
}
