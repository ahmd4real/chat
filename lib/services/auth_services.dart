import 'package:chat/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final String baseUrl;

  AuthServices({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      kToken=data['jwt'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', data['jwt']);
      prefs.setString('refreshToken', data['refreshToken']);
      prefs.setString('email', data['email']);
      prefs.setString('firstName', data['firstName']);
      prefs.setString('lastName', data['lastName']);
      prefs.setBool('isLoggedIn', true);
      prefs.setString('expirationOfJwt', data['expirationOfJwt']);
      prefs.setString('bio', data['biography']);
      prefs.setString('profilePicture', data['profilePicture']);
      prefs.setInt('userId', data['userId']);
     
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> signUp(String email, String password, String firstName,
      String lastName, String confirmPassword) async {
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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('firstName', firstName);
      prefs.setString('lastName', lastName);
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('This Email Already Exists');
    } else {
      throw Exception('Failed to sign up');
    }
}




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
}
