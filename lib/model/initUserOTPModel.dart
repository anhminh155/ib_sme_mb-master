// ignore_for_file: file_names

class InitUserOTPModel {
  final int id;
  final String tokenID;
  final String username;
  final String key;
  final String pin;
  final String? timeLock;
  final int timesEnterError;

  InitUserOTPModel(
      {required this.id,
      required this.tokenID,
      required this.username,
      required this.key,
      required this.pin,
      this.timeLock,
      this.timesEnterError = 0});

  factory InitUserOTPModel.fromJson(Map<String, dynamic> json) {
    return InitUserOTPModel(
        id: json['id'],
        tokenID: json['tokenID'],
        username: json['username'],
        key: json['key'],
        pin: json['pin'],
        timeLock: json['timeLock'],
        timesEnterError: json['timesEnterErorr']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'key': key,
      'pin': pin,
      'tokenID': tokenID,
      'timeLock': timeLock,
      'timesEnterErorr': timesEnterError,
    };
  }
  InitUserOTPModel copyWith({
    int? id,
    String? tokenID,
    String? username,
    String? key,
    String? pin,
    String? timeLock,
    int? timesEnterError,
  }) {
    return InitUserOTPModel(
      id: id ?? this.id,
      tokenID: tokenID ?? this.tokenID,
      username: username ?? this.username,
      key: key ?? this.key,
      pin: pin ?? this.pin,
      timeLock: timeLock,
      timesEnterError: timesEnterError ?? this.timesEnterError,
    );
  }
}
