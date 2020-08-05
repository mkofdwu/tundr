import 'dart:math';

import "package:flutter/widgets.dart";
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/enums/apptheme.dart';
import 'package:tundr/constants/shadows.dart';

class TileRadioGroup extends StatefulWidget {
  final AppTheme theme;
  final bool forceColumn;
  final List<String> options;
  final String selected;
  final Function(String) onChanged;

  TileRadioGroup({
    Key key,
    @required this.theme,
    this.forceColumn = false,
    @required this.options,
    this.selected,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _TileRadioGroupState createState() => _TileRadioGroupState();
}

class _TileRadioGroupState extends State<TileRadioGroup> {
  String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selected;
  }

  Widget _buildDarkTileRadio(option) => Expanded(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                  color: AppColors.gold,
                ),
              ),
              child: Container(
                color: option == _selectedOption
                    ? AppColors.gold
                    : Color(0x00000000),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Text(
                      option,
                      style: TextStyle(
                        color: option == _selectedOption
                            ? AppColors.black
                            : AppColors.gold,
                        fontSize: min(constraints.maxHeight - 3, 40.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              if (option != _selectedOption) {
                setState(() => _selectedOption = option);
                widget.onChanged(option);
              }
            },
          ),
        ),
      );

  Widget _buildLightTileRadio(option) => Expanded(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: option == _selectedOption
                    ? AppColors.gold
                    : AppColors.white,
                border: Border.all(
                  width: 2.0,
                  color: AppColors.gold,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [Shadows.secondaryShadow],
              ),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) => Text(
                    option,
                    style: TextStyle(
                      color: option == _selectedOption
                          ? AppColors.white
                          : AppColors.gold,
                      fontSize: min(constraints.maxHeight - 3, 40.0),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              if (option != _selectedOption) {
                setState(() => _selectedOption = option);
                widget.onChanged(option);
              }
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Function(String) tileRadioBuilder;
    switch (widget.theme) {
      case AppTheme.dark:
        tileRadioBuilder = _buildDarkTileRadio;
        break;
      case AppTheme.light:
        tileRadioBuilder = _buildLightTileRadio;
        break;
      default:
        throw Exception("Invalid theme: ${widget.theme}");
    }
    final List<Widget> children =
        List<Widget>.from(widget.options.map(tileRadioBuilder));
    return widget.forceColumn
        ? Column(children: children)
        : LayoutBuilder(
            builder: (context, constraints) =>
                constraints.maxWidth > constraints.maxHeight
                    ? Row(children: children)
                    : Column(children: children),
          );
  }
}
