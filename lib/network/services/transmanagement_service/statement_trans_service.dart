import 'package:flutter/cupertino.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../api/api.dart';
import 'download_file_service.dart';

class StatementTransService {
  Future<void> downloadTranslot(
      BuildContext context, StmTransferRequest request) async {
    request.status = 0;
    await saveFileFromAPI(context,
        url: '/api/translot/exportGD',
        fileName: 'DSGDBK',
        requestBody: request);
  }

  Future<void> downloadTransLotDetail(BuildContext context, String code) async {
    await saveFileFromAPI(context,
        url: '/api/translot/exportgdchoduyet',
        fileName: 'GDBKCT',
        requestBody: {"code": code});
  }

  Future<BasePagingResponse> searchStmTrans(
      BuildContext context, StmTransferRequest request) async {
    var response =
        await Api.httpGet('/api/translot/searchGD', request.toJson());
    return BasePagingResponse.fromJson(response);
  }

  Future<BasePagingResponse> getListOfTranslot(
      BuildContext context, StmTransferDetailRequest request) async {
    var response = await Api.httpGet(
        '/api/translotdetail/searchbytranslot', request.toJson());
    return BasePagingResponse.fromJson(response);
  }

  Future<BaseResponse> getDDAccountDetail(
      BuildContext context, String acc) async {
    Map<String, dynamic> request = {};
    request['acc'] = acc;
    var response = await Api.httpPost('/api/core/getddaccountdetail', request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getDetailTranslot(
      BuildContext context, String code) async {
    var response = await Api.httpGet('/api/translot/detail-mb/$code', null);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> checkLimitTransLot(BuildContext context, String code,
      String amount, String fee, String vat) async {
    Map<String, dynamic> request = {};
    request['code'] = code;
    request['amount'] = amount;
    request['fee'] = fee;
    request['vat'] = vat;
    var response = await Api.httpPost('/api/translot/checkhanmuc-mb', request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> confirm(
      String transCode, String otp, String code) async {
    Map<String, dynamic> request = {
      "code": transCode,
      "otp": otp,
      "data": {"code": code}
    };
    var response = await Api.httpPut('/api/translot/duyetlenh', request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> refuse(
      BuildContext context, String code, String reason) async {
    Map<String, dynamic> request = {"code": code, "reason": reason};
    var response = await Api.httpPost('/api/translot/tuchoi', request);
    return BaseResponse.fromJson(response);
  }
}
