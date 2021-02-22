import 'package:flutter/material.dart';
import 'package:tundr/constants/features.dart';

class MyFeature extends StatelessWidget {
  final String featureId;
  final Widget tapTarget;
  final String title;
  final String description;
  final Widget child;

  MyFeature(
      {Key key,
      this.featureId,
      this.tapTarget,
      this.title,
      this.description,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(features.contains(featureId));
    return child;
  }
}
