// FUTURE: replace this with a huge list of manual options

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class SliderFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final int value;

  SliderFieldPage({
    Key key,
    @required this.field,
    this.value,
  }) : super(key: key);

  @override
  _SliderFieldPageState createState() => _SliderFieldPageState();
}

class _SliderFieldPageState extends State<SliderFieldPage> {
  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value == null
        ? (widget.field.options + 1) / 2
        : widget.value.toDouble();
  }

  void _return() {
    Navigator.pop(context, _value.toInt());
  }

  Widget _buildDark() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: Material(
        color: MyPalette.black,
        child: Stack(
          children: <Widget>[
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
              child: Slider(
                min: 1.0,
                max: widget.field.options.toDouble(),
                divisions: widget.field.options - 1,
                value: _value,
                activeColor: MyPalette.gold,
                inactiveColor: MyPalette.white,
                label: _value.toInt().toString(),
                onChanged: (value) => setState(() => _value = value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLight() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: Material(
        color: MyPalette.white,
        child: Stack(
          children: <Widget>[
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
              child: Slider(
                min: 1.0,
                max: widget.field.options.toDouble(),
                divisions: widget.field.options - 1,
                value: _value,
                activeColor: MyPalette.gold,
                inactiveColor: MyPalette.black,
                label: _value.toInt().toString(),
                onChanged: (value) => setState(() => _value = value),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
