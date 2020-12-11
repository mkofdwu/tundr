import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/repositories/theme_manager.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/rebuilder.dart';

class SetupThemePage extends StatefulWidget {
  @override
  _SetupThemePageState createState() => _SetupThemePageState();
}

class _SetupThemePageState extends State<SetupThemePage> {
  Future<void> _selectTheme(ThemeMode theme) async {
    Provider.of<ThemeManager>(context, listen: false).theme = theme;
    await Provider.of<User>(context, listen: false)
        .updatePrivateInfo({'theme': theme == ThemeMode.dark ? 0 : 1});
    Rebuilder.rebuild(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyPalette.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Select a theme',
              style: TextStyle(
                color: MyPalette.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: MyPalette.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [MyPalette.secondaryShadow],
                  ),
                  child: Center(
                    child: Text(
                      'Light',
                      style: TextStyle(
                        color: MyPalette.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                onTap: () => _selectTheme(ThemeMode.light),
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: MyPalette.black,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [MyPalette.secondaryShadow],
                  ),
                  child: Center(
                    child: Text(
                      'Dark',
                      style: TextStyle(
                        color: MyPalette.white,
                        fontSize: 20,
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
