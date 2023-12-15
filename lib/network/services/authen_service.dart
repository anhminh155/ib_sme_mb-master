import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';
// import 'package:safe_device/safe_device.dart';

class AuthenService {
  static Future<void> logOut() async {
    await Api.httpPost('/api/auth/signout', {});
    localStorage.deleteItem("currentUser");
  }

  static Future<bool> checkSafeDevice() async {
    // bool isJailBroken = await SafeDevice.isJailBroken;
    // bool isRealDevice = await SafeDevice.isRealDevice;
    // // bool isOnExternalStorage = await SafeDevice.isOnExternalStorage;
    // // bool isSafeDevice = await SafeDevice.isSafeDevice;
    // // bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    // if (!isJailBroken && isRealDevice) {
    //   return true;
    // }
    // return false;
    return true;
  }
}
