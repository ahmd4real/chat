import 'package:chat/constants.dart';
import 'package:chat/models/BLoCs/ImageCubit/image_cubit.dart';
import 'package:chat/models/BLoCs/Login/login_bloc.dart';
import 'package:chat/models/BLoCs/SignUp/sign_up_bloc.dart';
import 'package:chat/models/BLoCs/Verification/verification_bloc.dart';
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
    final authRepository = AuthServices(baseUrl: baseUrl);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ImageCubit>(
          create: (context) => ImageCubit(),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(authRepository: authRepository),
        ),
        BlocProvider<VerificationCodeBloc>(
          create: (context) =>
              VerificationCodeBloc(authRepository: authRepository),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authServices: authRepository),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        routes: {
          LoginPage.id: (context) => LoginPage(),
          HomePage.id: (context) => const HomePage(),
          SignUpPage.id: (context) => SignUpPage(),
          EnterYourEmail.id: (context) => EnterYourEmail(),
          ChangePasswordPage.id: (context) => ChangePasswordPage(),
          VerificationCodePage.id: (context) =>
              VerificationCodePage(email: '', resetPass: false),
        },
        home: 
            FutureBuilder<bool>(
          future: Future.wait([
            isLoggedIn(),
          ]).then((results) => results[0] as bool),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error occurred'));
            } else if (snapshot.hasData && snapshot.data!) {
              return LoginPage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
