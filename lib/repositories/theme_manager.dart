import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.dark;

  ThemeMode get theme => _theme;

  set theme(ThemeMode newTheme) {
    _theme = newTheme;
    notifyListeners();
  }
}
