import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/models/BLoCs/Theme/theme_bloc.dart';
import 'package:chat/models/BLoCs/Theme/theme_event.dart';

class ChangeThemeButton extends StatefulWidget {
  @override
  _ChangeThemeButtonState createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    final currentTheme = context.read<ThemeBloc>().state.themeData;
    isDarkMode = currentTheme.brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDarkMode,
      onChanged: (value) {
        setState(() {
          isDarkMode = value;
        });
        context.read<ThemeBloc>().add(ToggleThemeEvent());
      },
      thumbIcon: isDarkMode
          ? WidgetStateProperty.all<Icon>(const Icon(Icons.sunny))
          : WidgetStateProperty.all<Icon>(const Icon(Icons.dark_mode)),
     activeColor: Colors.black,
      // inactiveTrackColor: Colors.grey,
      // activeTrackColor: Colors.black,
      // inactiveThumbColor: Colors.white,
    );
  }
}
