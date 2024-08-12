import 'package:bloc/bloc.dart';
import 'package:chat/models/BLoCs/Theme/theme_event.dart';
import 'package:chat/models/BLoCs/Theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: ThemeData.light())) {
    on<ToggleThemeEvent>(_onToggleThemeEvent);  // Register the event handler
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(ThemeState(themeData: isDarkMode ? ThemeData.dark() : ThemeData.light()));
  }

  void _onToggleThemeEvent(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final isDarkMode = state.themeData.brightness == Brightness.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    emit(ThemeState(themeData: isDarkMode ? ThemeData.dark() : ThemeData.light()));
  }
}
