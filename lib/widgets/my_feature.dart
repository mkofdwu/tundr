import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:tundr/constants/features.dart';
import 'package:tundr/constants/my_palette.dart';

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
    return DescribedFeatureOverlay(
      featureId: featureId,
      tapTarget: tapTarget,
      title: Text(title),
      description: Text(description),
      targetColor: MyPalette.white.withOpacity(0.8),
      backgroundColor: Theme.of(context).accentColor,
      overflowMode: OverflowMode.extendBackground,
      child: child,
    );
  }
}
