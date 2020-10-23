class SuggestionGoneThrough {
  String uid;
  bool liked;

  SuggestionGoneThrough({
    this.uid,
    this.liked,
  });

  factory SuggestionGoneThrough.fromMap(Map<String, dynamic> map) {
    return SuggestionGoneThrough(
      uid: map['uid'],
      liked: map['liked'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'liked': liked,
    };
  }
}
