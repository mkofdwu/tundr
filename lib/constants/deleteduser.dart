import 'package:tundr/models/user.dart';
import 'package:tundr/constants/enums/apptheme.dart';

final Map<String, dynamic> deletedUserMap = {
  "uid": "deleted",
  "phoneNumber": "",
  "username": "",
  "name": "Deleted",
  "gender": null,
  "profileImageUrl": "",
  "aboutMe": "I have deleted my account",
  "birthday": DateTime(0, 0, 0),
  "interests": [],
  "customInterests": [],
  "extraMedia": List.filled(9, null),
  "asleep": true,
  "online": false,
  "lastSeen": DateTime(0, 0, 0),
  "popularityScore": 100,
  "conversationalScore": 0,
  "blockedScore": 0,
  "showMeBoys": false,
  "showMeGirls": false,
  "ageRangeMin": 0,
  "ageRangeMax": 0,
  "personalInfo": {},
  "newMatchNotification": false,
  "messageNotification": false,
  "blockUnknownMessages": true,
  "readReceipts": false,
  "showInMostPopular": false,
  "popularityHistory": {},
  "theme": AppTheme.dark,
  "numRightSwiped": 0,
};

final User deletedUser = User(
  uid: "deleted",
  phoneNumber: "",
  username: "deleted",
  name: "Deleted",
  gender: null,
  profileImageUrl: "",
  aboutMe: "I have deleted my account",
  birthday: DateTime(0, 0, 0),
  interests: [],
  customInterests: [],
  extraMedia: List.filled(9, null),
  asleep: true,
  online: false,
  lastSeen: DateTime(0, 0, 0),
  popularityScore: 100,
  showMeBoys: false,
  showMeGirls: false,
  ageRangeMin: 0,
  ageRangeMax: 0,
  personalInfo: {},
  newMatchNotification: false,
  messageNotification: false,
  blockUnknownMessages: true,
  readReceipts: false,
  showInMostPopular: false,
  popularityHistory: {},
  theme: AppTheme.dark,
  numRightSwiped: 0,
);
