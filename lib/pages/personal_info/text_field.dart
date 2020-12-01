// FUTURE: replace this with a huge list of manual options

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';

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

  void _return() {
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
          SafeArea(
            child: TileIconButton(
              icon: Icons.arrow_back,
              onPressed: _return,
            ),
          ),
          Positioned(
            left: width * 37 / 375,
            top: height * 100 / 812,
            width: width * 200 / 375,
            child: Text(
              widget.field.prompt,
              style: TextStyle(
                color: MyPalette.white,
                fontSize: 40,
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
              cursorColor: MyPalette.white,
              style: TextStyle(
                color: MyPalette.white,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: MyPalette.white,
                    width: 2,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: MyPalette.white,
                    width: 5,
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
                  color: MyPalette.black,
                  fontSize: 40,
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
                cursorColor: MyPalette.black,
                style: TextStyle(
                  color: MyPalette.black,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: MyPalette.black,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: MyPalette.black,
                      width: 5,
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
    switch (Provider.of<ThemeManager>(context).theme) {
      case ThemeMode.dark:
        return _buildDark();
      case ThemeMode.light:
        return _buildLight();
      default:
        throw Exception(
            'Invalid theme: ${Provider.of<ThemeManager>(context).theme}');
    }
  }
}
