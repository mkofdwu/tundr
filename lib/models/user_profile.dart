import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/models/media.dart';
import 'package:tundr/store/registration_info.dart';

class UserProfile {
  String uid;
  String username;
  String name;
  Gender gender;
  DateTime birthday;
  String aboutMe;
  String profileImageUrl;
  List<Media> extraMedia;
  Map<String, dynamic> personalInfo;
  List<String> interests;
  List<String> customInterests;
  bool verified;

  UserProfile({
    this.uid,
    this.username,
    this.name,
    this.gender,
    this.birthday,
    this.aboutMe,
    this.profileImageUrl,
    this.extraMedia,
    this.personalInfo,
    this.interests,
    this.customInterests,
    this.verified,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      username: map['username'],
      name: map['name'],
      gender: Gender.values[map['gender']],
      birthday: map['birthday'].toDate(),
      aboutMe: map['aboutMe'],
      profileImageUrl: map['profileImageUrl'],
      extraMedia: map['extraMedia']
          .map<Media>((m) => m == null ? null : Media.fromMap(m))
          .toList(),
      personalInfo: Map<String, dynamic>.from(map['personalInfo']),
      interests: List<String>.from(map['interests']),
      customInterests: List<String>.from(map['customInterests']),
      verified: map['verified'],
    );
  }

  factory UserProfile.register(RegistrationInfo info) {
    return UserProfile(
      uid: info.uid,
      username: info.username,
      name: info.name,
      gender: info.gender,
      birthday: info.birthday,
      aboutMe: info.aboutMe,
      profileImageUrl: info.profilePic.url,
      extraMedia: info.extraMedia,
      personalInfo: info.personalInfo,
      interests: info.interests,
      customInterests: info.customInterests,
      verified: false,
    );
  }

  factory UserProfile.deletedAccount() {
    return UserProfile(
      uid: 'deleted',
      username: 'deleted',
      name: 'Deleted',
      gender: null,
      profileImageUrl: null,
      aboutMe: 'I have deleted my account',
      birthday: DateTime(0, 0, 0),
      interests: [],
      customInterests: [],
      extraMedia: List.filled(9, null),
      personalInfo: {},
    );
  }

  int get ageInYears => DateTime.now().difference(birthday).inDays ~/ 365.25;

  @override
  String toString() => 'User(uid: $uid, username: $username)';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'gender': Gender.values.indexOf(gender),
      'birthday': Timestamp.fromDate(birthday),
      'aboutMe': aboutMe,
      'profileImageUrl': profileImageUrl,
      'extraMedia': extraMedia.map((m) => m?.toMap()).toList(),
      'personalInfo': personalInfo,
      'interests': interests,
      'customInterests': customInterests,
      'verified': verified,
    };
  }
}
