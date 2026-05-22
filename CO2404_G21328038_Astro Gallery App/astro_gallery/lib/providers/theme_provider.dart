import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Manages the app themes notify listeners
class ThemeProvider extends ChangeNotifier {
  static const String _prefsKey = 'theme_mode';

  //Default theme
  ThemeMode _themeMode = ThemeMode.dark;

  //Returns the current theme mode
  ThemeMode get themeMode => _themeMode;

  //To keep track of the dark mode
  bool get isDark => _themeMode == ThemeMode.dark;

  //Loads the saved app theme from local storage
  Future<void> loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_prefsKey);
    _themeMode = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners(); //Notify all widgets that to adjust to the theme provider
  }

  //Switches between dark and light mode and saves the new value
  Future<void> toggle() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, isDark ? 'dark' : 'light');
  }
}

final ThemeProvider themeProvider = ThemeProvider();
