class UserSettings {
  bool newMatchNotification;
  bool messageNotification;
  bool blockUnknownMessages;
  bool readReceipts;
  bool showInMostPopular;

  UserSettings({
    this.newMatchNotification,
    this.messageNotification,
    this.blockUnknownMessages,
    this.readReceipts,
    this.showInMostPopular,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      newMatchNotification: map['newMatchNotification'],
      messageNotification: map['messageNotification'],
      blockUnknownMessages: map['blockUnknownMessages'],
      readReceipts: map['readReceipts'],
      showInMostPopular: map['showInMostPopular'],
    );
  }

  factory UserSettings.register() {
    return UserSettings(
      newMatchNotification: true,
      messageNotification: true,
      blockUnknownMessages: false,
      readReceipts: true,
      showInMostPopular: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newMatchNotification': newMatchNotification,
      'messageNotification': messageNotification,
      'blockUnknownMessages': blockUnknownMessages,
      'readReceipts': readReceipts,
      'showInMostPopular': showInMostPopular,
    };
  }
}
