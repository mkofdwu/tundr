import 'package:flutter/material.dart';

Future<T> showOptionsDialog<T>({
  @required BuildContext context,
  String title,
  @required Map<String, T> options,
}) =>
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: title == null ? null : Text(title),
        children: options
            .map((option, value) => MapEntry(
                option,
                FlatButton(
                  child: Text(option),
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () => Navigator.pop(context, value),
                )))
            .values
            .toList(),
      ),
    );
