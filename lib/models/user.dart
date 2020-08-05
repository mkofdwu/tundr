import "package:cloud_firestore/cloud_firestore.dart";
import 'package:tundr/constants/enums/apptheme.dart';
import "package:tundr/constants/enums/gender.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/constants/personal-info-fields.dart';

class User {
  String uid;
  String phoneNumber;
  String username;
  String name;
  Gender gender;
  String profileImageUrl;
  // attributes from hereon are less significant
  String aboutMe;
  DateTime birthday;
  List<String> interests;
  List<String> customInterests;
  List<Media> extraMedia;
  bool verified;
  bool asleep;
  bool online;
  DateTime lastSeen;
  num popularityScore;
  // filters
  bool showMeBoys;
  bool showMeGirls;
  int ageRangeMin;
  int ageRangeMax;
  // personal info
  Map<String, dynamic> personalInfo;
  // preferences
  bool newMatchNotification;
  bool messageNotification;
  bool blockUnknownMessages;
  bool readReceipts;
  bool showInMostPopular;
  //
  Map<int, double> popularityHistory;
  int totalWordsSent;
  // shared preferences
  AppTheme theme;
  int lastGeneratedSuggestionsTimestamp;
  int numRightSwiped;

  User({
    this.uid,
    this.phoneNumber,
    this.username,
    this.name,
    this.gender,
    this.profileImageUrl,
    this.aboutMe,
    this.birthday,
    this.interests,
    this.customInterests,
    this.extraMedia,
    this.verified,
    this.asleep,
    this.online,
    this.lastSeen,
    this.popularityScore,
    this.showMeBoys,
    this.showMeGirls,
    this.ageRangeMin,
    this.ageRangeMax,
    this.personalInfo,
    this.newMatchNotification,
    this.messageNotification,
    this.blockUnknownMessages,
    this.readReceipts,
    this.showInMostPopular,
    this.popularityHistory,
    this.totalWordsSent,
    this.theme,
    this.lastGeneratedSuggestionsTimestamp,
    this.numRightSwiped,
  });

  int get ageInYears => DateTime.now().difference(birthday).inDays ~/ 365;

  factory User.fromDoc(DocumentSnapshot doc) {
    assert(doc.data != null);

    final Map<String, dynamic> personalInfo = {};

    personalInfoFields.keys.forEach((fieldName) {
      if (doc.data.containsKey(fieldName) && doc.data[fieldName] != null)
        personalInfo[fieldName] = doc.data[fieldName];
    });

    return User(
      uid: doc.documentID,
      phoneNumber: doc.data["phoneNumber"],
      username: doc.data["username"],
      name: doc.data["name"],
      gender: Gender.values.elementAt(doc.data["gender"]),
      profileImageUrl: doc.data["profileImageUrl"],
      aboutMe: doc.data["aboutMe"],
      birthday: doc.data["birthday"].toDate(),
      interests: List<String>.from(doc.data["interests"]),
      customInterests:
          doc.data.containsKey("customInterests") // BACKWARDS COMPATIBILITY
              ? List<String>.from(doc.data["customInterests"])
              : [],
      extraMedia: List<Media>.from(doc.data["extraMedia"].map(
          (mediaMap) => mediaMap == null ? null : Media.fromMap(mediaMap))),
      verified: doc.data.containsKey("verified") ? doc.data["verified"] : false,
      asleep: doc.data["asleep"],
      online: doc.data["online"],
      lastSeen:
          doc.data["lastSeen"] == null ? null : doc.data["lastSeen"].toDate(),
      popularityScore: doc.data["popularityScore"],
      showMeBoys: doc.data["showMeBoys"],
      showMeGirls: doc.data["showMeGirls"],
      ageRangeMin: doc.data["ageRangeMin"],
      ageRangeMax: doc.data["ageRangeMax"],
      personalInfo: personalInfo,
      newMatchNotification: doc.data["newMatchNotification"],
      messageNotification: doc.data["messageNotification"],
      blockUnknownMessages: doc.data["blockUnknownMessages"],
      readReceipts: doc.data["readReceipts"] is int
          ? doc.data["readReceipts"] == 1
          : doc.data["readReceipts"],
      showInMostPopular: doc.data["showInMostPopular"],
      popularityHistory:
          Map<int, double>.from(doc.data["popularityHistory"] ?? {}),
      totalWordsSent: doc.data["totalWordsSent"],
      theme: doc.data.containsKey("theme") // BACKWARDS COMPATIBILITY
          ? doc.data["theme"] == null
              ? null
              : AppTheme.values.elementAt(doc.data["theme"])
          : null,
      lastGeneratedSuggestionsTimestamp: doc.data.containsKey(
              "lastGeneratedSuggestionsTimestamp") // BACKWARDS COMPATIBILITY
          ? doc.data["lastGeneratedSuggestionsTimestamp"]
          : 0,
      numRightSwiped:
          doc.data.containsKey("numRightSwiped") // BACKWARDS COMPATIBILITY
              ? doc.data["numRightSwiped"]
              : 0,
    );
  }

  // @override
  // int get hashCode => uid.hashCode;

  // @override
  // bool operator ==(other) {
  //   assert(other is User, "Cannot compare User with another type");
  //   return other is User && uid == other.uid;
  // }

  @override
  String toString() =>
      "User(uid: $uid, username: $username, name: $name, popularityScore: $popularityScore)";
}
