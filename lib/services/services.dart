import 'dart:convert';

import 'package:chat/API/api.dart';
import 'package:chat/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


// Sign Up
Future<bool> addUser(String email, String password, String firstName, String lastName, String confirmPassword) async {
  try {
    final response = await API().post(
      url: '${baseUrl}SignUp',
      body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword
      },
      token: null,
    );

    if (response != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('firstName', firstName);
      prefs.setString('lastName', lastName);
      return true;
    } else {
      print('Sign Up Failed: Empty response');
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
    final response = await API().post(
      url: '${baseUrl}SendCode',
      body: {
        "email": email,
        "reset": reset, // true to reset password, false to send code/verify email
      },
      token: null,
    );

    if (response != null) {
      return true;
    } else {
      print('Send Code Failed: Empty response');
      return false;
    }
  } catch (e) {
    print('Error in sendVerifyCode: $e');
    return false;
  }
}

// Validate Verification Code
Future<bool> validateVerificationCode(String email, String code) async {
  try {
    final response = await API().post(
      url: '${baseUrl}ValidateEmailVerificationCode',
      body: {
        "email": email,
        "code": code,
      },
      token: null,
    );

    if (response != null) {
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
    final response = await API().post(
      url: '${baseUrl}Login',
      body: {
        "email": email,
        "password": password,
      },
      token: null,
    );

    if (response != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', response['jwt']);
      prefs.setString('refreshToken', response['refreshToken']);
      prefs.setString('email', response['email']);
      prefs.setString('firstName', response['firstName']);
      prefs.setString('lastName', response['lastName']);
      return true;
    } else {
      print('Login Failed: Empty response');
      return false;
    }
  } catch (e) {
    print('Error in login: $e');
    return false;
  }
}


Future<void> refreshJwtToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? refreshToken = prefs.getString('refreshToken');

  if (refreshToken != null) {
    //final url = ''; // Replace with your refresh token endpoint

    final response = await http.post(
      Uri.parse('${baseUrl}tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken,'email': prefs.getString('email')}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Update tokens in SharedPreferences
      await prefs.setString('jwt', data['jwt']);
      await prefs.setString('refreshToken', data['refreshToken']);
    } else {
      throw Exception('Failed to refresh token');
    }
  } else {
    throw Exception('No refresh token found');
  }
}
