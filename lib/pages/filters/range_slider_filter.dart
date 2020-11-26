import 'package:flutter/material.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/theme_builder.dart';

class RangeSliderFilterPage extends StatefulWidget {
  final Filter filter;

  RangeSliderFilterPage({
    Key key,
    @required this.filter,
  }) : super(key: key);

  @override
  _RangeSliderFilterPageState createState() => _RangeSliderFilterPageState();
}

class _RangeSliderFilterPageState extends State<RangeSliderFilterPage> {
  RangeValues _range;

  @override
  void initState() {
    super.initState();
    _range = widget.filter.options == null
        ? RangeValues(1.0, widget.filter.field.options.toDouble())
        : RangeValues(
            widget.filter.options.first.toDouble(),
            widget.filter.options.last.toDouble(),
          );
  }

  void _saveOptions() {
    widget.filter.options = [_range.start.toInt(), _range.end.toInt()];
  }

  Widget _buildDark() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        _saveOptions();
        return Future(() => true);
      },
      child: Material(
        child: Stack(
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              onPressed: () {
                _saveOptions();
                Navigator.pop(context);
              },
            ),
            Positioned(
              left: width * 37 / 375,
              top: height * 100 / 812,
              width: width * 200 / 375,
              child: Text(
                widget.filter.field.name,
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
              child: RangeSlider(
                min: 1.0,
                max: widget.filter.field.options.toDouble(),
                divisions: widget.filter.field.options - 1,
                values: _range,
                activeColor: MyPalette.gold,
                inactiveColor: MyPalette.white,
                labels: RangeLabels(
                  _range.start.toString(),
                  _range.end.toString(),
                ),
                onChanged: (range) => setState(() => _range = range),
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
        _saveOptions();
        return Future(() => true);
      },
      child: Material(
        color: MyPalette.white,
        child: Stack(
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              onPressed: () {
                _saveOptions();
                Navigator.pop(context);
              },
            ),
            Positioned(
              left: width * 37 / 375,
              top: height * 100 / 812,
              width: width * 200 / 375,
              child: Text(
                widget.filter.field.name,
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
              child: RangeSlider(
                min: 1.0,
                max: widget.filter.field.options.toDouble(),
                divisions: widget.filter.field.options - 1,
                values: _range,
                activeColor: MyPalette.gold,
                inactiveColor: MyPalette.black,
                labels: RangeLabels(
                  _range.start.toString(),
                  _range.end.toString(),
                ),
                onChanged: (range) => setState(() => _range = range),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      buildDark: _buildDark,
      buildLight: _buildLight,
    );
  }
}
