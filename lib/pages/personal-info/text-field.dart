// FUTURE: replace this with a huge list of manual options

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/personal-info-field.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/enums/apptheme.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';
import 'package:tundr/widgets/pages/stack-scroll.dart';

class TextFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final String value;

  TextFieldPage({
    Key key,
    @required this.field,
    @required this.value,
  }) : super(key: key);

  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) _controller.text = widget.value;
  }

  _return() {
    Navigator.pop(context, _controller.text);
  }

  Widget _buildDark() {
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: StackScrollPage(
        builder: (context, width, height) => <Widget>[
          TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          Positioned(
            left: width * 37 / 375,
            top: height * 100 / 812,
            width: width * 200 / 375,
            child: Text(
              widget.field.prompt,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 40.0,
              ),
            ),
          ),
          Positioned(
            left: width * 150 / 375,
            top: height * 500 / 812,
            width: width * 200 / 375,
            // child: UnderlineTextField(
            //   controller: _controller,
            //   autoFocus: true,
            // ),
            child: TextField(
              autofocus: true,
              controller: _controller,
              cursorColor: AppColors.white,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.0,
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.white,
                    width: 5.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLight() => WillPopScope(
        onWillPop: () {
          _return();
          return Future(() => false);
        },
        child: StackScrollPage(
          builder: (context, width, height) => <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              onPressed: _return,
            ),
            Positioned(
              left: width * 37 / 375,
              top: height * 100 / 812,
              width: width * 200 / 375,
              child: Text(
                widget.field.prompt,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 40.0,
                ),
              ),
            ),
            Positioned(
              left: width * 150 / 375,
              top: height * 500 / 812,
              width: width * 200 / 375,
              child: TextField(
                autofocus: true,
                controller: _controller,
                cursorColor: AppColors.black,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.black,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.black,
                      width: 5.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    switch (Provider.of<ThemeNotifier>(context).theme) {
      case AppTheme.dark:
        return _buildDark();
      case AppTheme.light:
        return _buildLight();
      default:
        throw Exception(
            "Invalid theme: ${Provider.of<ThemeNotifier>(context).theme}");
    }
  }
}
