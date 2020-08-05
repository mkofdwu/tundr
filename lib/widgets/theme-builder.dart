import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/constants/enums/apptheme.dart';

class ThemeBuilder extends StatelessWidget {
  final Function buildDark;
  final Function buildLight;

  ThemeBuilder({Key key, this.buildDark, this.buildLight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Provider.of<ThemeNotifier>(context).theme) {
      case AppTheme.dark:
        return buildDark();
      case AppTheme.light:
        return buildLight();
      default:
        throw Exception(
            "Invalid theme: ${Provider.of<ThemeNotifier>(context).theme}");
    }
  }
}
