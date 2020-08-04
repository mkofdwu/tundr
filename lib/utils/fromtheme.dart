import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/themenotifier.dart';
import 'package:tundr/utils/constants/enums/apptheme.dart';

dynamic fromTheme(BuildContext context, {dynamic dark, dynamic light}) {
  switch (Provider.of<ThemeNotifier>(context).theme) {
    case AppTheme.dark:
      return dark;
    case AppTheme.light:
      return light;
  }
}
