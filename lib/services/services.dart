import 'dart:convert';

import 'package:chat/API/api.dart';
import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


// Sign Up
Future<bool> signUp(String email, String password, String firstName, String lastName, String confirmPassword) async {
  try {
   final response = await http.post(
      Uri.parse('${baseUrl}Login'),
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
    final response = await http.post(
      Uri.parse('${baseUrl}Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'reset': reset}),
    );

   if (response.statusCode == 200) {
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
     final response = await http.post(
      Uri.parse('${baseUrl}Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
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
    

    final data=jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', data['jwt']);
      prefs.setString('refreshToken', data['refreshToken']);
      prefs.setString('email', data['email']);
      prefs.setString('firstName', data['firstName']);
      prefs.setString('lastName', data['lastName']);
      prefs.setBool('isLoggedIn', true);
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


    final response = await http.post(
      Uri.parse('${baseUrl}tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken,'email': prefs.getString('email')}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      
      await prefs.setString('jwt', data['jwt']);
      await prefs.setString('refreshToken', data['refreshToken']);
    } else {
      throw Exception('Failed to refresh token');
    }
  } else {
    throw Exception('No refresh token found');
  }
}
