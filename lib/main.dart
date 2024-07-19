import 'package:chat/view/Screens/login_page.dart';
import 'package:chat/view/Screens/signup_page.dart';
import 'package:chat/view/Screens/verificaton_code_page.dart';

import 'package:flutter/material.dart';

void main() {
  
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
        
        SignUpPage.id:(context) => const SignUpPage(),
       // VerificationCodePage.id:(context) =>  VerificationCodePage(),
        //ChatPage.id:(context) => const ChatPage(),
      },
      initialRoute: LoginPage.id,
    );
  }
}