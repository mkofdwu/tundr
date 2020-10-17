import 'package:tundr/models/user.dart';

class Suggestion {
  User user;
  bool liked;

  Suggestion({
    this.user,
    this.liked,
  });

  Map<String, dynamic> toMap() {
    return {
      // "uid": user.uid,
      "liked": liked,
    };
  }

  @override
  String toString() => "Sugestion: ${user.name}";

  @override
  bool operator ==(other) {
    return other is Suggestion && user.uid == other.user.uid;
  }

  @override
  int get hashCode => user.uid.hashCode;
}
