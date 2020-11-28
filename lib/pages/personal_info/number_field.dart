import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/underline.dart';

class NumberFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final int value;

  NumberFieldPage({
    Key key,
    @required this.field,
    @required this.value,
  }) : super(key: key);

  @override
  _NumberFieldPageState createState() => _NumberFieldPageState();
}

class _NumberFieldPageState extends State<NumberFieldPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) _controller.text = widget.value.toString();
  }

  void _return() {
    Navigator.pop(context, int.tryParse(_controller.text));
  }

  Widget _buildDark() => WillPopScope(
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
                  color: MyPalette.white,
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
                keyboardType: TextInputType.number,
                controller: _controller,
                cursorColor: MyPalette.white,
                style: TextStyle(
                  color: MyPalette.white,
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: MyPalette.white,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: MyPalette.white,
                      width: 5.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

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
                  fontSize: 40.0,
                ),
              ),
            ),
            Positioned(
              left: width * 150 / 375,
              top: height * 500 / 812,
              width: width * 200 / 375,
              child: UnderlineTextField(
                controller: _controller,
                autoFocus: true,
                keyboardType: TextInputType.number,
              ),
              // child: TextField(
              //   autofocus: true,
              //   keyboardType: TextInputType.number,
              //   controller: _controller,
              //   cursorColor: AppColors.black,
              //   style: TextStyle(
              //     color: AppColors.black,
              //     fontSize: 20.0,
              //   ),
              //   decoration: InputDecoration(
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(
              //         color: AppColors.black,
              //         width: 2.0,
              //       ),
              //     ),
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(
              //         color: AppColors.black,
              //         width: 5.0,
              //       ),
              //     ),
              //   ),
              // ),
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
