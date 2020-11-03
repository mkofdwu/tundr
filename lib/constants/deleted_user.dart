import 'package:tundr/models/user_profile.dart';

final Map<String, dynamic> deletedUserMap = {
  'uid': 'deleted',
  'username': 'deleted',
  'name': 'Deleted',
  'gender': null,
  'profileImageUrl': '',
  'aboutMe': 'I have deleted my account',
  'birthday': DateTime(0, 0, 0),
  'interests': [],
  'customInterests': [],
  'extraMedia': List.filled(9, null),
  'personalInfo': {},
};

final UserProfile deletedUserProfile = UserProfile(
  uid: 'deleted',
  username: 'deleted',
  name: 'Deleted',
  gender: null,
  profileImageUrl: '',
  aboutMe: 'I have deleted my account',
  birthday: DateTime(0, 0, 0),
  interests: [],
  customInterests: [],
  extraMedia: List.filled(9, null),
  personalInfo: {},
);
