import 'package:flutter/cupertino.dart';
import 'package:ib_sme_mb_view/model/models.dart';

class TransLotProvider extends ChangeNotifier {
  int totalTrans = 0;
  StmTransferRequest? request;
  List<StmTransferResponse> items = [];

  setData(
      {List<StmTransferResponse>? items,
      int? totalTrans,
      StmTransferRequest? request}) {
    if (items != null) {
      this.items = items;
    }
    if (totalTrans != null) {
      this.totalTrans = totalTrans;
    }
    if (request != null) {
      this.request = request;
    }
    notifyListeners();
  }

  addData(List<StmTransferResponse> items) async {
    this.items.addAll(items);
    notifyListeners();
  }
}
