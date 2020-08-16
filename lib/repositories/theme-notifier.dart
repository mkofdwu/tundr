import 'package:flutter/material.dart';
import 'package:tundr/constants/enums/apptheme.dart';

class ThemeNotifier extends ChangeNotifier {
  AppTheme _theme = AppTheme.dark;

  AppTheme get theme => _theme;

  set theme(AppTheme theme) {
    this._theme = theme;
    notifyListeners();
  }
}
