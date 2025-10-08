import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Save to shared preferences (you'll need to implement storage)
  Future<void> saveThemePreference() async {
    // Implement your storage logic here
  }

  // Load from shared preferences
  Future<void> loadThemePreference() async {
    // Implement your storage logic here
  }
}