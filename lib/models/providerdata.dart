// FIXME: this is a temporary solution, using a better method in the future

import 'package:flutter/foundation.dart';
import "package:tundr/models/user.dart";

class ProviderData extends ChangeNotifier {
  User user;
  String fcmToken;

  // ProviderData(this.user); // slightly awkward solution
}
