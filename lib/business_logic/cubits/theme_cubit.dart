import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences preferences;

  ThemeCubit({required this.preferences}) : super(_loadTheme(preferences));

  static ThemeMode _loadTheme(SharedPreferences preferences) {
    final isDark = preferences.getBool(_themeKey) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    preferences.setBool(_themeKey, newTheme == ThemeMode.dark);
    emit(newTheme);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}