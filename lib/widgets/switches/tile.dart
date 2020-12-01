import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';

class TileSwitch extends StatefulWidget {
  final bool selected;
  final Function(bool) onChanged;

  TileSwitch({
    Key key,
    @required this.selected,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _TileSwitchState createState() => _TileSwitchState();
}

class _TileSwitchState extends State<TileSwitch> {
  bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: _selected ? MyPalette.gold : null,
          border: _selected
              ? null
              : Border.all(color: Theme.of(context).colorScheme.onPrimary),
          borderRadius: fromTheme(
            context,
            dark: null,
            light: BorderRadius.circular(15),
          ),
        ),
        padding: EdgeInsets.all(5),
        child: Align(
          alignment: _selected ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _selected
                  ? MyPalette.white
                  : Theme.of(context).colorScheme.onPrimary,
              borderRadius: fromTheme(
                context,
                dark: null,
                light: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() => _selected = !_selected);
        widget.onChanged(_selected);
      },
    );
  }
}
