class OtpModel {
  final String aesIvEncrypted;
  final String aesKeyEncrypted;
  final DeviceInfo deviceInfo;
  final String initializationCode;
  final String pin;
  final String rsaKeyId;
  final String smsOtpCode;

  const OtpModel(
      {required this.aesIvEncrypted,
      required this.aesKeyEncrypted,
      required this.deviceInfo,
      required this.initializationCode,
      required this.pin,
      required this.rsaKeyId,
      required this.smsOtpCode});
  Map<String, dynamic> toJson() {
    return {
      'aesIvEncrypted': aesIvEncrypted,
      'aesKeyEncrypted': aesKeyEncrypted,
      'deviceInfo': deviceInfo.toJson(),
      'initializationCode': initializationCode,
      'pin': pin,
      'rsaKeyId': rsaKeyId,
      'smsOtpCode': smsOtpCode
    };
  }
}

class DeviceInfo {
  final String devBrand;
  final bool devEmulator;
  final String devManufacturer;
  final String devModelId;
  final String devSystemName;
  final String devSystemVersion;
  final String id;
  final String name;

  const DeviceInfo(
      {required this.devBrand,
      required this.devEmulator,
      required this.devManufacturer,
      required this.devModelId,
      required this.devSystemName,
      required this.devSystemVersion,
      required this.id,
      required this.name});

  Map<String, dynamic> toJson() {
    return {
      'devBrand': devBrand,
      'devEmulator': devEmulator,
      'devManufacturer': devManufacturer,
      'devModelId': devModelId,
      'devSystemName': devSystemName,
      'devSystemVersion': devSystemVersion,
      'id': id,
      'name': name
    };
  }
}
