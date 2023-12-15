// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/network/services/core_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/download_file_service.dart';
import 'package:ib_sme_mb_view/page/truy_van_tai_khoan/select_time.dart';
import 'package:intl/intl.dart';
import '../../common/card_layout.dart';
import '../../common/form/form_control.dart';
import '../../common/form/input_show_bottom_sheet.dart';
import '../../enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../utils/theme.dart';

class ChiTietTaiKhoan extends StatefulWidget {
  final List<DDAcount>? listDDAcount;
  final String? acctno;
  final int type;
  final String label;
  const ChiTietTaiKhoan(
      {super.key,
      this.listDDAcount,
      this.acctno,
      required this.type,
      required this.label});

  @override
  State<ChiTietTaiKhoan> createState() => _ChiTietTaiKhoanState();
}

class _ChiTietTaiKhoanState extends State<ChiTietTaiKhoan>
    with BaseComponent<DDAcount> {
  late TextEditingController controllerAccount;
  DDAccountStatmentResponse dDAccountStatmentResponse =
      const DDAccountStatmentResponse();
  Map<String, dynamic> bodyrequest = {};
  bool _isLoading = true;
  List<DDAccountStatment> listDDAcountStatment = [];
  @override
  void initState() {
    controllerAccount = TextEditingController(text: widget.acctno);
    if (widget.acctno != null) getDDAcountDetail(widget.acctno!);
    super.initState();
  }

  getDDAcountDetail(String id) async {
    BaseResponse<DDAcount> response = await CoreService().getDDAcountDetail(id);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        dataResponse = DDAcount.fromJson(response.data);
        isLoading = false;
      });
    }
  }

  getDDAccountStatment(bodyRequest) async {
    _isLoading = true;
    BaseResponse<DDAccountStatmentResponse> response =
        await CoreService().getDDAccountStatment(bodyRequest);
    if (response.errorCode == FwError.THANHCONG.value) {
      if (response.data != null) {
        setState(() {
          dDAccountStatmentResponse =
              DDAccountStatmentResponse.fromJson(response.data);
          listDDAcountStatment =
              dDAccountStatmentResponse.list!.reversed.toList();

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  convert(value) {
    if (value != null && value != '') {
      String formattedNumber = NumberFormat('#,##0 VND').format(value);
      return formattedNumber;
    } else {
      return '0';
    }
  }

  @override
  void dispose() {
    controllerAccount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: Text(
            '${translation(context)!.detailKey} ${widget.label.toLowerCase()}'),
        backgroundColor: primaryColor,
      ),
      body: !isLoading ? renderBody() : const LoadingCircle(),
    );
  }

  renderBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 16.0, right: 16.0, left: 16.0, bottom: 12.0),
          child: CardLayoutWidget(
            child: FormControlWidget(
              label: translation(context)!.account_numberKey,
              child: InputShowBottomSheet(
                controller: controllerAccount,
                hintText: "Chọn số tài khoản",
                bodyWidget: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: isLoading
                      ? const LoadingCircle()
                      : (widget.listDDAcount != null &&
                                  widget.listDDAcount!.isEmpty ||
                              dDAccountStatmentResponse.list != null &&
                                  dDAccountStatmentResponse.list!.isEmpty)
                          ? const Center(
                              child: Text(
                              'Không có dữ liệu',
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                            ))
                          : dDAcountBottomSheetWidget(),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CardLayoutWidget(
                child: widget.type == 0
                    ? dDAccCust(dataResponse!)
                    : widget.type == 1
                        ? fDAccCust()
                        : lNAccCust(),
              ),
              const SizedBox(
                height: 32.0,
              ),
              CardLayoutWidget(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectTime(onClickSearch: (bodyRequest) {
                      bodyRequest["acc"] = controllerAccount.text != ''
                          ? controllerAccount.text
                          : widget.acctno;
                      bodyrequest = bodyRequest;
                      getDDAccountStatment(bodyRequest);
                    }),
                    renderButton(),
                    (_isLoading == false)
                        ? renderListItem()
                        : const LoadingCircle(),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ListView dDAcountBottomSheetWidget() {
    return ListView(
      children: [
        for (var item in widget.listDDAcount!)
          InkWell(
              onTap: () {
                Navigator.pop(context);
                controllerAccount.text = item.acctno!;
                getDDAcountDetail(controllerAccount.text);
                bodyrequest['acc'] = controllerAccount.text;
                getDDAccountStatment(bodyrequest);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: (widget.listDDAcount!.last != item)
                    ? const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: coloreWhite_EAEBEC),
                        ),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.acctno ?? '--',
                      style: TextStyle(
                        fontSize: 16,
                        color: (controllerAccount.text == item.acctno)
                            ? primaryColor
                            : primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (controllerAccount.text == item.acctno)
                        ? const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: primaryColor,
                            size: 24,
                          )
                        : const SizedBox(),
                  ],
                ),
              ))
      ],
    );
  }

  dDAccCust(DDAcount dDAcount) {
    return Column(
      children: [
        renderLineContent(
            label: translation(context)!.account_numberKey,
            content: dDAcount.acctno),
        renderLineContent(
            label: translation(context)!.open_atKey, content: dDAcount.acctno),
        renderLineContent(
            label: translation(context)!.current_open_dayKey,
            content: dDAcount.opndate),
        renderLineContent(
            label: translation(context)!.current_balanceKey,
            content: convert(dDAcount.curbalance)),
        renderLineContent(
            label: translation(context)!.available_balanceKey,
            content: convert(int.tryParse(dDAcount.balance ?? "0"))),
        renderLineContent(
            label: translation(context)!.statusKey, content: dDAcount.status),
        renderLineContent(
            label: translation(context)!.last_trading_dayKey,
            content: dDAcount.lastdate),
        renderLineContent(
            label: translation(context)!.interest_rateKey,
            content: convert(dDAcount.dbegbal)),
        renderLineContent(
            label: translation(context)!.accrued_interestKey,
            content: convert(dDAcount.crintacr),
            line: false),
      ],
    );
  }

  lNAccCust() {
    return Column(
      children: [
        renderLineContent(label: "Sản phẩm tiền vay", content: 'Tiền vay'),
        renderLineContent(label: "Mở tại CN/PGD", content: 'PGD Quận Cầu Giấy'),
        renderLineContent(label: "Ngày mở", content: '20/02/2021'),
        renderLineContent(label: "Dư nợ gốc", content: '90,000,000 VND'),
        renderLineContent(label: "Kỳ hạn", content: '3 năm'),
        renderLineContent(label: "Lãi suất", content: "10%"),
        renderLineContent(label: "Ngày đến hạn", content: "20/02/2024"),
        renderLineContent(label: "Dư nợ hiện tại", content: '90,000,000 VND'),
        renderLineContent(
            label: "Lãi phải trả (kỳ gần nhất)", content: '9,000,000 VND'),
        renderLineContent(
            label: "Mở tại CN/PGD", content: "PGD Quận Cầu Giấy", line: false),
      ],
    );
  }

  fDAccCust() {
    return Column(
      children: [
        renderLineContent(label: "Số tiền gốc", content: '100,000,000 VND'),
        renderLineContent(label: "Số hợp đồng tiền gửi", content: '0693402'),
        renderLineContent(label: "Đơn vị", content: '13,235,000 VND'),
        renderLineContent(label: "Kỳ hạn", content: '3 năm'),
        renderLineContent(label: "Lãi suất", content: "10%"),
        renderLineContent(label: "Ngày mở", content: "20/09/2022"),
        renderLineContent(label: "Ngày hết hạn", content: "20/12/2022"),
        renderLineContent(label: "Lãi tạm tính", content: '100,000 VND'),
        renderLineContent(
            label: "Mở tại CN/PGD", content: "PGD Quận Cầu Giấy", line: false),
      ],
    );
  }

  renderListItem() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: primaryColor),
        color: Colors.blue.shade50,
      ),
      child: (isLoading)
          ? const LoadingCircle()
          : (dDAccountStatmentResponse.list != null &&
                  dDAccountStatmentResponse.list!.isNotEmpty)
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      for (DDAccountStatment dDAccountStatment
                          in listDDAcountStatment)
                        Column(
                          children: [
                            renderItem(dDAccountStatment),
                            if (listDDAcountStatment.last != dDAccountStatment)
                              const Divider(
                                thickness: 1,
                              )
                          ],
                        ),
                    ],
                  ),
                )
              : (_isLoading)
                  ? const LoadingCircle()
                  : const Text("Không tìm thấy bản ghi"),
    );
  }

  renderItem(DDAccountStatment dDAccountStatment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (contextDialog) => Dialog(
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      translation(context)!.detailKey,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    IconButton(
                                      splashRadius: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        Navigator.pop(contextDialog);
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                renderInforDialog(dDAccountStatment)
                              ],
                            ),
                          ),
                        ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dDAccountStatment.txdate} ${dDAccountStatment.txtime}',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          '${translation(context)!.codeKey}: ${dDAccountStatment.txnum}'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (dDAccountStatment.dramt != 0)
                        Text(
                          '-${convert(dDAccountStatment.dramt)}',
                          style: const TextStyle(color: secondaryColor),
                        ),
                      if (dDAccountStatment.cramt != 0)
                        Text(
                          '+${convert(dDAccountStatment.cramt)}',
                          style: const TextStyle(color: secondaryColor),
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // if (widget.type == 'Tài khoản thanh toán')
                      // InkWell(
                      //   onTap: () {
                      //     showModalBottomSheet<void>(
                      //         backgroundColor: Colors.transparent,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(16.0),
                      //         ),
                      //         isDismissible: true,
                      //         isScrollControlled: true,
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return Padding(
                      //             padding: EdgeInsets.only(
                      //                 bottom: MediaQuery.of(context)
                      //                     .viewInsets
                      //                     .bottom),
                      //             child: Container(
                      //               decoration: const BoxDecoration(
                      //                 borderRadius: BorderRadius.vertical(
                      //                     top: Radius.circular(10)),
                      //                 color: Colors.white,
                      //               ),
                      //               child: Wrap(
                      //                 children: [
                      //                   Container(
                      //                     height: 3.5,
                      //                     width: 30,
                      //                     margin: EdgeInsets.symmetric(
                      //                         vertical: 8,
                      //                         horizontal:
                      //                             (MediaQuery.of(context)
                      //                                     .size
                      //                                     .width *
                      //                                 0.45)),
                      //                     decoration: const BoxDecoration(
                      //                         color: Colors.grey,
                      //                         borderRadius: BorderRadius.all(
                      //                             Radius.circular(20))),
                      //                   ),
                      //                   ConstrainedBox(
                      //                     constraints: BoxConstraints(
                      //                       minHeight: MediaQuery.of(context)
                      //                               .size
                      //                               .height *
                      //                           0.1,
                      //                       maxHeight: MediaQuery.of(context)
                      //                               .size
                      //                               .height *
                      //                           0.45,
                      //                     ),
                      //                     child: Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       mainAxisSize: MainAxisSize.min,
                      //                       children: [
                      //                         InkWell(
                      //                           onTap: () {
                      //                             Navigator.pop(context);
                      //                             saveFileFromAPI(
                      //                               context,
                      //                               fileName:
                      //                                   "Phieu_hoach_toan${dDAccountStatment.acctno}",
                      //                               requestBody: {},
                      //                               url:
                      //                                   "/api/custacc/download-so-phu",
                      //                             );
                      //                           },
                      //                           child: Container(
                      //                               width: double.infinity,
                      //                               padding: const EdgeInsets
                      //                                       .symmetric(
                      //                                   horizontal: 20,
                      //                                   vertical: 18),
                      //                               decoration: const BoxDecoration(
                      //                                   border: Border(
                      //                                       bottom: BorderSide(
                      //                                           width: 1,
                      //                                           color:
                      //                                               coloreWhite_EAEBEC))),
                      //                               child: const Text(
                      //                                   "Phiếu hoạch toán")),
                      //                         ),
                      //                         InkWell(
                      //                           onTap: () {
                      //                             Navigator.pop(context);
                      //                             // widget.handleStatusAccessCode!(item);
                      //                           },
                      //                           child: Container(
                      //                               padding: const EdgeInsets
                      //                                       .symmetric(
                      //                                   horizontal: 20,
                      //                                   vertical: 18),
                      //                               decoration: const BoxDecoration(
                      //                                   border: Border(
                      //                                       bottom: BorderSide(
                      //                                           width: 1,
                      //                                           color:
                      //                                               coloreWhite_EAEBEC))),
                      //                               child: const Text(
                      //                                   "Ủy nhiệm chi")),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           );
                      //         });
                      //   },
                      //   child: const Padding(
                      //     padding: EdgeInsets.only(left: 20.0),
                      //     child: SizedBox(
                      //       child: Icon(
                      //         Icons.print,
                      //         color: primaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  renderInforDialog(DDAccountStatment dDAccountStatment) {
    return Column(
      children: [
        renderLineContent(
            label: translation(context)!.day_tradingKey,
            content: dDAccountStatment.txdate,
            vertical: 6.0),
        renderLineContent(
            label: translation(context)!.codeKey,
            content: dDAccountStatment.txnum,
            vertical: 6.0),
        if (dDAccountStatment.dramt != 0)
          renderLineContent(
              label: translation(context)!.debitKey,
              content: convert(dDAccountStatment.dramt),
              vertical: 6.0),
        if (dDAccountStatment.cramt != 0)
          renderLineContent(
              label: translation(context)!.creditKey,
              content: convert(dDAccountStatment.cramt),
              vertical: 6.0),
        renderLineContent(
            label: translation(context)!.balanceKey,
            content: convert(dDAccountStatment.clbal),
            vertical: 6.0),
        renderLineContent(
            label: translation(context)!.explainKey,
            content: dDAccountStatment.txdesc,
            line: false,
            vertical: 10.0),
      ],
    );
  }

  renderButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          saveFileFromAPI(
            context,
            fileName: "So_phu_${controllerAccount.text.trim()}",
            requestBody: bodyrequest,
            url: "/api/custacc/download-so-phu",
          );
        },
        child: Text(
          translation(context)!.export_fileKey,
          style: const TextStyle(
              color: primaryColor,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  renderLineContent(
      {String? label, dynamic content, bool line = true, double? vertical}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: vertical ?? 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label!),
              content != null
                  ? Expanded(
                      child: Text(
                      content,
                      textAlign: TextAlign.right,
                    ))
                  : const Text('_')
            ],
          ),
        ),
        if (line)
          const Divider(
            thickness: 1.0,
          ),
      ],
    );
  }
}
