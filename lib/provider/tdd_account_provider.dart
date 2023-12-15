import 'package:flutter/material.dart';

class TddAccountProvider extends ChangeNotifier {
  int sumPayment = 0;

  setSumPayment(int sumPayment) {
    this.sumPayment = sumPayment;
    notifyListeners();
  }

  clearCust() {
    sumPayment = 0;
    notifyListeners();
  }
}
