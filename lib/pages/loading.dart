import 'package:flutter/material.dart';
import 'package:tundr/widgets/loaders/loader.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Center(
          child: Loader(),
        ),
      ),
    );
  }
}
