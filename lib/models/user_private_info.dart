import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/known_suggestion.dart';
import 'package:tundr/models/user_settings.dart';
import 'package:tundr/repositories/registration_info.dart';

class UserPrivateInfo {
  String phoneNumber;
  Map<int, double> popularityHistory;
  double popularityScore;
  UserSettings settings;
  List<String> dailyGeneratedSuggestions;
  List<KnownSuggestion> respondedSuggestions;
  Map<String, bool> suggestionsGoneThrough; // uid: liked
  AppTheme theme;
  int numRightSwiped;
  List<String> blocked;
  List<Chat>
      chats; // FIXME FUTURE remove user chats fields from private info, replace with chatsStream() and streambuilder?
  List<Chat> unknownChats;
  List<String> matches;

  UserPrivateInfo({
    this.phoneNumber,
    this.popularityHistory,
    this.popularityScore,
    this.settings,
    this.dailyGeneratedSuggestions,
    this.suggestionsGoneThrough,
    this.theme,
    this.numRightSwiped,
    this.blocked,
    this.chats,
    this.unknownChats,
    this.matches,
  });

  static Future<UserPrivateInfo> fromDoc(DocumentSnapshot doc) async {
    // subcollection of all the user's chats
    final chatDocs = (await doc.reference.collection('chats').get()).docs;
    final unknownChatDocs =
        (await doc.reference.collection('unknown_chats').get()).docs;
    final data = doc.data();
    return UserPrivateInfo(
      phoneNumber: data['phoneNumber'],
      popularityHistory: data['popularityHistory'],
      popularityScore: data['popularityScore'],
      settings: UserSettings.fromMap(data['settings']),
      dailyGeneratedSuggestions: data['dailyGeneratedSuggestions'],
      suggestionsGoneThrough: data['suggestionsGoneThrough'],
      theme: AppTheme.values.elementAt(data['theme']),
      numRightSwiped: data['numRightSwiped'],
      blocked: data['blocked'],
      chats: chatDocs.map((doc) => Chat.fromDoc(doc)),
      unknownChats: unknownChatDocs.map((doc) => Chat.fromDoc(doc)),
      matches: data['matches'],
    );
  }

  factory UserPrivateInfo.register(RegistrationInfo info) {
    return UserPrivateInfo(
        // TODO
        );
  }

  Map<String, dynamic> toMap() {
    return {
      // TODO
    };
  }
}
