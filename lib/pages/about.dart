import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/store/theme_manager.dart';
import 'package:tundr/widgets/buttons/back.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Material(
      child: Stack(
        children: <Widget>[
          MyBackButton(),
          Positioned(
            top: height * 100 / 812,
            right: 50,
            child: Text(
              'About',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ),
          Positioned(
            top: height * 140 / 812,
            right: 30,
            width: 180,
            child: Image.asset(
                'assets/images/logo-${Provider.of<ThemeManager>(context).theme == ThemeMode.dark ? 'dark' : 'light'}.png'),
          ),
          Positioned(
            left: 40,
            top: height * 380 / 812,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Modern problems require modern solutions. I need a girlfriend so I made a dating app.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Developed by someone', // Jia Jie
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Version: 0.2.9',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text(
                    'View licenses',
                    style: TextStyle(color: MyPalette.gold),
                  ),
                  onTap: () => showLicensePage(
                      context: context, applicationVersion: '0.2.5'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
