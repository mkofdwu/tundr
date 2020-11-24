// import "package:cloud_firestore/cloud_firestore.dart";
// import "package:tundr/enums/mediatype.dart";

// import 'media.dart';

// class Message {
//   // String id;
//   // String uid;
//   // bool fromMe;
//   // DateTime readTimestamp;
//   // DateTime sentTimestamp;
//   // String referencedMessageId;
//   // String text;
//   // MediaType mediaType;
//   // String mediaUrl;
//   // bool readByMe;

//   // Message({
//   //   this.id,
//   //   this.uid,
//   //   this.fromMe,
//   //   this.readTimestamp,
//   //   this.sentTimestamp,
//   //   this.referencedMessageId,
//   //   this.text,
//   //   this.mediaType,
//   //   this.mediaUrl,
//   //   this.readByMe,
//   // });

//   String id;
//   String senderUid;
//   DateTime sentTimestamp;
//   DateTime readTimestamp;
//   String referencedMessageId;
//   String text;
//   Media media;

//   Message({
//     this.id,
//     this.senderUid,
//     this.sentTimestamp,
//     this.readTimestamp,
//     this.referencedMessageId,
//     this.text,
//     this.media,
//   });

//   factory Message.fromDoc(DocumentSnapshot doc) {
//     return Message(
//       id: doc.documentID,
//       senderUid: doc.data["senderUid"],
//       sentTimestamp: doc.data["sentTimestamp"].toDate(),
//       readTimestamp: doc.data["readTimestamp"].toDate(),
//       referencedMessageId: doc.data["referencedMessageId"],
//       text: doc.data["text"],
//       media: doc.data["mediaType"] == null
//           ? null
//           : Media(
//               type: MediaType.values.elementAt(doc.data["mediaType"]),
//               url: doc.data["mediaUrl"],
//             ),
//     );
//   }

//   // factory Message.fromMap(Map<String, dynamic> map) {
//   //
//   //   return Message(
//   //     id: map["id"],
//   //     uid: map["uid"],
//   //     fromMe: map["from_me"] == 1,
//   //     readTimestamp: map["read_timestamp"] == null
//   //         ? null
//   //         : DateTime.fromMillisecondsSinceEpoch(map["read_timestamp"]),
//   //     sentTimestamp: DateTime.fromMillisecondsSinceEpoch(map["sent_timestamp"]),
//   //     referencedMessageId: map["referenced_message_id"],
//   //     text: map["text"],
//   //     mediaType: map["media_type"] == null
//   //         ? null
//   //         : MediaType.values.elementAt(map["media_type"]),
//   //     mediaUrl: map["media_url"],
//   //     readByMe: map["read_by_me"] == 1,
//   //   );
//   // }

//   // Map<String, dynamic> toMap() {
//   //   return {
//   //     "id": id,
//   //     "uid": uid,
//   //     "from_me": fromMe,
//   //     "read_timestamp": readTimestamp?.millisecondsSinceEpoch,
//   //     "sent_timestamp": sentTimestamp.millisecondsSinceEpoch,
//   //     "referenced_message_id": referencedMessageId,
//   //     "text": text,
//   //     "media_type":
//   //         mediaType == null ? null : MediaType.values.indexOf(mediaType),
//   //     "media_url": mediaUrl,
//   //     "read_by_me": readByMe,
//   //   };
//   // }
// }
