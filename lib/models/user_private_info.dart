import 'package:flutter/material.dart';
import 'package:tundr/models/user_settings.dart';
import 'package:tundr/repositories/registration_info.dart';

class UserPrivateInfo {
  String phoneNumber;
  List<String>
      popularityHistory; // list of (timestamp, score) pairs formatted as 'timestamp:score'
  num popularityScore;
  UserSettings settings;
  List<String> dailyGeneratedSuggestions;
  Map<String, bool> respondedSuggestions;
  Map<String, bool> suggestionsGoneThrough; // uid: liked
  ThemeMode theme;
  int numRightSwiped;
  List<String> blocked;

  UserPrivateInfo({
    this.phoneNumber,
    this.popularityHistory,
    this.popularityScore,
    this.settings,
    this.dailyGeneratedSuggestions,
    this.respondedSuggestions,
    this.suggestionsGoneThrough,
    this.theme,
    this.numRightSwiped,
    this.blocked,
  });

  factory UserPrivateInfo.fromMap(Map<String, dynamic> map) {
    return UserPrivateInfo(
      phoneNumber: map['phoneNumber'],
      popularityHistory: List<String>.from(map['popularityHistory']),
      popularityScore: map['popularityScore'],
      settings: UserSettings.fromMap(map['settings']),
      dailyGeneratedSuggestions:
          List<String>.from(map['dailyGeneratedSuggestions']),
      respondedSuggestions: Map<String, bool>.from(map['respondedSuggestions']),
      suggestionsGoneThrough:
          Map<String, bool>.from(map['suggestionsGoneThrough']),
      // only 2 themes, may have multiple accents in the future
      theme: map['theme'] == null
          ? null
          : (map['theme'] == 0 ? ThemeMode.dark : ThemeMode.light),
      numRightSwiped: map['numRightSwiped'],
      blocked: List<String>.from(map['blocked']),
    );
  }

  factory UserPrivateInfo.register(RegistrationInfo info) {
    return UserPrivateInfo(
      phoneNumber: info.phoneNumber,
      popularityHistory: ['${DateTime.now().millisecondsSinceEpoch}:100'],
      popularityScore: 100,
      settings: UserSettings.register(),
      dailyGeneratedSuggestions: [],
      respondedSuggestions: {},
      suggestionsGoneThrough: {},
      theme: null,
      numRightSwiped: 0,
      blocked: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'popularityHistory': popularityHistory,
      'popularityScore': popularityScore,
      'settings': settings.toMap(),
      'dailyGeneratedSuggestions': dailyGeneratedSuggestions,
      'respondedSuggestions': respondedSuggestions,
      'suggestionsGoneThrough': suggestionsGoneThrough,
      'theme': theme == null ? null : (theme == ThemeMode.dark ? 0 : 1),
      'numRightSwiped': numRightSwiped,
      'blocked': blocked,
    };
  }
}
