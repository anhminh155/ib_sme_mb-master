import 'package:flutter/cupertino.dart';
import 'package:ib_sme_mb_view/model/models.dart';

import '../network/services/sharedPreferences_service.dart';

class OtpProvider extends ChangeNotifier {
  bool isRegister = false;
  int remainingSeconds = 0;
  DateTime? _lastOtpRequestTime;
  InitUserOTPModel? inituser;
  List<InitUserOTPModel> inituserlist = [];

  save(InitUserOTPModel inituser) async {
    this.inituser = inituser;
    sharedpf.addCustToListUserOTP(inituser);
    isRegister = true;
    load();
    notifyListeners();
  }

  clearCust() {
    inituser = null;
    isRegister = false;
    notifyListeners();
  }

  load() {
    inituserlist = sharedpf.getListUserOTP();
  }

  checkRegister(int id) {
    if (inituserlist.any((element) => element.id == id)) {
      isRegister = true;
    }
    notifyListeners();
  }

  deleteToken(int id) async {
    if (inituserlist.isNotEmpty) {
      if (inituserlist.any((element) => element.id == id)) {
        sharedpf.deteleCustfromList(id);
      }
    }
    inituser = null;
    notifyListeners();
  }

  InitUserOTPModel? getInitUser(int id) {
    load();
    if (inituserlist.isNotEmpty) {
      if (inituserlist.any((element) => element.id == id)) {
        inituser = inituserlist.firstWhere((element) => element.id == id);
        notifyListeners();
        return inituser;
      }
    }
    return null;
  }

  bool canRequestOtp(int timeBetween) {
    DateTime currentTime = DateTime.now();
    if (_lastOtpRequestTime == null || currentTime.difference(_lastOtpRequestTime!).inSeconds >=timeBetween) {
      return true;
    }
    remainingSeconds = timeBetween - currentTime.difference(_lastOtpRequestTime!).inSeconds;
    return false;
  }

  void updateOtpRequestTime() {
    _lastOtpRequestTime = DateTime.now();
    notifyListeners();
  }
}
