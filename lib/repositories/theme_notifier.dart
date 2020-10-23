import 'package:flutter/material.dart';
import 'package:tundr/enums/app_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  AppTheme _theme = AppTheme.dark;

  AppTheme get theme => _theme;

  set theme(AppTheme theme) {
    _theme = theme;
    notifyListeners();
  }
}
