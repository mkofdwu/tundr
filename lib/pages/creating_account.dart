import 'package:flutter/material.dart';
import 'package:tundr/widgets/loaders/loader.dart';

class CreatingAccountPage extends StatefulWidget {
  @override
  _CreatingAccountPageState createState() => _CreatingAccountPageState();
}

class _CreatingAccountPageState extends State<CreatingAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Loader(),
            SizedBox(height: 20),
            Text('Setting up your account...'),
          ],
        ),
      ),
    );
  }
}
