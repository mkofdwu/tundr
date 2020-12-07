import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

Future<void> showMyErrorDialog({
  @required BuildContext context,
  @required String title,
  String content,
}) =>
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: MyPalette.red,
        title: Text(title, style: TextStyle(color: MyPalette.white)),
        content: Text(content ?? '', style: TextStyle(color: MyPalette.white)),
        actions: [
          FlatButton(
            child: Text('Close'),
            textColor: MyPalette.white,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
