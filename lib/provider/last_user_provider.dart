import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';

class LastUserProvider extends ChangeNotifier {
  String? username = "";

  load() async {
    username = sharedpf.getLastUserLogin();
    // notifyListeners();
  }

  set(String? username) async {
    this.username = username;
    sharedpf.setLastUserLogin(username);
    sharedpf.addToListUserLogin(username);
    // notifyListeners();
  }
}
