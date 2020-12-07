import 'package:flutter/material.dart';

Future<T> showMyOptionsDialog<T>({
  @required BuildContext context,
  @required String title,
  @required Map<String, T> options,
}) =>
    showDialog(
      context: context,
      child: SimpleDialog(
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
