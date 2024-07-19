import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void snackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

 bool passwordMatched(String password, String confirmPassword) {
    return password==confirmPassword;
  }

Future<String?> getData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
