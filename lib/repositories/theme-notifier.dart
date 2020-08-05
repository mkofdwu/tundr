import 'package:flutter/material.dart';
import 'package:tundr/constants/enums/apptheme.dart';

class ThemeNotifier with ChangeNotifier {
  AppTheme theme;

  // ThemeNotifier(this._theme); // is this ok?

  // AppTheme get theme => _theme;

  void setTheme(AppTheme theme) {
    this.theme = theme;
    notifyListeners();
  }
}
