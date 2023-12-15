import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/index_widget.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/download_file_service.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/manage_manifest_transactions.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_trang_thai_bang_ke/thong_tin_giao_dich_bang_ke.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../utils/theme.dart';
import '../getcolor_status.dart';

class ListResltStatementTransaction extends StatefulWidget {
  final StatementTransRequest requestParams;
  final String? accountNumber;
  const ListResltStatementTransaction(
      {super.key, required this.requestParams, this.accountNumber});

  @override
  State<ListResltStatementTransaction> createState() =>
      ListResltStatementTransactionState();
}

class ListResltStatementTransactionState
    extends State<ListResltStatementTransaction> with BaseComponent {
  List<String> listCode = [];
  bool selectAll = false;
  bool statusDelete = false;
  List listCount = [];
  int pages = 1;
  int totalElements = 0;
  List transactions = [];

  late TextEditingController controllerReason;

  @override
  void initState() {
    super.initState();
    getListApproveTransLot(currentPage: pages);
    controllerReason = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controllerReason.dispose();
  }

  getListApproveTransLot({int? currentPage}) async {
    page.curentPage = currentPage!;
    page.size = 5;
    BasePagingResponse response = await ManageManifesTransactionsService()
        .searchTransactions(page, widget.requestParams);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        pages++;
        listResponse = response.data!.content!
            .map((e) => StmTransferResponse.fromJson(e))
            .toList();
        totalElements = response.data!.totalElements!;
        transactions.addAll(listResponse);
        isLoading = false;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
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
          title: const Text('Quản lý giao dịch bảng kê'),
          backgroundColor: primaryColor,
        ),
        body: (isLoading)
            ? const Center(
                child: LoadingCircle(),
              )
            : _renderTransactions());
  }

  _renderTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            children: [
              CardLayoutWidget(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tài khoản nguồn"),
                    Text(widget.accountNumber ?? 'Tất cả'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text('Tổng giao dịch: $totalElements'),
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _renderItem(transactions[index],
                        index); // Trả về widget tại vị trí index
                  },
                ),
              ),
              if (transactions.length < totalElements)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        getListApproveTransLot(currentPage: pages);
                      },
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: ButtonWidget(
              backgroundColor: Colors.white,
              onPressed: () async {
                await saveFileFromAPI(context,
                    url: '/api/translot/export',
                    fileName: "GDBK",
                    requestBody: widget.requestParams);
              },
              text: 'Tải danh sách',
              colorText: secondaryColor,
              colorBorder: secondaryColor,
              haveBorder: true,
              widthButton: MediaQuery.of(context).size.width),
        ),
      ],
    );
  }

  _renderItem(StmTransferResponse item, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThongTinGiaoDichBangKe(
                    transLotCode: item.transLotCode!,
                  ),
                ),
              );
            },
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
                                int.parse(item.amount ?? '0')),
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                          Text(
                            item.transLotCode ?? "",
                            style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text.rich(
                        TextSpan(
                            text: "Loại giao dịch: ",
                            style: TextStyle(color: Colors.black45),
                            children: [
                              TextSpan(
                                text: "Chuyển tiền bảng kê",
                                style: TextStyle(color: Colors.black),
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
                                text: item.fileName ?? "",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Trạng thái:  ",
                            style: const TextStyle(color: Colors.black45),
                            children: [
                              TextSpan(
                                text: StatusApprovetranslot.getStringByValue(
                                    item.status),
                                style: TextStyle(
                                  color: getColorByValue(
                                      StatusApprovetranslot.getStringByValue(
                                          item.status)),
                                ),
                              ),
                            ]),
                      ),
                    ]),
              ),
            ),
          ),
          IndexWidget(
            index: index + 1,
          ),
        ],
      ),
    );
  }
}
