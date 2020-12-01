import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/switches/tile.dart';

class SwitchSettingField extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final Function(bool) onChanged;

  SwitchSettingField({
    Key key,
    @required this.title,
    @required this.description,
    @required this.selected,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        TileSwitch(
          selected: selected,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
