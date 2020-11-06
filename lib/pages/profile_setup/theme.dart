import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/repositories/theme_notifier.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/app_theme.dart';

class SetupThemePage extends StatefulWidget {
  @override
  _SetupThemePageState createState() => _SetupThemePageState();
}

class _SetupThemePageState extends State<SetupThemePage> {
  Future<void> _selectTheme(AppTheme theme) async {
    Provider.of<ThemeNotifier>(context).theme = theme;
    await Provider.of<User>(context)
        .updatePrivateInfo({'theme': AppTheme.values.indexOf(theme)});
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: MyPalette.white,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text(
                'Select a theme',
                style: TextStyle(
                  color: MyPalette.black,
                  fontSize: 30.0,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyPalette.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: MyPalette.shadowGrey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Light',
                        style: TextStyle(
                          color: MyPalette.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => _selectTheme(AppTheme.light),
                ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyPalette.black,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: MyPalette.shadowGrey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Dark',
                        style: TextStyle(
                          color: MyPalette.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => _selectTheme(AppTheme.dark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
