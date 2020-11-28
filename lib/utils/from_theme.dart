import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/theme_manager.dart';

T fromTheme<T>(BuildContext context, {T dark, T light}) {
  switch (Provider.of<ThemeManager>(context).theme) {
    case ThemeMode.dark:
      return dark;
    case ThemeMode.light:
      return light;
    default:
      throw 'invalid theme: ${Provider.of<ThemeManager>(context).theme}';
  }
}
