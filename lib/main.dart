


import 'package:chat/view/Screens/chat_page.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:chat/view/Screens/register_page.dart';
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
        RegisterPage.id:(context) => const RegisterPage(),
        //ChatPage.id:(context) => const ChatPage(),
      },
      initialRoute: LoginPage.id,
    );
  }
}