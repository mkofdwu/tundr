// import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:flutter/widgets.dart";
// import 'package:provider/provider.dart';
// import 'package:tundr/models/message.dart';
// import 'package:tundr/models/providerdata.dart';
// import 'package:tundr/services/firestoreservice.dart';
// import 'package:tundr/services/localdatabaseservice.dart';
// import 'package:tundr/utils/constants/enums/mediatype.dart';

// class MessagesHandler extends StatefulWidget {
//   final Widget child;

//   MessagesHandler({Key key, this.child}) : super(key: key);

//   @override
//   _MessagesHandlerState createState() => _MessagesHandlerState();
// }

// class _MessagesHandlerState extends State<MessagesHandler> {
//   Future<void> _loadMessages(List<DocumentSnapshot> messageDocs) {
//     final LocalDatabaseService localDatabaseService =
//         Provider.of<ProviderData>(context).localDatabaseService;

//     return Future.wait(messageDocs.map((doc) async {
//       if (!(await FirestoreService.blocked(
//         Provider.of<ProviderData>(context).user.uid,
//         doc.data["uid"],
//       ))) {
//         localDatabaseService.saveMessage(Message(
//           id: doc.documentID,
//           uid: doc.data["uid"],
//           fromMe: false,
//           readTimestamp: null,
//           sentTimestamp: doc.data["timestamp"].toDate(),
//           referencedMessageId: doc.data["referencedMessageId"],
//           text: doc.data["text"],
//           mediaType: doc.data["mediaType"] == null
//               ? null
//               : MediaType.values.elementAt(doc.data["mediaType"]),
//           mediaUrl: doc.data["mediaUrl"],
//           readByMe: false,
//         ));
//         if (await localDatabaseService.chatExists(doc.data["uid"])) {
//           localDatabaseService.setChatUpdated(doc.data["uid"]);
//         } else {
//           localDatabaseService.saveUnknownChat(doc.data["uid"]);
//         }
//       }
//       doc.reference.delete();
//     }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirestoreService.messagesStream(
//           Provider.of<ProviderData>(context).user.uid),
//       builder: (context, snapshot) {
//         if (snapshot.hasData)
//           _loadMessages(snapshot.data.documents).then((_) => setState(() {}));
//         return widget.child;
//       },
//     );
//   }
// }
