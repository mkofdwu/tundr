import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/theme_notifier.dart';
import 'package:tundr/enums/app_theme.dart';

T fromTheme<T>(BuildContext context, {T dark, T light}) {
  switch (Provider.of<ThemeNotifier>(context).theme) {
    case AppTheme.dark:
      return dark;
    case AppTheme.light:
      return light;
  }
  return null;
}
