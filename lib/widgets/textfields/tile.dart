import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class TileTextField extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxChars;
  final int maxLines;
  final bool autoFocus;
  final bool moveFocus;
  final Function onEditingComplete;

  TileTextField({
    Key key,
    this.width = double.infinity,
    this.height = 40.0,
    this.color = MyPalette.white,
    @required this.controller,
    this.hintText = '',
    this.obscureText = false,
    this.maxChars,
    this.maxLines = 1,
    this.autoFocus = false,
    this.moveFocus = true,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(
        left: 20,
        top: 10.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [MyPalette.primaryShadow],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 10.0),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: MyPalette.grey,
            fontSize: 20.0,
            fontFamily: 'Helvetica Neue',
          ),
          counterText: '',
        ),
        style: TextStyle(
          color: MyPalette.black,
          fontSize: 20.0,
          fontFamily: 'Helvetica Neue',
        ),
        cursorColor: MyPalette.black,
        controller: controller,
        autofocus: autoFocus,
        maxLines: maxLines,
        maxLength: maxChars,
        obscureText: obscureText,
        onEditingComplete: () {
          if (onEditingComplete != null) onEditingComplete();
          if (moveFocus) FocusScope.of(context).nextFocus();
        },
        onSubmitted: (String value) {},
      ),
    );
  }
}
