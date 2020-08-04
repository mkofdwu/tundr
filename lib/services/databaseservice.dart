import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/personalinfofield.dart';
import 'package:tundr/models/suggestiongonethrough.dart';
import 'package:tundr/utils/constants/deleteduser.dart';
import 'package:tundr/utils/constants/enums/chattype.dart';
import 'package:tundr/utils/constants/enums/filtermethod.dart';
import "package:tundr/utils/constants/enums/gender.dart";
import 'package:tundr/models/registrationinfo.dart';
import 'package:tundr/models/suggestion.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/services/storageservice.dart';
import 'package:tundr/utils/constants/enums/mediatype.dart';
import 'package:tundr/utils/constants/enums/personalinfotype.dart';
import "package:tundr/utils/algorithms/similarityscore.dart";
import "package:tundr/utils/constants/firebaseref.dart";
import 'package:tundr/utils/constants/personalinfofields.dart';

class DatabaseService {
  static Future<bool> usernameAlreadyExists(String username) async {
    return (await usersRef
            .where("username", isEqualTo: username)
            .limit(1)
            .getDocuments())
        .documents
        .isNotEmpty;
  }

  static Future<Map<String, dynamic>> getUserMap(String uid) async {
    final DocumentSnapshot userDoc = await usersRef.document(uid).get();
    return userDoc.exists ? userDoc.data : deletedUserMap;
  }

  static Future<dynamic> getUserField(String uid, String field) async {
    return (await getUserMap(uid))[field];
  }

  static Future<User> getUser(
    String uid, {
    bool returnDeletedUser = true,
  }) async {
    final DocumentSnapshot userDoc = await usersRef.document(uid).get();
    return userDoc.exists
        ? User.fromDoc(userDoc)
        : (returnDeletedUser ? deletedUser : null);
  }

  static Future<bool> phoneNumberExists(String phoneNumber) async {
    return (await usersRef
            .where("phoneNumber", isEqualTo: phoneNumber)
            .limit(1)
            .getDocuments())
        .documents
        .isNotEmpty;
  }

  static Future<void> setUserField(String uid, String field, dynamic value) {
    return usersRef.document(uid).updateData({field: value});
  }

  static Future<void> setUserFields(String uid, Map<String, dynamic> fields) {
    return usersRef.document(uid).updateData(fields);
  }

  static Future<dynamic> getUserFilter(String uid, String filter) async {
    return (await userFiltersRef.document(uid).get()).data[filter];
  }

  static Future<DocumentSnapshot> getUserFiltersDoc(String uid) {
    return userFiltersRef.document(uid).get();
  }

  static Future<List<Filter>> getUserFilters(String uid) async {
    final filtersDoc = (await userFiltersRef.document(uid).get());
    if (!filtersDoc.exists) return [];

    List<Filter> filters = [];
    filtersDoc.data.forEach(
      (name, value) async {
        if (["ageRangeMin", "ageRangeMax", "showMeBoys", "showMeGirls"]
            .contains(name)) {
          // backwards compatibility
          return;
        }
        filters.add(Filter(
          field: PersonalInfoField.fromMap(name, personalInfoFields[name]),
          options: value["options"],
          method: FilterMethod.values.elementAt(value["method"]),
        ));
      },
    );
    return filters;
  }

  static Future<void> setUserFilter({
    String uid,
    Filter filter,
  }) {
    return userFiltersRef.document(uid).updateData({
      filter.field.name: {
        "options": filter.options,
        "method": FilterMethod.values.indexOf(filter.method),
      }
    });
  }

  // most popular page

  static Future<List<User>> getMostPopular(int n) async {
    return (await usersRef
            .where("showInMostPopular", isEqualTo: true)
            .orderBy("popularityScore", descending: true)
            .limit(n)
            .getDocuments())
        .documents
        .map((doc) => User.fromDoc(doc))
        .toList();
  }

  static Future<List<Suggestion>> getUserSuggestions(String uid) async {
    // get list of users you were suggested to
    print("getting user suggestions for $uid");
    return Future.wait<Suggestion>((await userSuggestionsRef
            .document(uid)
            .collection("suggestions")
            .getDocuments())
        .documents
        .map((doc) async => Suggestion(
              user: await getUser(doc.documentID),
              liked: doc.data["liked"],
              similarityScore: doc.data["similarityScore"],
            )));
  }

  static Future<void> clearUserSuggestions(String uid) async {
    return Future.wait((await userSuggestionsRef
            .document(uid)
            .collection("suggestions")
            .getDocuments())
        .documents
        .map((doc) => doc.reference.delete()));
  }

  static Future<void> createAccount(RegistrationInfo info) async {
    print("creating account");
    String profileImageUrl = "";
    // String profileImageUrl = await StorageService.uploadMedia(
    //   uid: info.uid,
    //   media: info.profilePic,
    //   prefix: "profile_image",
    // );
    print("uploaded profile pic");
    List<Map<String, dynamic>> extraMediaMaps = await Future.wait(
      info.extraMedia.map<Future<Map<String, dynamic>>>(
        (media) async => media == null
            ? null
            : {
                "type": MediaType.values.indexOf(media.type),
                "url": await StorageService.uploadMedia(
                  uid: info.uid,
                  media: media,
                  prefix: "extra_media",
                ),
              },
      ),
    );
    print("upload extra media");

    final int age = DateTime.now().difference(info.birthday).inDays ~/ 365;

    // FIXME: Future.wait() ?
    await usersRef.document(info.uid).setData({
      "phoneNumber": info.phoneNumber,
      "username": info.username,
      "name": info.name,
      "gender": Gender.values.indexOf(info.gender),
      "profileImageUrl": profileImageUrl,
      "aboutMe": info.aboutMe,
      "birthday": Timestamp.fromDate(info.birthday),
      "interests": info.interests,
      "extraMedia": extraMediaMaps,
      "verified": false,
      "asleep": false,
      "online": true,
      "lastSeen": null,
      // scores
      "popularityScore": 100,
      "conversationalScore": 0,
      "blockedScore": 0,
      // filters
      "showMeBoys": info.gender == Gender.female,
      "showMeGirls": info.gender == Gender.male,
      "ageRangeMin": age - 1,
      "ageRangeMax": age + 1,
      // personal info
      ...info.personalInfo,
      // preferences
      "newMatchNotification": true,
      "messageNotification": true,
      "blockUnknownMessages": false,
      "readReceipts": true,
      "showInMostPopular": true,
      "popularityHistory": {},
      "totalWordsSent": 0,
      "theme": null,
      "lastGeneratedSuggestionsTimestamp": 0,
      "numRightSwiped": 0,
    });
    print("done with setData");
    await userSuggestionsGoneThroughRef
        .document(info.uid)
        .setData({"suggestionsGoneThrough": []});
    print("done creating account");
  }

  static Future<void> deleteAccount(String uid) {
    return Future.wait([
      usersRef.document(uid).delete(),
      userChatsRef.document(uid).delete(),
      userBlockedRef.document(uid).delete(),
      userFiltersRef.document(uid).delete(),
      userMatchesRef.document(uid).delete(),
      userSuggestionsRef.document(uid).delete(),
      userUnknownChatsRef.document(uid).delete(),
      userSuggestionsGoneThroughRef.document(uid).delete(),
    ]);
  }

  static Query secondaryFilterUsers(dynamic users, Filter filter) {
    // users: either DocumentReference (usersRef) or Query
    print(
        "filtering with: ${filter.field.name}, type ${filter.field.type}, options ${filter.field.options}");
    if (filter.options == null) return users;
    switch (filter.field.type) {
      case PersonalInfoType.numInput:
      case PersonalInfoType.slider:
        return users.where(
          filter.field.name,
          isGreaterThanOrEqualTo: filter.options.first,
          isLessThanOrEqualTo: filter.options.last,
        );
      case PersonalInfoType.radioGroup:
      case PersonalInfoType.textInput:
        return users.where(filter.field.name, whereIn: filter.options);
      case PersonalInfoType.textList:
        switch (filter.method) {
          case FilterMethod.none:
            return users;
          case FilterMethod.ifContainsAll:
            return users.where(
              filter.field.name,
              arrayContains: filter.options,
            );
          case FilterMethod.ifContainsAny:
            return users.where(
              filter.field.name,
              arrayContainsAny: filter.options,
            );
          // case FilterMethod.ifDoesNotContainAll:
          // //   return users.where(
          // //     filter.field.name,
          // //     !arrayContains: filter.options,
          // //   );
          // case FilterMethod.ifDoesNotContainAny:
          //   //   return users.where(
          //   //     filter.field.name,
          //   //     !arrayContainsAny: filter.options,
          //   //   );
          default:
            throw Exception("Invalid filter method: ${filter.method}");
        }
        break;
      default:
        throw Exception("Invalid personal info type: ${filter.method}");
    }
  }

  static Future<bool> otherUserFiltersAllow(
      User currentUser, User otherUser) async {
    // final Map<String, dynamic> otherUserFilters =
    //     (await userFiltersRef.document(otherUid).get()).data;
    if (currentUser.gender == Gender.male && !otherUser.showMeBoys) {
      print("1a");
      return false;
    }
    if (currentUser.gender == Gender.female && !otherUser.showMeGirls) {
      print("1b");
      return false;
    }
    if (currentUser.ageInYears > otherUser.ageRangeMax ||
        otherUser.ageRangeMin > currentUser.ageInYears) {
      print("1c");
      return false;
    }
    return true;
  }

  static Future<Query> filterUsers({
    User currentUser,
  }) async {
    // final now = DateTime.now();
    Query usersQuery = usersRef.where("asleep", isEqualTo: false).where(
      "gender",
      whereIn: [
        if (currentUser.showMeBoys) 0,
        if (currentUser.showMeGirls) 1,
      ],
    );
    // .where(
    //   "birthday",
    //   isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
    //     now.year - currentUser.ageRangeMax,
    //     now.month,
    //     now.day,
    //   )),
    //   isLessThanOrEqualTo: Timestamp.fromDate(DateTime(
    //     now.year - currentUser.ageRangeMin,
    //     now.month,
    //     now.day,
    //   )),
    // )
    print("secondary filters for users");
    (await getUserFilters(currentUser.uid)).map((filter) {
      print("filter: ${filter.field.name}");
      usersQuery = secondaryFilterUsers(usersQuery, filter);
    });
    return usersQuery;
  }

  static Future<List<Suggestion>> generateSuggestions({
    User currentUser,
    int n,
    List<String> storedSuggestionUids,
    List<SuggestionGoneThrough> suggestionsGoneThrough,
  }) async {
    final Query usersQuery = await filterUsers(currentUser: currentUser);

    final Query orderedByPopScoreHalf = usersQuery
        .orderBy("popularityScore")
        .limit(n); // increased to n, since some users will be filtered
    final List<DocumentSnapshot> orderedByPopScoreDocs =
        (await orderedByPopScoreHalf.getDocuments()).documents +
            (await orderedByPopScoreHalf
                    .startAt([currentUser.popularityScore]).getDocuments())
                .documents;

    final Query orderedByConvScoreHalf =
        usersQuery.orderBy("conversationalScore").limit(n);
    final List<DocumentSnapshot> orderedByConvScoreDocs =
        (await orderedByConvScoreHalf
                    .endAt([currentUser.conversationalScore]).getDocuments())
                .documents +
            (await orderedByConvScoreHalf
                    .startAt([currentUser.conversationalScore]).getDocuments())
                .documents;

    final List<String> suggestionUids = [];
    final List<Suggestion> newSuggestions = [];

    final List<String> uidsGoneThrough = storedSuggestionUids +
        suggestionsGoneThrough.map((suggestion) => suggestion.uid).toList();

    final now = DateTime.now();

    (orderedByPopScoreDocs + orderedByConvScoreDocs).forEach((doc) {
      if (suggestionUids.contains(doc.documentID) ||
          uidsGoneThrough.contains(doc.documentID) ||
          doc.documentID == currentUser.uid) return;

      final DateTime birthday = doc.data["birthday"].toDate();

      if (birthday.isBefore(DateTime(
            now.year - currentUser.ageRangeMax,
            now.month,
            now.day,
          )) ||
          birthday.isAfter(DateTime(
            now.year - currentUser.ageRangeMin,
            now.month,
            now.day,
          ))) return;

      suggestionUids.add(doc.documentID);

      final User user = User.fromDoc(doc);
      print(
          "generated similarity score for ${user.name}: ${userSimilarity(currentUser, user)}");
      newSuggestions.add(Suggestion(
        user: user,
        liked: null,
        similarityScore: userSimilarity(currentUser, user),
      ));
    });

    print("generated ${newSuggestions.length} suggestions");

    newSuggestions.sort((suggestion1, suggestion2) => suggestion2
        .similarityScore
        .compareTo(suggestion1.similarityScore)); // sort descending

    return newSuggestions.sublist(0, min(n, newSuggestions.length));
  }

  static Future<List<User>> searchForUsers(
      String partialUsername, int n) async {
    final List<User> users = [];
    final List<String> uids = [];
    ((await usersRef
                    .where("username",
                        isGreaterThanOrEqualTo: partialUsername.toLowerCase())
                    .limit(n ~/ 2)
                    .getDocuments())
                .documents +
            (await usersRef
                    .where("username",
                        isGreaterThanOrEqualTo: partialUsername.toUpperCase())
                    .limit(n ~/ 2)
                    .getDocuments())
                .documents)
        .forEach((userDoc) {
      if (userDoc.data["username"]
              .toLowerCase()
              .startsWith(partialUsername.toLowerCase()) &&
          !uids.contains(userDoc.data["uid"])) {
        users.add(User.fromDoc(userDoc));
        uids.add(userDoc.data["uid"]);
      }
    });
    return users;
  }

  static Future<bool> blocked(String fromUid, String toUid) async {
    return (await userBlockedRef
            .document(fromUid)
            .collection("blocked")
            .document(toUid)
            .get())
        .exists;
  }

  static Future<List<String>> getUserBlockedUids(String uid) async {
    return (await userBlockedRef
            .document(uid)
            .collection("blocked")
            .getDocuments())
        .documents
        .map((blockedDoc) => blockedDoc.documentID)
        .toList();
  }

  // static Future<Map<String, dynamic>> getUserPersonalInfo(String uid) async {
  //   return (await userPersonalInfoRef.document(uid).get()).data;
  // }

  static Future<String> sendMessage({
    String chatId,
    String fromUid,
    String toUid,
    DateTime sentTimestamp,
    String referencedMessageId = "",
    String text,
    MediaType mediaType,
    String mediaUrl,
  }) async {
    return (await chatsRef.document(chatId).collection("messages").add({
      "senderUid": fromUid,
      "sentTimestamp": Timestamp.fromDate(sentTimestamp),
      "readTimestamp": null,
      "referencedMessageId": referencedMessageId,
      "text": text,
      "mediaType":
          mediaType == null ? null : MediaType.values.indexOf(mediaType),
      "mediaUrl": mediaUrl,
    }))
        .documentID;
  }

  static Future<void> blockUser(String uid, String otherUid) {
    return userBlockedRef
        .document(uid)
        .collection("blocked")
        .document(otherUid)
        .setData({});
  }

  static Future<void> unblockUser(String uid, String otherUid) {
    return userBlockedRef
        .document(uid)
        .collection("blocked")
        .document(otherUid)
        .delete();
  }

  // static Future<void> saveNewMessages({
  //   String uid,
  //   Function(Message) saveMessage,
  //   Function(String) addChatIfDoesNotExistElseSetUpdated,
  // }) async {
  //   Future.wait((await userMessagesRef
  //           .document(uid)
  //           .collection("messages")
  //           .getDocuments())
  //       .documents
  //       .map((doc) async {
  //     if (!(await blocked(uid, doc.data["uid"]))) {
  //       saveMessage(Message(
  //         id: doc.documentID,
  //         senderUid: doc.data["senderUid"],
  //         readTimestamp: null,
  //         sentTimestamp: doc.data["timestamp"].toDate(),
  //         referencedMessageId: doc.data["referencedMessageId"],
  //         text: doc.data["text"],
  //         mediaType: doc.data["mediaType"] == null
  //             ? null
  //             : MediaType.values.elementAt(doc.data["mediaType"]),
  //         mediaUrl: doc.data["mediaUrl"],
  //       ));
  //       addChatIfDoesNotExistElseSetUpdated(doc.data["uid"]);
  //     }
  //     doc.reference.delete();
  //   }));
  // }

  // static Future<Message> retrieveMessage(String uid, String messageId) async {
  //   final DocumentSnapshot doc = await userMessagesRef
  //       .document(uid)
  //       .collection("messages")
  //       .document(messageId)
  //       .get();
  //   return Message(
  //     id: doc.documentID,
  //     senderUid: doc.data["senderUid"],
  //     readTimestamp: null,
  //     sentTimestamp: doc.data["timestamp"].toDate(),
  //     referencedMessageId: doc.data["referencedMessageId"],
  //     text: doc.data["text"],
  //     mediaType: doc.data["mediaType"] == null
  //         ? null
  //         : MediaType.values.elementAt(doc.data["mediaType"]),
  //     mediaUrl: doc.data["mediaUrl"],
  //   );
  // }

  // static Future<void> clearMessage(String uid, String messageId) {
  //   // clear message after retrieving to save space
  //   return userMessagesRef
  //       .document(uid)
  //       .collection("messages")
  //       .document(messageId)
  //       .delete();
  // }

  static Future<void> deleteMessage({
    String chatId,
    String messageId,
  }) async {
    return chatsRef
        .document(chatId)
        .collection("messages")
        .document(messageId)
        .delete();
  }

  static Future<void> sendSuggestion({
    String fromUid,
    String toUid,
    bool liked,
    double similarityScore,
  }) {
    return userSuggestionsRef
        .document(toUid)
        .collection("suggestions")
        .document(fromUid)
        .setData({
      "liked": liked,
      "similarityScore": similarityScore,
    });
  }

  // static Future<void> goThroughUser(
  //   String uid,
  //   String otherUserUid,
  //   bool liked,
  // ) {
  //   return userGoneThroughRef
  //       .document(uid)
  //       .collection("gonethrough")
  //       .document(otherUserUid)
  //       .setData({"liked": liked});
  // }

  static Stream<QuerySnapshot> messagesStream(String chatId, int n) {
    // stream of last n messages
    return chatsRef
        .document(chatId)
        .collection("messages")
        .orderBy("sentTimestamp", descending: true)
        .limit(n)
        .snapshots();
  }

  static Future<Message> getMessage(String chatId, String messageId) async {
    return Message.fromDoc(await chatsRef
        .document(chatId)
        .collection("messages")
        .document(messageId)
        .get());
  }

  static Future<List<Chat>> getUnknownChats(String uid) async {
    return (await userUnknownChatsRef
            .document(uid)
            .collection("unknownchats")
            .getDocuments())
        .documents
        .map((chatDoc) => Chat(
              id: chatDoc.documentID,
              uid: chatDoc.data["uid"],
            ))
        .toList();
  }

  static Future<List<Chat>> getChatsOfType(
      String uid, ChatType chatType) async {
    return (await userChatsRef
            .document(uid)
            .collection("chats")
            .where(
              "type",
              isEqualTo: ChatType.values.indexOf(chatType),
            )
            .getDocuments())
        .documents
        .map((chatDoc) => Chat.fromDoc(chatDoc))
        .toList();
  }

  static Future<String> startConversation(String uid, String otherUid) async {
    final String chatId = await addNormalChat(uid, otherUid);
    userUnknownChatsRef
        .document(otherUid)
        .collection("unknownchats")
        .document(chatId)
        .setData({});
    return chatId;
  }

  static Future<void> deleteChat(String uid, String chatId) async {
    await chatsRef
        .document(chatId)
        .collection("participants")
        .document(uid)
        .delete();
    if ((await chatsRef
            .document(chatId)
            .collection("participants")
            .limit(1)
            .getDocuments())
        .documents
        .isEmpty) {
      // FIXME: do I have to delete all the chat messages first?
      await chatsRef.document(chatId).delete();
    }
    await userChatsRef
        .document(uid)
        .collection("chats")
        .document(chatId)
        .delete();
  }

  static Future<bool> chatExists(String uid, String otherUid) async {
    return (await userChatsRef
            .document(uid)
            .collection("chats")
            .where("uid", isEqualTo: otherUid)
            .limit(1)
            .getDocuments())
        .documents
        .isNotEmpty;
  }

  static Future<Chat> getChatFromUid(String uid, String otherUid) async {
    final List<DocumentSnapshot> chatDocs = (await userChatsRef
            .document(uid)
            .collection("chats")
            .where("uid", isEqualTo: otherUid)
            .getDocuments())
        .documents;
    if (chatDocs.isEmpty)
      return Chat(
        id: "",
        uid: otherUid,
        wallpaperUrl: "",
        lastReadTimestamp: null,
        type: ChatType.nonExistent,
      );
    assert(chatDocs.length == 1, "multiple chats with the same uid");
    return Chat.fromDoc(chatDocs.first);
  }

  static Future<bool> noChats(String uid) async {
    return (await userChatsRef
            .document(uid)
            .collection("chats")
            .limit(1)
            .getDocuments())
        .documents
        .isEmpty;
  }

  // static Future<void> swipeUser(
  //     String uid, String otherUid, bool liked, double similarityScore) async {
  //   return Future.wait([
  //     userSuggestionsRef
  //         .document(uid)
  //         .collection("suggestions")
  //         .document(otherUid)
  //         .delete(),
  //     userGoneThroughRef
  //         .document(uid)
  //         .collection("gonethrough")
  //         .document(otherUid)
  //         .setData({"liked": liked, "similarityScore": similarityScore}),
  //   ]);
  // }

  static Future<void> deleteSuggestion({
    String uid,
    String otherUid,
  }) {
    return userSuggestionsRef
        .document(uid)
        .collection("suggestions")
        .document(otherUid)
        .delete();
  }

  static Future<void> setChatWallpaper(
    String uid,
    String chatId,
    String wallpaperUrl,
  ) {
    return userChatsRef
        .document(uid)
        .collection("chats")
        .document(chatId)
        .updateData({"wallpaperUrl": wallpaperUrl});
  }

  // static Future<int> getTotalWordsSent() async {
  //   int totalWordsSent = 0;
  //   (await _database.query("messages")).forEach((row) {
  //     totalWordsSent += row["text"].split(RegExp("\s")).length;
  //   });
  //   return totalWordsSent;
  // }

  static Future<int> updateChatDetails(
      {String uid, String chatId, Map<String, dynamic> details}) {
    return userChatsRef
        .document(uid)
        .collection("chats")
        .document(chatId)
        .updateData(details);
  }

  static Future<void> setChatLastRead(String uid, String chatId) {
    return userChatsRef
        .document(uid)
        .collection("chats")
        .document(chatId)
        .updateData({"lastReadTimestamp": Timestamp.now()});
  }

  static Future<Chat> getChat(String uid, String chatId) async {
    return Chat.fromDoc(await userChatsRef
        .document(uid)
        .collection("chats")
        .document(chatId)
        .get());
  }

  static Future<Chat> findChat(String uid, String otherUid) async {
    final QuerySnapshot chatsSnap = await userChatsRef
        .document(uid)
        .collection("chats")
        .where("uid", isEqualTo: otherUid)
        .limit(1)
        .getDocuments();
    return chatsSnap.documents.isEmpty
        ? Chat(
            id: null,
            uid: otherUid,
            wallpaperUrl: "",
            lastReadTimestamp: null,
            type: ChatType.nonExistent,
          )
        : Chat.fromDoc(chatsSnap.documents.first);
  }

  // static Future<int> setMessageRead(String chatId, String messageId) {
  //   return chatMessagesRef
  //       .document(chatId)
  //       .collection("messages")
  //       .document(messageId)
  //       .updateData({"readTimestamp": Timestamp.now()});
  // }

  static Future<void> updateChatMessagesRead(
      String chatId, String otherUid) async {
    return Future.wait((await chatsRef
            .document(chatId)
            .collection("messages")
            .where("senderUid", isEqualTo: otherUid)
            .where("readTimestamp", isNull: true)
            .getDocuments())
        .documents
        .map((doc) =>
            doc.reference.updateData({"readTimestamp": Timestamp.now()})));
  }

  static Future<List<String>> getMatches(String uid) async {
    return (await userMatchesRef
            .document(uid)
            .collection("matches")
            .getDocuments())
        .documents
        .map((doc) => doc.documentID)
        .toList();
  }

  static Future<void> saveNewSuggestions(
      String uid, List<Suggestion> newSuggestions) {
    return Future.wait(newSuggestions.map((suggestion) => userSuggestionsRef
        .document(uid)
        .collection("suggestions")
        .document(suggestion.user.uid)
        .setData(suggestion.toMap())));
  }

  static Future<void> match(String uid, String otherUid) {
    return Future.wait([
      userMatchesRef
          .document(uid)
          .collection("matches")
          .document(otherUid)
          .setData({}),
      userMatchesRef
          .document(otherUid)
          .collection("matches")
          .document(uid)
          .setData({}),
    ]);
  }

  static Future<String> addNormalChat(String uid, String otherUid) async {
    final String chatId =
        (await userChatsRef.document(uid).collection("chats").add({
      "uid": otherUid,
      "wallpaperUrl": "",
      "lastReadTimestamp": Timestamp.now(),
      "type": 1,
    }))
            .documentID;
    // FIXME: FUTURE: or store in a list?
    chatsRef
        .document(chatId)
        .collection("participants")
        .document(uid)
        .setData({});
    chatsRef
        .document(chatId)
        .collection("participants")
        .document(otherUid)
        .setData({});
    return chatId;
  }

  static Future<void> removeUnknownChat(String uid, String chatId) {
    return userUnknownChatsRef
        .document(uid)
        .collection("unknownchats")
        .document(chatId)
        .delete();
  }

  static Future<void> removeMatch(String uid, String otherUid) {
    return userMatchesRef
        .document(uid)
        .collection("matches")
        .document(otherUid)
        .delete();
  }

  static Future<void> saveToken(String uid, String token) {
    return usersRef.document(uid).collection("tokens").document(token).setData({
      "timestamp": Timestamp.now(),
      "platform": Platform.operatingSystem,
    });
  }

  static Future<void> removeToken(String uid, String token) {
    return usersRef.document(uid).collection("tokens").document(token).delete();
  }

  static Future<List<SuggestionGoneThrough>> getUserSuggestionsGoneThrough(
      String uid) async {
    return List<SuggestionGoneThrough>.from((await userSuggestionsGoneThroughRef
            .document(uid)
            .get())
        .data["suggestionsGoneThrough"]
        .map((suggestionMap) => SuggestionGoneThrough.fromMap(suggestionMap)));
  }

  static Future<void> addUserSuggestionsGoneThrough(
      String uid, List<SuggestionGoneThrough> suggestionsGoneThrough) {
    return userSuggestionsGoneThroughRef.document(uid).updateData({
      "suggestionsGoneThrough": FieldValue.arrayUnion(suggestionsGoneThrough
          .map((goneThrough) => goneThrough.toMap())
          .toList())
    });
  }
}
