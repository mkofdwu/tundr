import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/services/users_service.dart';

class Chat {
  String id;
  UserProfile otherProfile;
  String wallpaperUrl;
  String lastReadMessageId;
  ChatType type;

  Chat({
    this.id,
    this.otherProfile,
    this.wallpaperUrl,
    this.lastReadMessageId,
    this.type,
  });

  static Future<Chat> fromDoc(DocumentSnapshot doc) async {
    final data = doc.data();
    return Chat(
      id: doc.id,
      otherProfile: await UsersService.getUserProfile(data['uid']),
      wallpaperUrl: data['wallpaperUrl'],
      lastReadMessageId: data['lastReadMessageId'],
      type: ChatType.values[data['type']],
    );
  }
}
