import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/models/user_settings.dart';
import 'package:tundr/repositories/registration_info.dart';

class UserPrivateInfo {
  String phoneNumber;
  Map<int, double> popularityHistory;
  double popularityScore;
  UserSettings settings;
  List<String> dailyGeneratedSuggestions;
  Map<String, bool> respondedSuggestions;
  Map<String, bool> suggestionsGoneThrough; // uid: liked
  AppTheme theme;
  int numRightSwiped;
  List<String> blocked;
  List<String> matches;

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
    this.matches,
  });

  factory UserPrivateInfo.fromMap(Map<String, dynamic> map) {
    return UserPrivateInfo(
      phoneNumber: map['phoneNumber'],
      popularityHistory: map['popularityHistory'],
      popularityScore: map['popularityScore'],
      settings: UserSettings.fromMap(map['settings']),
      dailyGeneratedSuggestions: map['dailyGeneratedSuggestions'],
      respondedSuggestions: map['respondedSuggestions'],
      suggestionsGoneThrough: map['suggestionsGoneThrough'],
      theme: AppTheme.values.elementAt(map['theme']),
      numRightSwiped: map['numRightSwiped'],
      blocked: map['blocked'],
      matches: map['matches'],
    );
  }

  factory UserPrivateInfo.register(RegistrationInfo info) {
    return UserPrivateInfo(
      phoneNumber: info.phoneNumber,
      popularityHistory: {DateTime.now().millisecondsSinceEpoch: 100},
      popularityScore: 100,
      settings: UserSettings.register(),
      dailyGeneratedSuggestions: [],
      respondedSuggestions: {},
      suggestionsGoneThrough: {},
      theme: AppTheme.dark,
      numRightSwiped: 0,
      blocked: [],
      matches: [],
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
      'theme': AppTheme.values.indexOf(theme),
      'numRightSwiped': numRightSwiped,
      'blocked': blocked,
      'matches': matches,
    };
  }
}
