import 'package:flutter/material.dart';
import 'package:tundr/constants/colors.dart';

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
        backgroundColor: AppColors.white,
        elevation: 5.0,
        avatar: _inputting
            ? null
            : Icon(
                Icons.add,
                color: AppColors.gold,
              ),
        label: _inputting
            ? SizedBox(
                width: 200.0,
                height: 24.0,
                child: TextField(
                  cursorColor: AppColors.black,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gold),
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
                  color: AppColors.gold,
                  fontSize: 16.0,
                ),
              ),
      ),
      onTap: () => setState(() => _inputting = true),
    );
  }
}
