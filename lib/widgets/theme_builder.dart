import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/theme_manager.dart';

class ThemeBuilder extends StatelessWidget {
  final Widget Function() buildDark;
  final Widget Function() buildLight;

  ThemeBuilder({Key key, this.buildDark, this.buildLight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeNotifier, child) {
        switch (themeNotifier.theme) {
          case ThemeMode.dark:
            return buildDark();
          case ThemeMode.light:
            return buildLight();
          default:
            throw 'Invalid theme: ' + themeNotifier.theme.toString();
        }
      },
    );
  }
}
