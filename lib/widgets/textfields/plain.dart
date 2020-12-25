import 'package:flutter/material.dart';

class PlainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color hintTextColor;
  final Color color;
  final double fontSize;
  final String fontFamily;
  final Function(String) onChanged;

  PlainTextField({
    Key key,
    @required this.controller,
    this.hintText = '',
    this.hintTextColor,
    this.color,
    this.fontSize = 20,
    this.fontFamily,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: color,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
        ),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
    );
  }
}
