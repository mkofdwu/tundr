import 'dart:math';

import 'package:tundr/models/user_profile.dart';

class PopularUser {
  UserProfile profile;
  num popularityScore;
  int position;
  double tileHeight;

  PopularUser({this.profile, this.popularityScore, this.position}) {
    tileHeight = Random().nextDouble() * 50 + 200;
  }
}
