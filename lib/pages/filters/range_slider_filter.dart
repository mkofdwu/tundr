import 'package:flutter/material.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/back.dart';

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
        ? RangeValues(1, widget.filter.field.options.toDouble())
        : RangeValues(
            widget.filter.options.first.toDouble(),
            widget.filter.options.last.toDouble(),
          );
  }

  void _saveOptions() {
    widget.filter.options = [_range.start.toInt(), _range.end.toInt()];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Material(
      child: Stack(
        children: <Widget>[
          MyBackButton(),
          Positioned(
            left: width * 40 / 375,
            top: height * 150 / 812,
            width: width * 220 / 375,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.filter.field.name,
                  style: TextStyle(fontSize: 50),
                ),
                SizedBox(height: 10),
                Text(
                  widget.filter.field.prompt,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: height * 500 / 812,
            right: 40,
            width: width * 220 / 375,
            child: RangeSlider(
              min: 1,
              max: widget.filter.field.options.toDouble(),
              divisions: widget.filter.field.options - 1,
              values: _range,
              activeColor: MyPalette.gold,
              inactiveColor: MyPalette.white,
              labels: RangeLabels(
                _range.start.toString(),
                _range.end.toString(),
              ),
              onChanged: (range) {
                setState(() => _range = range);
                _saveOptions();
              },
            ),
          ),
        ],
      ),
    );
  }
}
