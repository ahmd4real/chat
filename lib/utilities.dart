import 'package:flutter/material.dart';

void snackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

 bool passwordMatched(String password, String confirmPassword) {
    return password==confirmPassword;
  }
