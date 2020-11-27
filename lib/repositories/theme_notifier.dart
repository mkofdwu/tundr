import 'package:flutter/material.dart';
import 'package:tundr/enums/app_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  AppTheme theme = AppTheme.dark;
  void notifyListeners_() => notifyListeners();
}
