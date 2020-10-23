import 'package:flutter/material.dart';
import 'package:tundr/constants/colors.dart';

class InterestsWrap extends StatelessWidget {
  final List<String> interests;

  InterestsWrap({Key key, this.interests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: List<Widget>.from(
        interests.map(
          (interest) {
            return Chip(
              backgroundColor: AppColors.gold,
              elevation: 5.0,
              label: Text(
                interest,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
