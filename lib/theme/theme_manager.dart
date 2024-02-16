import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isLight) {
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
