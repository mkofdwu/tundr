import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance.ref();

final usersRef = Firestore.instance.collection('users');
final userFiltersRef = Firestore.instance.collection('userfilters');
final userSuggestionsRef = Firestore.instance.collection('usersuggestions');
final userBlockedRef = Firestore.instance.collection('userblocked');
final userChatsRef = Firestore.instance.collection('userchats');
final chatsRef = Firestore.instance.collection('chats');
final userMatchesRef = Firestore.instance.collection('usermatches');
final userUnknownChatsRef = Firestore.instance.collection('userunknownchats');
final userSuggestionsGoneThroughRef =
    Firestore.instance.collection('usersuggestionsgonethrough');
