// // TODO: delete this file, refractor to users_service, algorithm_service & chats_service

// import 'dart:async';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tundr/models/chat.dart';
// import 'package:tundr/models/filter.dart';
// import 'package:tundr/models/message.dart';
// import 'package:tundr/models/suggestion_gone_through.dart';
// import 'package:tundr/constants/deleted_user.dart';
// import 'package:tundr/enums/chat_type.dart';
// import 'package:tundr/enums/filter_method.dart';
// import 'package:tundr/enums/gender.dart';
// import 'package:tundr/repositories/registration_info.dart';
// import 'package:tundr/models/suggestion.dart';
// import 'file:///home/leejiajie/dev/flutter/tundr-android/dump/user.dart';
// import 'package:tundr/services/storage_service.dart';
// import 'package:tundr/enums/media_type.dart';
// import 'package:tundr/constants/firebase_ref.dart';

// class DatabaseService {
//   static Future<bool> usernameAlreadyExists(String username) async {
//     return (await usersPrivateInfoRef
//             .where('username', isEqualTo: username)
//             .limit(1)
//             .getDocuments())
//         .documents
//         .isNotEmpty;
//   }

//   static Future<Map<String, dynamic>> getUserMap(String uid) async {
//     final userDoc = await usersPrivateInfoRef.document(uid).get();
//     return userDoc.exists ? userDoc.data : deletedUserMap;
//   }

//   static Future<dynamic> getUserField(String uid, String field) async {
//     return (await getUserMap(uid))[field];
//   }

//   static Future<User> getUser(
//     String uid, {
//     bool returnDeletedUser = true,
//   }) async {
//     final userDoc = await usersPrivateInfoRef.document(uid).get();
//     return userDoc.exists
//         ? User.fromDoc(userDoc)
//         : (returnDeletedUser ? deletedUserProfile : null);
//   }

//   static Future<bool> phoneNumberExists(String phoneNumber) async {
//     return (await usersPrivateInfoRef
//             .where('phoneNumber', isEqualTo: phoneNumber)
//             .limit(1)
//             .getDocuments())
//         .documents
//         .isNotEmpty;
//   }

//   static Future<void> setUserField(String uid, String field, dynamic value) {
//     return usersPrivateInfoRef.document(uid).updateData({field: value});
//   }

//   static Future<void> setUserFields(String uid, Map<String, dynamic> fields) {
//     return usersPrivateInfoRef.document(uid).updateData(fields);
//   }

//   static Future<dynamic> getUserFilter(String uid, String filter) async {
//     return (await userFiltersRef.document(uid).get()).data[filter];
//   }

//   static Future<DocumentSnapshot> getUserFilters(String uid) {
//     return userFiltersRef.document(uid).get();
//   }

//   // static Future<List<Filter>> getUserFilters(String uid) async {
//   //   final filtersDoc = (await userFiltersRef.document(uid).get());
//   //   if (!filtersDoc.exists) return [];

//   //   List<Filter> filters = [];
//   //   filtersDoc.data.forEach(
//   //     (name, value) async {
//   //       if (['ageRangeMin', 'ageRangeMax', 'showMeBoys', 'showMeGirls']
//   //           .contains(name)) {
//   //         // backwards compatibility
//   //         return;
//   //       }
//   //       filters.add(Filter(
//   //         field: PersonalInfoField.fromMap(name, personalInfoFields[name]),
//   //         options: value['options'],
//   //         method: FilterMethod.values[value['method']],
//   //       ));
//   //     },
//   //   );
//   //   return filters;
//   // }

//   static Future<void> setUserFilter({
//     String uid,
//     Filter filter,
//   }) {
//     return userFiltersRef.document(uid).updateData({
//       filter.field.name: {
//         'options': filter.options,
//         'method': FilterMethod.values.indexOf(filter.method),
//       }
//     });
//   }

//   // most popular page

//   static Future<List<User>> getMostPopular(int n) async {
//     return (await usersPrivateInfoRef
//             .where('showInMostPopular', isEqualTo: true)
//             .orderBy('popularityScore', descending: true)
//             .limit(n)
//             .getDocuments())
//         .documents
//         .map((doc) => User.fromDoc(doc))
//         .toList();
//   }

//   static Future<List<Suggestion>> getUserSuggestions(String uid) async {
//     // get list of users you were suggested to

//     return Future.wait<Suggestion>((await userSuggestionsRef
//             .document(uid)
//             .collection('suggestions')
//             .getDocuments())
//         .documents
//         .map((doc) async => Suggestion(
//               user: await getUser(doc.documentID),
//               liked: doc.data['liked'],
//             )));
//   }

//   static Future<void> clearUserSuggestions(String uid) async {
//     return Future.wait((await userSuggestionsRef
//             .document(uid)
//             .collection('suggestions')
//             .getDocuments())
//         .documents
//         .map((doc) => doc.reference.delete()));
//   }

//   static Future<void> createAccount(RegistrationInfo info) async {
//     final profileImageUrl = await StorageService.uploadMedia(
//       uid: info.uid,
//       media: info.profilePic,
//       prefix: 'profile_image',
//     );

//     final extraMediaMaps = await Future.wait(
//       info.extraMedia.map<Future<Map<String, dynamic>>>(
//         (media) async => media == null
//             ? null
//             : {
//                 'type': MediaType.values.indexOf(media.type),
//                 'url': await StorageService.uploadMedia(
//                   uid: info.uid,
//                   media: media,
//                   prefix: 'extra_media',
//                 ),
//               },
//       ),
//     );

//     final age = DateTime.now().difference(info.birthday).inDays ~/ 365;

//     await usersPrivateInfoRef.document(info.uid).setData({});

//     await userSuggestionsGoneThroughRef
//         .document(info.uid)
//         .setData({'suggestionsGoneThrough': []});
//   }

//   static Future<void> deleteAccount(String uid) {
//     return Future.wait([
//       usersPrivateInfoRef.document(uid).delete(),
//       userChatsRef.document(uid).delete(),
//       userBlockedRef.document(uid).delete(),
//       userFiltersRef.document(uid).delete(),
//       userMatchesRef.document(uid).delete(),
//       userSuggestionsRef.document(uid).delete(),
//       userUnknownChatsRef.document(uid).delete(),
//       userSuggestionsGoneThroughRef.document(uid).delete(),
//     ]);
//   }

//   static Future<List<User>> searchForUsers(
//       String partialUsername, int n) async {
//     final users = <User>[];
//     final uids = <String>[];
//     ((await usersPrivateInfoRef
//                     .where('username',
//                         isGreaterThanOrEqualTo: partialUsername.toLowerCase())
//                     .limit(n ~/ 2)
//                     .getDocuments())
//                 .documents +
//             (await usersPrivateInfoRef
//                     .where('username',
//                         isGreaterThanOrEqualTo: partialUsername.toUpperCase())
//                     .limit(n ~/ 2)
//                     .getDocuments())
//                 .documents)
//         .forEach((userDoc) {
//       if (userDoc.data['username']
//               .toLowerCase()
//               .startsWith(partialUsername.toLowerCase()) &&
//           !uids.contains(userDoc.data['uid'])) {
//         users.add(User.fromDoc(userDoc));
//         uids.add(userDoc.data['uid']);
//       }
//     });
//     return users;
//   }

//   static Future<bool> blocked(String fromUid, String toUid) async {
//     return (await userBlockedRef
//             .document(fromUid)
//             .collection('blocked')
//             .document(toUid)
//             .get())
//         .exists;
//   }

//   static Future<List<String>> getUserBlockedUids(String uid) async {
//     return (await userBlockedRef
//             .document(uid)
//             .collection('blocked')
//             .getDocuments())
//         .documents
//         .map((blockedDoc) => blockedDoc.documentID)
//         .toList();
//   }

//   static Future<String> sendMessage({
//     String chatId,
//     String fromUid,
//     String toUid,
//     DateTime sentTimestamp,
//     String referencedMessageId = '',
//     String text,
//     MediaType mediaType,
//     String mediaUrl,
//   }) async {
//     return (await chatsRef.document(chatId).collection('messages').add({
//       'senderUid': fromUid,
//       'sentTimestamp': Timestamp.fromDate(sentTimestamp),
//       'readTimestamp': null,
//       'referencedMessageId': referencedMessageId,
//       'text': text,
//       'mediaType':
//           mediaType == null ? null : MediaType.values.indexOf(mediaType),
//       'mediaUrl': mediaUrl,
//     }))
//         .documentID;
//   }

//   static Future<void> blockUser(String uid, String otherUid) {
//     return userBlockedRef
//         .document(uid)
//         .collection('blocked')
//         .document(otherUid)
//         .setData({});
//   }

//   static Future<void> unblockUser(String uid, String otherUid) {
//     return userBlockedRef
//         .document(uid)
//         .collection('blocked')
//         .document(otherUid)
//         .delete();
//   }

//   static Future<void> deleteMessage({
//     String chatId,
//     String messageId,
//   }) async {
//     return chatsRef
//         .document(chatId)
//         .collection('messages')
//         .document(messageId)
//         .delete();
//   }

//   static Future<void> sendSuggestion({
//     String fromUid,
//     String toUid,
//     bool liked,
//     double similarityScore,
//   }) {
//     return userSuggestionsRef
//         .document(toUid)
//         .collection('suggestions')
//         .document(fromUid)
//         .setData({
//       'liked': liked,
//       'similarityScore': similarityScore,
//     });
//   }

//   static Stream<QuerySnapshot> messagesStream(String chatId, int n) {
//     // stream of last n messages
//     return chatsRef
//         .document(chatId)
//         .collection('messages')
//         .orderBy('sentTimestamp', descending: true)
//         .limit(n)
//         .snapshots();
//   }

//   static Future<Message> getMessage(String chatId, String messageId) async {
//     return Message.fromDoc(await chatsRef
//         .document(chatId)
//         .collection('messages')
//         .document(messageId)
//         .get());
//   }

//   static Future<List<Chat>> getUnknownChats(String uid) async {
//     return (await userUnknownChatsRef
//             .document(uid)
//             .collection('unknownchats')
//             .getDocuments())
//         .documents
//         .map((chatDoc) => Chat(
//               id: chatDoc.documentID,
//               uid: chatDoc.data['uid'],
//             ))
//         .toList();
//   }

//   static Future<List<Chat>> getChatsOfType(
//       String uid, ChatType chatType) async {
//     return (await userChatsRef
//             .document(uid)
//             .collection('chats')
//             .where(
//               'type',
//               isEqualTo: ChatType.values.indexOf(chatType),
//             )
//             .getDocuments())
//         .documents
//         .map((chatDoc) => Chat.fromDoc(chatDoc))
//         .toList();
//   }

//   static Future<String> startConversation(String uid, String otherUid) async {
//     final chatId = await addNormalChat(uid, otherUid);
//     await userUnknownChatsRef
//         .document(otherUid)
//         .collection('unknownchats')
//         .document(chatId)
//         .setData({});
//     return chatId;
//   }

//   static Future<void> deleteChat(String uid, String chatId) async {
//     await chatsRef
//         .document(chatId)
//         .collection('participants')
//         .document(uid)
//         .delete();
//     if ((await chatsRef
//             .document(chatId)
//             .collection('participants')
//             .limit(1)
//             .getDocuments())
//         .documents
//         .isEmpty) {
//       // FIXME: do I have to delete all the chat messages first?
//       await chatsRef.document(chatId).delete();
//     }
//     await userChatsRef
//         .document(uid)
//         .collection('chats')
//         .document(chatId)
//         .delete();
//   }

//   static Future<bool> chatExists(String uid, String otherUid) async {
//     return (await userChatsRef
//             .document(uid)
//             .collection('chats')
//             .where('uid', isEqualTo: otherUid)
//             .limit(1)
//             .getDocuments())
//         .documents
//         .isNotEmpty;
//   }

//   static Future<Chat> getChatFromUid(String uid, String otherUid) async {
//     final chatDocs = (await userChatsRef
//             .document(uid)
//             .collection('chats')
//             .where('uid', isEqualTo: otherUid)
//             .getDocuments())
//         .documents;
//     if (chatDocs.isEmpty) {
//       return Chat(
//         id: '',
//         uid: otherUid,
//         wallpaperUrl: '',
//         lastReadTimestamp: null,
//         type: ChatType.nonExistent,
//       );
//     }
//     assert(chatDocs.length == 1, 'multiple chats with the same uid');
//     return Chat.fromDoc(chatDocs.first);
//   }

//   static Future<bool> noChats(String uid) async {
//     return (await userChatsRef
//             .document(uid)
//             .collection('chats')
//             .limit(1)
//             .getDocuments())
//         .documents
//         .isEmpty;
//   }

//   static Future<void> deleteSuggestion({
//     String uid,
//     String otherUid,
//   }) {
//     return userSuggestionsRef
//         .document(uid)
//         .collection('suggestions')
//         .document(otherUid)
//         .delete();
//   }

//   static Future<void> setChatWallpaper(
//     String uid,
//     String chatId,
//     String wallpaperUrl,
//   ) {
//     return userChatsRef
//         .document(uid)
//         .collection('chats')
//         .document(chatId)
//         .updateData({'wallpaperUrl': wallpaperUrl});
//   }

//   static Future<int> updateChatDetails(
//       {String uid, String chatId, Map<String, dynamic> details}) {
//     return userChatsRef
//         .document(uid)
//         .collection('chats')
//         .document(chatId)
//         .updateData(details);
//   }

//   static Future<void> setChatLastRead(String uid, String chatId) {
//     return userChatsRef
//         .document(uid)
//         .collection('chats')
//         .document(chatId)
//         .updateData({'lastReadTimestamp': Timestamp.now()});
//   }

//   static Future<Chat> getChat(String uid, String chatId) async {
//     return Chat.fromDoc(await userChatsRef
//         .document(uid)
//         .collection('chats')
//         .document(chatId)
//         .get());
//   }

//   static Future<Chat> findChat(String uid, String otherUid) async {
//     final chatsSnap = await userChatsRef
//         .document(uid)
//         .collection('chats')
//         .where('uid', isEqualTo: otherUid)
//         .limit(1)
//         .getDocuments();
//     return chatsSnap.documents.isEmpty
//         ? Chat(
//             id: null,
//             uid: otherUid,
//             wallpaperUrl: '',
//             lastReadTimestamp: null,
//             type: ChatType.nonExistent,
//           )
//         : Chat.fromDoc(chatsSnap.documents.first);
//   }

//   static Future<void> updateChatMessagesRead(
//       String chatId, String otherUid) async {
//     return Future.wait((await chatsRef
//             .document(chatId)
//             .collection('messages')
//             .where('senderUid', isEqualTo: otherUid)
//             .where('readTimestamp', isNull: true)
//             .getDocuments())
//         .documents
//         .map((doc) =>
//             doc.reference.updateData({'readTimestamp': Timestamp.now()})));
//   }

//   static Future<List<String>> getMatches(String uid) async {
//     return (await userMatchesRef
//             .document(uid)
//             .collection('matches')
//             .getDocuments())
//         .documents
//         .map((doc) => doc.documentID)
//         .toList();
//   }

//   static Future<void> saveNewSuggestions(
//       String uid, List<Suggestion> newSuggestions) {
//     return Future.wait(newSuggestions.map((suggestion) => userSuggestionsRef
//         .document(uid)
//         .collection('suggestions')
//         .document(suggestion.user.uid)
//         .setData(suggestion.toMap())));
//   }

//   static Future<void> match(String uid, String otherUid) {
//     return Future.wait([
//       userMatchesRef
//           .document(uid)
//           .collection('matches')
//           .document(otherUid)
//           .setData({}),
//       userMatchesRef
//           .document(otherUid)
//           .collection('matches')
//           .document(uid)
//           .setData({}),
//     ]);
//   }

//   static Future<String> addNormalChat(String uid, String otherUid) async {
//     final chatId = (await userChatsRef.document(uid).collection('chats').add({
//       'uid': otherUid,
//       'wallpaperUrl': '',
//       'lastReadTimestamp': Timestamp.now(),
//       'type': 1,
//     }))
//         .documentID;
//     // FIXME: FUTURE: or store in a list?
//     await chatsRef
//         .document(chatId)
//         .collection('participants')
//         .document(uid)
//         .setData({});
//     await chatsRef
//         .document(chatId)
//         .collection('participants')
//         .document(otherUid)
//         .setData({});
//     return chatId;
//   }

//   static Future<void> removeUnknownChat(String uid, String chatId) {
//     return userUnknownChatsRef
//         .document(uid)
//         .collection('unknownchats')
//         .document(chatId)
//         .delete();
//   }

//   static Future<void> removeMatch(String uid, String otherUid) {
//     return userMatchesRef
//         .document(uid)
//         .collection('matches')
//         .document(otherUid)
//         .delete();
//   }

//   static Future<void> saveToken(String uid, String token) {
//     return usersPrivateInfoRef
//         .document(uid)
//         .collection('tokens')
//         .document(token)
//         .setData({
//       'timestamp': Timestamp.now(),
//       'platform': Platform.operatingSystem,
//     });
//   }

//   static Future<void> removeToken(String uid, String token) {
//     return usersPrivateInfoRef
//         .document(uid)
//         .collection('tokens')
//         .document(token)
//         .delete();
//   }

//   static Future<List<SuggestionGoneThrough>> getUserSuggestionsGoneThrough(
//       String uid) async {
//     return List<SuggestionGoneThrough>.from((await userSuggestionsGoneThroughRef
//             .document(uid)
//             .get())
//         .data['suggestionsGoneThrough']
//         .map((suggestionMap) => SuggestionGoneThrough.fromMap(suggestionMap)));
//   }

//   static Future<void> addUserSuggestionsGoneThrough(
//       String uid, List<SuggestionGoneThrough> suggestionsGoneThrough) {
//     return userSuggestionsGoneThroughRef.document(uid).updateData({
//       'suggestionsGoneThrough': FieldValue.arrayUnion(suggestionsGoneThrough
//           .map((goneThrough) => goneThrough.toMap())
//           .toList())
//     });
//   }

//   static Future<void> undoSentSuggestion(
//       String userId, String suggestionUserUid) {
//     return userSuggestionsRef
//         .document(suggestionUserUid)
//         .collection('suggestions')
//         .document(userId)
//         .delete();
//   }
// }
