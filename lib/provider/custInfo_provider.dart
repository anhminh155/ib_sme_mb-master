// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/model/model.dart';

class CustInfoProvider extends ChangeNotifier {
  Cust? cust;
  Cust? get item => cust;

  saveCust(Cust? cust) {
    this.cust = cust;
    notifyListeners();
  }

  clearCust() {
    cust = null;
    notifyListeners();
  }
}
