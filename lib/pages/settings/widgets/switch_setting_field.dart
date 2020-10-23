import 'package:flutter/material.dart';
import 'package:tundr/constants/colors.dart';
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
                  color: AppColors.gold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0),
        TileSwitch(
          selected: selected,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
