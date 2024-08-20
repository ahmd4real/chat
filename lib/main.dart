import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/BLoCs/ImageCubit/image_cubit.dart';
import 'package:chat/models/BLoCs/Login/login_bloc.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_bloc.dart';
import 'package:chat/models/BLoCs/Theme/theme_bloc.dart';
import 'package:chat/models/BLoCs/Theme/theme_state.dart';
import 'package:chat/models/BLoCs/Verification/verification_bloc.dart';
import 'package:chat/models/BLoCs/cubit/friend_request_cubit.dart';
import 'package:chat/services/auth_services.dart';

import 'package:chat/view/Screens/Auth/change_password_page.dart';
import 'package:chat/view/Screens/Auth/enter_email.dart';
import 'package:chat/view/Screens/Auth/verificaton_code_page.dart';

import 'package:chat/view/Screens/home_page.dart';
import 'package:chat/view/Screens/Auth/login_page.dart';
import 'package:chat/view/Screens/Auth/signup_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  kToken = prefs.getString('jwt') ?? '';
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) return false;

    final expirationString = prefs.getString('expirationOfJwt');
    if (expirationString == null) return false;

    final expirationDate = DateTime.tryParse(expirationString);
    if (expirationDate == null) return false;

    return DateTime.now().isBefore(expirationDate);
  }

  @override
  Widget build(BuildContext context) {
    final authServices = AuthServices(baseUrl: baseUrl);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FriendRequestCubit(),
        ),
        BlocProvider<ImageCubit>(
          create: (context) => ImageCubit(),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(authServices: authServices),
        ),
        BlocProvider<VerificationCodeBloc>(
          create: (context) => VerificationCodeBloc(authServices: authServices),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authServices: authServices),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.themeData,
            debugShowCheckedModeBanner: false,
            routes: {
              LoginPage.id: (context) => LoginPage(),
              HomePage.id: (context) => const HomePage(),
              SignUpPage.id: (context) => SignUpPage(),
              EnterYourEmail.id: (context) => const EnterYourEmail(),
              ChangePasswordPage.id: (context) => const ChangePasswordPage(),
              VerificationCodePage.id: (context) =>
                  VerificationCodePage(email: '', resetPass: false),
            },
            home: FutureBuilder<bool>(
              future: isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: mainColor));
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error occurred'));
                } else if (snapshot.hasData && snapshot.data!) {
                  return const HomePage();
                } else {
                  return LoginPage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
