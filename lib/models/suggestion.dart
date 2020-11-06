class Suggestion {
  String uid;
  bool wasLiked;

  Suggestion({
    this.uid,
    this.wasLiked,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'uid': user.uid,
      'wasLiked': wasLiked,
    };
  }

  @override
  String toString() => 'Suggestion: ${uid}';

  @override
  bool operator ==(other) {
    return other is Suggestion && uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
