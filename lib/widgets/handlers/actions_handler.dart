// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:tundr/repositories/user.dart';
// import 'package:tundr/services/databaseservice.dart';
// import 'package:tundr/enums/actiontype.dart';
// import 'package:tundr/models/action.dart' as appAction;

// class ActionsHandler extends StatefulWidget {
//   final Widget child;

//   ActionsHandler({Key key, this.child}) : super(key: key);

//   @override
//   _ActionsHandlerState createState() => _ActionsHandlerState();
// }

// class _ActionsHandlerState extends State<ActionsHandler> {
//   Future<void> _retrieveActions(List<DocumentSnapshot> actionDocs) async {
//     return Future.wait(actionDocs.map((doc) async {
//       // print(
//       //     'Action(type: ${action.type}, senderUid: ${action.senderUid}, payload: ${action.payload})');
//       final appAction.Action action = appAction.Action.fromDoc(doc);
//       switch (action.type) {
//         case ActionType.notifyReadMessage:
//           Provider.of<User>(context)
//               .localDatabaseService
//               .updateOtherUserLastReadChat(
//                 action.senderUid,
//                 action.payload.millisecondsSinceEpoch,
//               );
//           break;
//         case ActionType.deleteMessage:
//           DatabaseService.deleteMessage(action
//               .payload); // FUTURE: or change it to null, and display tile saying 'this message was deleted'?
//           break;
//         case ActionType.newMatch:
//           Provider.of<User>(context)
//               .localDatabaseService
//               .saveMatch(action.senderUid);
//           break;
//         default:
//           throw Exception('Invalid action type: ${action.type}');
//       }
//       doc.reference.delete();
//     }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: DatabaseService.actionsStream(
//           Provider.of<User>(context).profile.uid),
//       builder: (context, snapshot) {
//         if (snapshot.hasData)
//           _retrieveActions(snapshot.data.docs)
//               .then((_) => setState(() {}));
//         return widget.child;
//       },
//     );
//   }
// }
