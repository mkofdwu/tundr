import 'package:flutter/material.dart';

Future<bool> showMyQuestionDialog({
  @required BuildContext context,
  @required String title,
  String content,
}) async =>
    (await showDialog(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(content ?? ''),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => Navigator.pop(context, true),
          ),
          FlatButton(
            child: Text('CANCEL'),
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    )) ??
    false;
