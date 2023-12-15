import 'package:flutter/material.dart';
import '../../../model/models.dart';

class CountTransProvider extends ChangeNotifier {
  CountTrans? countTrans;
  CountTrans? get item => countTrans;

  saveCountTrans(CountTrans? countTrans) {
    this.countTrans = countTrans;
    notifyListeners();
  }

  clearCountTrans() {
    countTrans = null;
    notifyListeners();
  }

  setCountLotpending(int? value) {
    if (value != null) {
      countTrans!.lotPending = value;
      notifyListeners();
    }
  }
}
