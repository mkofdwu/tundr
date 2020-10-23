import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/repositories/theme_notifier.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/enums/app_theme.dart';

class SetupThemePage extends StatefulWidget {
  @override
  _SetupThemePageState createState() => _SetupThemePageState();
}

class _SetupThemePageState extends State<SetupThemePage> {
  Future<void> _selectTheme(AppTheme theme) async {
    Provider.of<ThemeNotifier>(context).theme = theme;
    await DatabaseService.setUserField(
      Provider.of<CurrentUser>(context).user.uid,
      'theme',
      AppTheme.values.indexOf(theme),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text(
                'Select a theme',
                style: TextStyle(
                  color: AppColors.black,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowGrey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Light',
                        style: TextStyle(
                          color: AppColors.black,
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
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowGrey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Dark',
                        style: TextStyle(
                          color: AppColors.white,
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
