// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/chi_tiet_giao_dich_bang_ke.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:provider/provider.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/index_widget.dart';
import '../../../network/services/transmanagement_service/statement_trans_service.dart';
import '../../../utils/theme.dart';

class DanhSachBangKeChoDuyet extends StatefulWidget {
  final TDDAcount account;
  final StmTransferRequest request;
  const DanhSachBangKeChoDuyet(
      {super.key, required this.account, required this.request});

  @override
  State<DanhSachBangKeChoDuyet> createState() => DanhSachBangKeChoDuyetState();
}

class DanhSachBangKeChoDuyetState extends State<DanhSachBangKeChoDuyet> {
  List<StmTransferResponse> transactions = [];
  bool _isLoading = false;
  int page = 0;
  int size = 10;
  int checkMore = 10;

  _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _offLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: const Text('Giao dịch bảng kê chờ duyệt'),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [renderBody(), if (_isLoading) const LoadingCircle()],
      ),
    );
  }

  renderBody() {
    return Consumer<TransLotProvider>(
        builder: (context, transLotProvider, child) {
      int totalTrans = transLotProvider.totalTrans;
      var listTrans = transLotProvider.items;
      return (totalTrans < 1)
          ? const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng số giao dịch: $totalTrans',
                          style: const TextStyle(
                              fontSize: 20, color: primaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listTrans.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _renderItem(listTrans[index],
                                  index); // Trả về widget tại vị trí index
                            },
                          ),
                        ),
                        if (listTrans.length < totalTrans)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: _ontapShowMore,
                                child: const Text(
                                  "Xem thêm",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                      decoration: TextDecoration.underline),
                                )),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: ButtonWidget(
                      backgroundColor: secondaryColor,
                      onPressed: totalTrans > 0 ? _downloadFile : null,
                      text: 'Tải danh sách',
                      colorText: Colors.white,
                      haveBorder: false,
                      widthButton: MediaQuery.of(context).size.width),
                ),
              ],
            );
    });
  }

  Future<void> _ontapShowMore() async {
    var request = Provider.of<TransLotProvider>(context, listen: false).request;
    if (request != null) {
      request.page = page + 1;
      _onLoading();
      BasePagingResponse response =
          await StatementTransService().searchStmTrans(context, request);
      _offLoading();
      if (response.errorCode == FwError.THANHCONG.value) {
        var newValue = response.data!.content!
            .map((e) => StmTransferResponse.fromJson(e))
            .toList();
        await Provider.of<TransLotProvider>(context, listen: false)
            .addData(newValue);
        setState(() {
          page += 1;
        });
      }
    }
  }

  _downloadFile() async {
    _onLoading();
    await StatementTransService().downloadTranslot(context, widget.request);
    _offLoading();
  }

  _onPressItem(StmTransferResponse data) async {
    _onLoading();
    try {
      BaseResponse responseAcc = await StatementTransService()
          .getDDAccountDetail(context, data.sendAccount!);
      if (responseAcc.errorCode == FwError.THANHCONG.value) {
        BaseResponse responseTranslot = await StatementTransService()
            .getDetailTranslot(context, data.code ?? "");
        if (responseTranslot.errorCode == FwError.THANHCONG.value) {
          var trans = StmTransferResponse.fromJson(responseTranslot.data);
          TDDAcount account = TDDAcount.fromJson(responseAcc.data);
          setState(() {
            page = 0;
          });
          _gotoNextScreen(trans, account);
        }
      } else {
        showToast(
            context: context,
            msg: responseAcc.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } finally {
      _offLoading();
    }
  }

  _gotoNextScreen(data, TDDAcount account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThongTinBangKeChoDuyet(
          tran: data,
          ddAccount: account,
        ),
      ),
    );
  }

  _renderItem(StmTransferResponse data, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () => _onPressItem(data),
            child: CardLayoutWidget(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .95,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Currency.formatCurrency(
                                double.parse(data.amount ?? "0")),
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                data.transLotCode ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Loại giao dịch:  ",
                            style: const TextStyle(color: Colors.black45),
                            children: [
                              TextSpan(
                                text: FUNCDESCRIPTION.CTBK.value,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Tên bảng kê: ",
                            style: const TextStyle(color: Colors.black45),
                            children: [
                              TextSpan(
                                text: data.fileName,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ]),
                      ),
                    ]),
              ),
            ),
          ),
          IndexWidget(
            index: index + 1,
          )
        ],
      ),
    );
  }
}
