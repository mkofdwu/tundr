import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

Future<void> showErrorDialog({
  @required BuildContext context,
  @required String title,
  String content,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyPalette.red,
        title: Text(title, style: TextStyle(color: MyPalette.white)),
        content: content == null
            ? null
            : Text(content, style: TextStyle(color: MyPalette.white)),
        actions: [
          FlatButton(
            child: Text('CLOSE'),
            textColor: MyPalette.white,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
