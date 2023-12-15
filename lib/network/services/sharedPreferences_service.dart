// ignore_for_file: file_names

import 'dart:convert';
import 'package:ib_sme_mb_view/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'dart:developer' as dev;

class SharedPreferencesManager {
  SharedPreferences? _prefs;

  SharedPreferencesManager._();

  static final SharedPreferencesManager instance = SharedPreferencesManager._();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences? get prefs => _prefs;

  List<InitUserOTPModel> getListUserOTP() {
    List<String>? jsonList = prefs!.getStringList('initUserList');
    if (jsonList != null) {
      return jsonList
          .map((json) => InitUserOTPModel.fromJson(jsonDecode(json)))
          .toList();
    } else {
      // Trường hợp không có danh sách được lưu trữ
      return [];
    }
  }

  void addCustToListUserOTP(InitUserOTPModel user) {
    List<InitUserOTPModel> existingList = getListUserOTP();
    bool isDuplicate = existingList.any((item) => item.id == user.id);
    if (isDuplicate) {
      // Nếu có trong danh sách thì xóa đi
      existingList.removeWhere((element) => element.id == user.id);
    }
    existingList.add(user);
    List<String> jsonList =
        existingList.map((object) => jsonEncode(object.toJson())).toList();
    prefs!.setStringList('initUserList', jsonList);
  }

  deteleCustfromList(int id) {
    List<InitUserOTPModel> existingList = getListUserOTP();
    // Kiểm tra xem đối tượng có tồn tại trong danh sách không
    bool isDuplicate = existingList.any((item) => item.id == id);
    if (isDuplicate) {
      // Nếu có trong danh sách thì xóa đi
      existingList.removeWhere((element) => element.id == id);
    }
    List<String> jsonList =
        existingList.map((object) => jsonEncode(object.toJson())).toList();
    prefs!.setStringList('initUserList', jsonList);
  }

  deteleCustfromListByUserName(String username) {
    List<InitUserOTPModel> existingList = getListUserOTP();
    // Kiểm tra xem đối tượng có tồn tại trong danh sách không
    bool isDuplicate = existingList.any((item) => item.username == username);
    if (isDuplicate) {
      // Nếu có trong danh sách thì xóa đi
      existingList.removeWhere((element) => element.username == username);
    }
    List<String> jsonList =
        existingList.map((object) => jsonEncode(object.toJson())).toList();
    prefs!.setStringList('initUserList', jsonList);
  }

  bool checkFirstTimeLogin(String username) {
    List<String>? jsonList = prefs!.getStringList('list_user_login') ?? [];
    if (jsonList.isNotEmpty) {
      if (jsonList.contains(username)) {
        return false;
      }
    }
    return true;
  }

  List<String> getListUserLogin() {
    return prefs!.getStringList('list_user_login') ?? [];
  }

  addToListUserLogin(String? username) {
    if (username != null) {
      List<String>? jsonList = prefs!.getStringList('list_user_login') ?? [];
      if (!jsonList.contains(username)) {
        jsonList.add(username);
        prefs!.setStringList('list_user_login', jsonList);
      }
    }
  }

  removeToListUserLogin(String? username) {
    if (username != null) {
      List<String>? jsonList = prefs!.getStringList('list_user_login') ?? [];
      if (jsonList.contains(username)) {
        jsonList.remove(username);
        prefs!.setStringList('list_user_login', jsonList);
      }
    }
  }

  setLastUserLogin(String? username) {
    if (username != null) {
      String? user = prefs!.getString('last_user_login');
      if (user != null) {
        if (user.compareTo(username) != 0) {
          prefs!.setString('last_user_login', username);
        }
      } else {
        prefs!.setString('last_user_login', username);
      }
    }
  }

  String getLastUserLogin() {
    String? user = prefs!.getString('last_user_login');
    if (user != null) {
      return user;
    } else {
      return "";
    }
  }

  removeLastLogin() {
    String? user = prefs!.getString('last_user_login');
    if (user != null) {
      prefs!.remove('last_user_login');
    }
  }

  setLimitAccount(value) {
    prefs!.setInt('limitaccount', value);
  }

  checkLimitAccount() {
    // Kiểm tra xem đã đặt limitaccount chưa
    bool isLimitAccountSet = prefs!.getInt('limitaccount') == 1;
    if (!isLimitAccountSet && isFirstTimeOpen) {
      sharedpf.setLimitAccount(1);
      isFirstTimeOpen = false;
    }
  }

  getLimitAccount() {
    int? limitAccount = prefs!.getInt('limitaccount');
    if (limitAccount != null) {
      return limitAccount;
    } else {
      return 1;
    }
  }

  countNotificationUnRead(String status) {
    int unreadNotificationCount = prefs!.getInt('unreadNotifications') ?? 0;
    unreadNotificationCount++;
    prefs!.setInt('unreadNotifications', unreadNotificationCount);
    dev.log('Update Unread $status: $unreadNotificationCount');
  }

  removeNotificationUnreadClicked(String status) {
    int unreadNotificationCount = prefs!.getInt('unreadNotifications') ?? 0;
    if (unreadNotificationCount >= 1) {
      unreadNotificationCount--;
    }
    prefs!.setInt('unreadNotifications', unreadNotificationCount);
    dev.log('Remove Unread $status: $unreadNotificationCount');
  }

  setParamSettingOTP(OtpSettingModel model) {
    prefs!.setString('otp_setting_model', jsonEncode(model.toJson()));
  }

  OtpSettingModel getParamSettingOTP() {
    String? json = prefs!.getString('otp_setting_model');
    if (json != null) {
      return OtpSettingModel.fromJson(jsonDecode(json));
    }
    return OtpSettingModel.initial();
  }
}

SharedPreferencesManager get sharedpf => SharedPreferencesManager.instance;
