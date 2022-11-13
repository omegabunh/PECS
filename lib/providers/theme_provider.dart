//Models
import '../models/theme_preference.dart';

//Packages
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }

  late bool _isDark;
  late ThemePreferences _preferences;

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
