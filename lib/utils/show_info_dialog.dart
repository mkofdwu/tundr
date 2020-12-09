import 'package:flutter/material.dart';

Future<void> showInfoDialog({
  @required BuildContext context,
  @required String title,
  String content,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content == null ? null : Text(content),
        actions: [
          FlatButton(
            child: Text('CLOSE'),
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
