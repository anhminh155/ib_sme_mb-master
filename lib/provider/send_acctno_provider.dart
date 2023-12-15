// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/ddAcount/TddAccount_model.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/transaction_service.dart';

class SourceAcctnoProvider extends ChangeNotifier {
  List<TDDAcount> items = [];

  set(List<TDDAcount> items) {
    this.items = items;
    notifyListeners();
  }

  update() async {
    items = await getAllDDAcount();
    notifyListeners();
  }

  Future<List<TDDAcount>> getAllDDAcount() async {
    List<TDDAcount> accounts = [];
    try {
      BaseResponseDataList response =
          await Transaction_Service().getAllDDAcount();
      if (response.errorCode == FwError.THANHCONG.value) {
        if (response.data!.isNotEmpty) {
          accounts = response.data!
              .map<TDDAcount>((json) => TDDAcount.fromJson(json))
              .toList();
        }
        return accounts;
      }
    } catch (_) {}
    return [];
  }
}
