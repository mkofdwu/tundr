class SuggestionGoneThrough {
  String uid;
  bool liked;
  double similarityScore;

  SuggestionGoneThrough({
    this.uid,
    this.liked,
    this.similarityScore,
  });

  factory SuggestionGoneThrough.fromMap(Map<String, dynamic> map) {
    return SuggestionGoneThrough(
      uid: map["uid"],
      liked: map["liked"],
      similarityScore: map["similarityScore"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "liked": liked,
      "similarityScore": similarityScore,
    };
  }
}
