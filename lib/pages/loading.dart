import 'package:flutter/material.dart';
import 'package:tundr/widgets/my_loader.dart';

class LoadingPage extends StatelessWidget {
  final String label;

  const LoadingPage({this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyLoader(),
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(label),
              ),
          ],
        ),
      ),
    );
  }
}
