import 'package:chat/utilities.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/view/Screens/login_page.dart';
import 'package:chat/view/Screens/signup_page.dart';
import 'package:chat/view/Screens/verificaton_code_page.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
    Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id:(context) =>  const LoginPage(),
       
        HomePage.id:(context) => const HomePage(),

        SignUpPage.id:(context) => const SignUpPage(),
       
      },
     home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else if (snapshot.hasData && snapshot.data!) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}