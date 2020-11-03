import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class UnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color color;
  final String hintText;
  final bool obscureText;
  final bool autoFocus;
  final bool moveFocus;
  final TextInputType keyboardType;
  final Function onEditingComplete;

  UnderlineTextField({
    Key key,
    @required this.controller,
    this.color = MyPalette.white,
    this.hintText = '',
    this.obscureText = false,
    this.autoFocus = false,
    this.moveFocus = true,
    this.keyboardType,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      controller: controller,
      obscureText: obscureText,
      cursorColor: color, // AppColors.white
      keyboardType: keyboardType,
      style: TextStyle(
        color: color, // AppColors.white
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: MyPalette.grey,
          fontSize: 20.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 5.0,
          ),
        ),
      ),
      onEditingComplete: () {
        if (onEditingComplete != null) onEditingComplete();
        if (moveFocus) FocusScope.of(context).nextFocus();
      },
    );
  }
}
