import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/repositories/theme_manager.dart';

import 'package:tundr/constants/my_palette.dart';

class SetupThemePage extends StatefulWidget {
  @override
  _SetupThemePageState createState() => _SetupThemePageState();
}

class _SetupThemePageState extends State<SetupThemePage> {
  Future<void> _selectTheme(ThemeMode theme) async {
    Provider.of<ThemeManager>(context).theme = theme;
    await Provider.of<User>(context, listen: false)
        .updatePrivateInfo({'theme': theme == ThemeMode.dark ? 0 : 1});
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                    boxShadow: [MyPalette.primaryShadow],
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
                onTap: () => _selectTheme(ThemeMode.light),
              ),
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: MyPalette.black,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [MyPalette.primaryShadow],
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
                onTap: () => _selectTheme(ThemeMode.dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
