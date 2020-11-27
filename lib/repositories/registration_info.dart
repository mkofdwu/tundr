import 'package:flutter/widgets.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/models/media.dart';

class RegistrationInfo extends ChangeNotifier {
  String username = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  DateTime birthday;
  Gender gender;
  Media profilePic;
  String aboutMe = '';
  List<Media> extraMedia = List<Media>.filled(9, null);
  Map<String, dynamic> personalInfo = {};
  List<String> interests = [];
  List<String> customInterests = [];
  String phoneNumber = '+65';
  String uid;
  AppTheme theme;

  String smsVerificationId;
  bool isCreatingAccount = false;

  @override
  String toString() => 'RegistrationInfo('
      'username: $username, '
      'password: $password, '
      'confirmPassword: $confirmPassword, '
      'name: $name, '
      'birthday: $birthday, '
      'gender: $gender, '
      'profilePic: $profilePic, '
      'aboutMe: $aboutMe, '
      'extraMedia: $extraMedia, '
      'personalInfo: $personalInfo, '
      'interests: $interests, '
      'customInterests: $customInterests, '
      'phoneNumber: $phoneNumber, '
      'uid: $uid, '
      'theme: $theme, '
      'smsVerificationId: $smsVerificationId, '
      'isCreatingAccount: $isCreatingAccount, '
      ')';
}
