import 'package:chat/core/theme/colors/app_color_dark.dart';
import 'package:chat/core/utils/constants.dart';
import 'package:flutter/material.dart';


ThemeData darkTheme = ThemeData(
 
  scaffoldBackgroundColor:  AppColorDark.backgroundDark,

  appBarTheme:  AppBarTheme(
    backgroundColor: AppColorDark.backgroundDark,

  ),
  

  textTheme: TextTheme(
   displaySmall: TextStyle(
    color: AppColorDark.kWhiteDark,
    fontFamily: font,
   )
  ),
  hintColor: AppColorDark.kWhiteDark,
  primaryTextTheme: TextTheme(
     displaySmall: TextStyle(
    color: AppColorDark.kWhiteDark,
    fontFamily: font,
   )
  )

  
  
  
);