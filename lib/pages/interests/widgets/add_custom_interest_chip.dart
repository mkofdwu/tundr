import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class AddCustomInterestChip extends StatefulWidget {
  final Function(String) onAddCustomInterest;

  AddCustomInterestChip({Key key, @required this.onAddCustomInterest})
      : super(key: key);

  @override
  _AddCustomInterestChipState createState() => _AddCustomInterestChipState();
}

class _AddCustomInterestChipState extends State<AddCustomInterestChip> {
  FocusNode _inputFocusNode;
  bool _inputting = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode = FocusNode();
    _inputFocusNode.addListener(() {
      if (!_inputFocusNode.hasFocus) {
        setState(() => _inputting = false);
      }
    });
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Chip(
          labelPadding: const EdgeInsets.only(left: 4, right: 6),
          backgroundColor: MyPalette.white,
          elevation: 5,
          avatar: _inputting
              ? null
              : Icon(
                  Icons.add,
                  color: MyPalette.gold,
                ),
          label: _inputting
              ? TextField(
                  key: ValueKey('addCustomInterestField'),
                  cursorColor: MyPalette.black,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    focusedBorder: InputBorder.none,
                  ),
                  style: TextStyle(color: MyPalette.black),
                  autofocus: true,
                  onSubmitted: (customInterest) {
                    widget.onAddCustomInterest(customInterest);
                    setState(() => _inputting = false);
                  },
                  focusNode: _inputFocusNode,
                )
              : Text(
                  'Add new',
                  style: TextStyle(
                    color: MyPalette.gold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
      onTap: () => setState(() => _inputting = true),
    );
  }
}
