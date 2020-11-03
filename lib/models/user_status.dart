class UserStatus {
  bool online;
  DateTime lastSeen;

  UserStatus({this.online, this.lastSeen});

  factory UserStatus.fromMap(Map<String, dynamic> map) {
    return UserStatus(
      online: map['online'],
      lastSeen: map['lastSeen'].toDate(),
    );
  }
}
