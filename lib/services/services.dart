import 'dart:async';
import 'dart:convert';

import 'package:chat/constants.dart';
import 'package:chat/utilities.dart';
import 'package:flutter/material.dart';
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

// Login
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
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: builder))
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

//to retrieve the last jwt and update it
// Future<void> makeApiCall() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? jwt = prefs.getString('jwt');

//   final response = await http.get(
//     Uri.parse('${baseUrl}'),
//     headers: {'Authorization': 'Bearer $jwt'},
//   );

//   if (response.statusCode == 401) {
//     // Handle token expiration if not already managed
//     await refreshJwtToken();
//     await makeApiCall(); // Retry the API call
//   }

//   // Handle the response
// }

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
