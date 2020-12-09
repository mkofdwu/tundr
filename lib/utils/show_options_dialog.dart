import 'package:flutter/material.dart';

Future<T> showOptionsDialog<T>({
  @required BuildContext context,
  @required String title,
  @required Map<String, T> options,
}) =>
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
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
