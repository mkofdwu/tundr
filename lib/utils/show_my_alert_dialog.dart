import 'package:flutter/material.dart';

Future<void> showMyAlertDialog({
  @required BuildContext context,
  @required String title,
  String content,
}) =>
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(content ?? ''),
        actions: [
          FlatButton(
            child: Text('Close'),
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
