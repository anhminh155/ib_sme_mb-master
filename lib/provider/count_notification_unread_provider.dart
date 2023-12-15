import 'package:flutter/material.dart';

class CountUnreadProvider extends ChangeNotifier {
  int? countUnread;
  int? get item => countUnread;

  saveCountUnread(int? countUnread) {
    this.countUnread = countUnread;
    notifyListeners();
  }

  clearCountUnread() {
    countUnread = 0;
    notifyListeners();
  }
}
