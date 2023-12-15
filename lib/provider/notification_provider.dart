import 'package:flutter/cupertino.dart';
import 'package:ib_sme_mb_view/model/models.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationBalanceModel> itemsBalance = [];
  List<NotificationSomethingModel> itemsSomething = [];

  setBalance(List<NotificationBalanceModel> itemsBalance) async {
    this.itemsBalance = itemsBalance;
    notifyListeners();
  }

  addBalance(List<NotificationBalanceModel> itemsBalance) async {
    this.itemsBalance.insertAll(itemsBalance.length - 1, itemsBalance);
    notifyListeners();
  }

  setSomething(List<NotificationSomethingModel> itemsSomething) async {
    this.itemsSomething = itemsSomething;
    notifyListeners();
  }

  addSomething(List<NotificationSomethingModel> itemsSomething) async {
    this.itemsSomething.insertAll(itemsSomething.length - 1, itemsSomething);
    notifyListeners();
  }
}
