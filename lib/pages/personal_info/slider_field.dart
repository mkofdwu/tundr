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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: Material(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: TileIconButton(
                icon: Icons.arrow_back,
                onPressed: _return,
              ),
            ),
            Positioned(
              left: 40,
              top: height * 120 / 812,
              width: width - 100,
              child: Text(
                widget.field.prompt,
                style: TextStyle(fontSize: 34),
              ),
            ),
            Positioned(
              left: width * 150 / 375,
              top: height * 500 / 812,
              width: width * 200 / 375,
              child: Slider(
                min: 1,
                max: widget.field.options.toDouble(),
                divisions: widget.field.options - 1,
                value: _value,
                activeColor: MyPalette.gold,
                inactiveColor: Theme.of(context).colorScheme.onPrimary,
                label: _value.toInt().toString(),
                onChanged: (value) => setState(() => _value = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
