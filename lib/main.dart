



import 'package:chat/view/Screens/email_validate_page.dart';
import 'package:chat/view/Screens/login_page.dart';

import 'package:flutter/material.dart';

void main()async {
  
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id:(context) =>  const LoginPage(),
        //RegisterPage.id:(context) =>  RegisterPage(),
        EmailValidatePage.id:(context) => const EmailValidatePage(),
        //ChatPage.id:(context) => const ChatPage(),
      },
      initialRoute: LoginPage.id,
    );
  }
}