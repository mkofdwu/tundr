import 'package:flutter/foundation.dart';

import 'package:tundr/models/user_algorithm_data.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';

class CurrentUser extends ChangeNotifier {
  UserProfile profile;
  UserPrivateInfo privateInfo;
  UserAlgorithmData algorithmData;
  String fcmToken;

  CurrentUser({
    this.profile,
    this.privateInfo,
    this.algorithmData,
    this.fcmToken,
  });
}
