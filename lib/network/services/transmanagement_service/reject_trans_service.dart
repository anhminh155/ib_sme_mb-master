import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/download_file_service.dart';

class RejectTransactionService {
  Future<BasePagingResponse> getTTTransaction(
      RejectTransSearchRequest request) async {
    request.status = RejectTransStatus.TUCHOI.value;
    var response = await Api.httpGet('/api/tran/mb', request.toJson());
    return BasePagingResponse.fromJson(response);
  }

  Future<BasePagingResponse> getTLTransaction(
      RejectTransSearchRequest request) async {
    request.status = RejectTransStatus.TUCHOI.value;
    var response = await Api.httpGet('/api/transschedule/mb', request.toJson());
    return BasePagingResponse.fromJson(response);
  }

  Future<BaseResponse> getTTTransactionDetail(
    String code,
  ) async {
    var response = await Api.httpGet('/api/tran/mb/$code', null);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getTLTransactionDetail(
    String code,
  ) async {
    var response = await Api.httpGet('/api/transschedule/mb/$code', null);
    return BaseResponse.fromJson(response);
  }

  Future<void> downloadFileTT(
      RejectTransSearchRequest request, BuildContext context) async {
    await saveFileFromAPI(context,
        url: '/api/tran/export',
        fileName: 'GDTTTC',
        requestBody: request.toJson());
  }

  Future<void> downloadFileTLDK(
      RejectTransSearchRequest request, BuildContext context) async {
    await saveFileFromAPI(context,
        url: '/api/transschedule/exporttc',
        fileName: 'GDTLDKTC',
        requestBody: request.toJson());
  }
}
