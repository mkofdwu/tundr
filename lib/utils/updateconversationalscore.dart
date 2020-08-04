import 'package:firebase_auth/firebase_auth.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/services/databaseservice.dart';

void updateConversationalScore(User user) async {
  // save total words sent in user doc
  final Duration durationSinceCreated = DateTime.now().difference(
      (await FirebaseAuth.instance.currentUser()).metadata.creationTime);

  final double conversationalScore =
      user.totalWordsSent / durationSinceCreated.inSeconds;
  DatabaseService.setUserField(
    user.uid,
    "conversationalScore",
    conversationalScore,
  );
}
