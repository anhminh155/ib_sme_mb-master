// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/index_widget.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../common/card_layout.dart';
import '../../../common/form_input_and_label/label.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../network/services/transmanagement_service/statement_trans_service.dart';

class ListTrans extends StatefulWidget {
  final StmTransferResponse tran;
  const ListTrans({super.key, required this.tran});

  @override
  State<ListTrans> createState() => _ListTransState();
}

class _ListTransState extends State<ListTrans> {
  int totalElement = 0;
  int totalPage = 0;
  int page = 0;
  int size = 5;
  bool _isLoading = false;
  List<TranslotDetailModel> listTrans = [];
  @override
  void initState() {
    super.initState();
    _getTranslotDetail();
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
        title: const Text('Danh sách giao dịch'),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [renderBody(), if (_isLoading) const LoadingCircle()],
      ),
    );
  }

  Future<void> _getTranslotDetail() async {
    setState(() => _isLoading = true);
    StmTransferDetailRequest request = StmTransferDetailRequest(
        sort: 'updatedAt,desc',
        page: page,
        size: size,
        transLot: widget.tran.code);
    BasePagingResponse response =
        await StatementTransService().getListOfTranslot(context, request);
    setState(() => _isLoading = false);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listTrans = response.data!.content!
            .map((e) => TranslotDetailModel.fromJson(e))
            .toList();
        totalElement = response.data?.totalElements ?? 0;
        totalPage = response.data?.totalPages ?? 0;
      });
    }
  }

  renderSpace(double i) => SizedBox(
        height: i,
      );

  renderBody() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .95,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderSpace(20),
            renderCard1(),
            renderSpace(15),
            renderListPerTotal(),
            renderSpace(15),
            renderCard2(),
            renderSpace(30),
            renderBtn(),
            renderSpace(30),
          ],
        ),
      ),
    );
  }

  renderListPerTotal() {
    return RichText(
      text: TextSpan(
        text: 'Danh sách giao dịch: ',
        style: const TextStyle(fontSize: 20, color: primaryColor),
        children: <TextSpan>[
          TextSpan(
              text:
                  '${listTrans.length}/${Currency.formatNumber(totalElement)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: secondaryColor)),
        ],
      ),
    );
  }

  renderCard1() {
    return Center(
      child: CardLayoutWidget(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          renderLineInfo(
              label: 'Tổng số giao dịch',
              value: Currency.formatNumber(totalElement),
              line: false),
          renderSpace(15),
          renderLineInfo(
              label: 'Tổng số tiền giao dịch',
              value: Currency.formatCurrency(int.parse(widget.tran.amount!)),
              line: false),
          renderSpace(15),
          renderLineInfo(
              label: 'Tổng số phí bảng kê',
              value: Currency.formatCurrency(int.parse(widget.tran.fee!)),
              line: false),
        ],
      )),
    );
  }

  renderCard2() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listTrans.length + 1,
        itemBuilder: (context, index) {
          if (index >= listTrans.length) {
            if (listTrans.length < totalElement) {
              return renderShowMore();
            } else {
              return Container();
            }
          } else {
            return renderItem(listTrans[index], index);
          }
        },
      ),
    );
  }

  renderShowMore() {
    return Align(
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
    );
  }

  Future<void> _ontapShowMore() async {
    StmTransferDetailRequest request = StmTransferDetailRequest(
        sort: 'updatedAt,desc',
        page: page + 1,
        size: size,
        transLot: widget.tran.code);
    setState(() => _isLoading == true);
    BasePagingResponse response =
        await StatementTransService().getListOfTranslot(context, request);
    setState(() => _isLoading == false);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listTrans.addAll(response.data!.content!
            .map((e) => TranslotDetailModel.fromJson(e))
            .toList());
        page += 1;
      });
    }
  }

  renderItem(TranslotDetailModel item, int index) {
    return GestureDetector(
      onTap: () => _showModelSheetInfo(item),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            CardLayoutWidget(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        Currency.formatCurrency(int.parse(item.amount ?? "0")),
                        style: const TextStyle(color: secondaryColor),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        item.code ?? "",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
                renderSpace(5),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                        text: "Trạng thái :  ",
                        style: const TextStyle(color: Colors.black45),
                        children: [
                          TextSpan(
                            text: TransLotDetailStatusEnum.getStatus(
                                item.status!),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ]),
                  ),
                ),
                renderSpace(5),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                        text: "Người nhận :  ",
                        style: const TextStyle(color: Colors.black45),
                        children: [
                          TextSpan(
                            text: item.receiveName ?? "",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ]),
                  ),
                )
              ],
            )),
            IndexWidget(
              index: index + 1,
            )
          ],
        ),
      ),
    );
  }

  _showModelSheetInfo(TranslotDetailModel item) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container()),
                  const Expanded(
                    child: Text(
                      'Chi tiết',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Đóng',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          TransLotDetailStatusEnum.getStatus(item.status ?? ""),
                          style: const TextStyle(color: primaryColor),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  renderField("Số tài khoản", item.receiveAccount),
                  renderLine(),
                  renderField("Tên người nhận", item.receiveName),
                  renderField("Ngân hàng", item.receiveBank),
                  renderLine(),
                  renderField("Số tiền",
                      Currency.formatCurrency(int.tryParse(item.amount!) ?? 0)),
                  renderReadAmout(
                      Currency.removeFormatNumber(item.amount ?? '0')),
                  renderLine(),
                  renderField("Số tiền phí",
                      Currency.formatCurrency(_getTotalFee(item))),
                  renderReadAmout(_getTotalFee(item).toString()),
                  renderLine(),
                  renderField("Nội dung", item.content),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  _getTotalFee(TranslotDetailModel item) {
    double fee = double.tryParse(item.fee!) ?? 0;
    double vat = double.tryParse(item.vat!) ?? 0;
    return (fee + vat).truncate();
  }

  renderReadAmout(String amount) {
    if (amount.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Text(
          Currency.numberToWords(int.parse(amount)),
          style: const TextStyle(color: primaryColor),
          textAlign: TextAlign.left,
        ),
      );
    }
    return Container();
  }

  renderBtn() {
    return ButtonWidget(
        backgroundColor: primaryColor,
        onPressed: () => _downloadFile(),
        text: 'Tải danh sách',
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width);
  }

  _downloadFile() {
    setState(() => _isLoading = true);
    StatementTransService()
        .downloadTransLotDetail(context, widget.tran.code!)
        .whenComplete(
      () {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  renderLineInfo({required label, required String value, bool line = true}) {
    return Column(
      children: [
        renderSpace(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
        renderSpace(8),
        if (line == true)
          const Divider(
            thickness: 1,
          ),
      ],
    );
  }

  renderField(lable, data) {
    return Center(
      child: LabelWidget(
          colors: colorBlack_727374,
          label: lable,
          fontWeight: FontWeight.w500,
          //padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              data,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                color: primaryBlackColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    );
  }

  renderLine() {
    return const Divider(
      color: coloreWhite_EAEBEC, // Màu của đường kẻ
      thickness: 1.0, // Độ dày của đường kẻ
    );
  }
}
