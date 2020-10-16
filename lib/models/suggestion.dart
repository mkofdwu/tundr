import 'package:tundr/models/user.dart';

class Suggestion {
  User user;
  bool liked;
  double similarityScore;

  Suggestion({
    this.user,
    this.liked,
    this.similarityScore,
  });

  Map<String, dynamic> toMap() {
    return {
      // "uid": user.uid,
      "liked": liked,
      "similarityScore": similarityScore,
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
