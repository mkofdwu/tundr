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
  bool _inputting = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Chip(
        backgroundColor: MyPalette.white,
        elevation: 5.0,
        avatar: _inputting
            ? null
            : Icon(
                Icons.add,
                color: MyPalette.gold,
              ),
        label: _inputting
            ? SizedBox(
                width: 200.0,
                height: 24.0,
                child: TextField(
                  cursorColor: MyPalette.black,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyPalette.gold),
                    ),
                  ),
                  autofocus: true,
                  onSubmitted: (customInterest) {
                    widget.onAddCustomInterest(customInterest);
                    setState(() => _inputting = false);
                  },
                ),
              )
            : Text(
                'Add new',
                style: TextStyle(
                  color: MyPalette.gold,
                  fontSize: 16.0,
                ),
              ),
      ),
      onTap: () => setState(() => _inputting = true),
    );
  }
}
