import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance.ref();

final userProfilesRef = FirebaseFirestore.instance.collection(
    'user_profiles'); // contains publicly available information about a user
final usersPrivateInfoRef = FirebaseFirestore.instance
    .collection('users_private_info'); // does not overlap with user_profiles
final usersAlgorithmDataRef =
    FirebaseFirestore.instance.collection('users_algorithm_data');
final userStatusesRef = FirebaseFirestore.instance.collection(
    'user_statuses'); // whether the user is online or not, & last seen. This shall be listened to.
final chatsRef = FirebaseFirestore.instance.collection('chats');
