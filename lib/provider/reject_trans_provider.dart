import 'package:flutter/cupertino.dart';
import 'package:ib_sme_mb_view/model/models.dart';

class RejectTransProvider extends ChangeNotifier {
  int? totalTransTT = 0;
  int? totalTransTL = 0;
  RejectTransSearchRequest? requestTT;
  RejectTransSearchRequest? requestTL;
  List<RejectTransResponse> listTransTT = [];
  List<RejectTransResponse> listTransTL = [];

  setTransTT(
      {List<RejectTransResponse>? listTransTT,
      RejectTransSearchRequest? requestTT,
      int? totalTransTT}) async {
    if (listTransTT != null) {
      this.listTransTT = listTransTT;
    }
    if (requestTT != null) {
      this.requestTT = requestTT;
    }
    if (totalTransTT != null) {
      this.totalTransTT = totalTransTT;
    }
    notifyListeners();
  }

  setTransTL(
      {List<RejectTransResponse>? listTransTL,
      RejectTransSearchRequest? requestTL,
      int? totalTransTL}) async {
    if (listTransTL != null) {
      this.listTransTL = listTransTL;
    }
    if (requestTL != null) {
      this.requestTL = requestTL;
    }
    if (totalTransTL != null) {
      this.totalTransTL = totalTransTL;
    }
    notifyListeners();
  }

  addTransTT(List<RejectTransResponse> items) async {
    listTransTT.addAll(items);
    notifyListeners();
  }

  addTransTL(List<RejectTransResponse> items) async {
    listTransTL.addAll(items);
    notifyListeners();
  }
}
