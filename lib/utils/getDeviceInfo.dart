// ignore_for_file: file_names

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ib_sme_mb_view/model/models.dart';

class DeviceUtils {
  static Future<DeviceInfo> getDeviceInfo() async {
    if (kIsWeb) {
      return const DeviceInfo(
        devBrand: '',
        devEmulator: false,
        devManufacturer: '',
        devModelId: '',
        devSystemName: '',
        id: '',
        name: '',
        devSystemVersion: '',
      );
    } else {
      final deviceInfo = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        return DeviceInfo(
          devBrand: androidInfo.brand,
          devEmulator: !androidInfo.isPhysicalDevice,
          devManufacturer: androidInfo.manufacturer,
          devModelId: androidInfo.id,
          devSystemName: "Android",
          id: androidInfo.id,
          name: androidInfo.model,
          devSystemVersion: androidInfo.version.release,
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return DeviceInfo(
          devBrand: iosInfo.model,
          devEmulator: !iosInfo.isPhysicalDevice,
          devManufacturer: iosInfo.model,
          devModelId: iosInfo.identifierForVendor!,
          devSystemName: iosInfo.systemName,
          id: iosInfo.identifierForVendor!,
          name: iosInfo.name,
          devSystemVersion: iosInfo.systemVersion,
        );
      }
      return const DeviceInfo(
        devBrand: '',
        devEmulator: false,
        devManufacturer: '',
        devModelId: '',
        devSystemName: '',
        id: '',
        name: '',
        devSystemVersion: '',
      );
    }
  }
}
