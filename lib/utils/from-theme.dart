import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/enums/apptheme.dart';

dynamic fromTheme(BuildContext context, {dynamic dark, dynamic light}) {
  switch (Provider.of<ThemeNotifier>(context).theme) {
    case AppTheme.dark:
      return dark;
    case AppTheme.light:
      return light;
  }
}
