import 'package:flutter/widgets.dart';
import 'package:tundr/enums/apptheme.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/models/media.dart';

class RegistrationInfo extends ChangeNotifier {
  String username = "";
  String password = "";
  String name = "";
  DateTime birthday;
  Gender gender;
  Media profilePic;
  String aboutMe = "";
  List<Media> extraMedia = List<Media>.filled(9, null);
  Map<String, dynamic> personalInfo = {};
  List<String> interests = [];
  List<String> customInterests = [];
  String phoneNumber = "+65";
  String uid;
  AppTheme theme;

  @override
  String toString() => "RegistrationInfo("
      "uid: $uid, "
      "username: $username, "
      "name: $name, "
      "birthday: $birthday, "
      "gender: $gender, "
      "profilePic: $profilePic, "
      "aboutMe: $aboutMe, "
      "extraMedia: $extraMedia, "
      "personalInfo: $personalInfo, "
      "interests: $interests, "
      "customInterests: $customInterests, "
      "phoneNumber: $phoneNumber, "
      "theme: $theme, "
      ")";
}
