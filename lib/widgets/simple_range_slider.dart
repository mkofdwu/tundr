import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class SimpleRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues defaultRange;
  final Function(RangeValues) onChanged;

  SimpleRangeSlider({
    Key key,
    @required this.min,
    @required this.max,
    @required this.defaultRange,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _SimpleRangeSliderState createState() => _SimpleRangeSliderState();
}

class _SimpleRangeSliderState extends State<SimpleRangeSlider> {
  RangeValues _rangeValues;

  @override
  void initState() {
    super.initState();
    _rangeValues = widget.defaultRange;
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      // FIXME: labels not showing
      min: widget.min,
      max: widget.max,
      values: _rangeValues,
      activeColor: MyPalette.gold,
      inactiveColor: Theme.of(context).colorScheme.onPrimary,
      divisions: (widget.max - widget.min).toInt(),
      labels: RangeLabels(
        _rangeValues.start.toInt().toString(),
        _rangeValues.end.toInt().toString(),
      ),
      onChanged: (RangeValues newRangeValues) {
        setState(() => _rangeValues = newRangeValues);
        widget.onChanged(newRangeValues);
      },
    );
  }
}
