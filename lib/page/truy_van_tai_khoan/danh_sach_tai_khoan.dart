import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:intl/intl.dart';

import '../../enum/enum.dart';
import '../../model/dd_account_model.dart';
import '../../model/model.dart';
import '../../network/services/cust_acc_service.dart';
import '../../utils/theme.dart';
import 'chi_tiet_tai_khoan.dart';

class DanhSachTaiKhoan extends StatefulWidget {
  final String label;
  final int type;
  const DanhSachTaiKhoan({super.key, required this.type, required this.label});

  @override
  State<DanhSachTaiKhoan> createState() => _DanhSachTaiKhoanState();
}

class _DanhSachTaiKhoanState extends State<DanhSachTaiKhoan>
    with BaseComponent {
  String? lable;
  AccountResponse accountResponse = const AccountResponse();
  @override
  void initState() {
    checkList();
    super.initState();
  }

  checkList() async {
    BaseResponse response;
    if (widget.type == 0) {
      response = await CustAccService().getDDAccCust();
    } else if (widget.type == 1) {
      response = await CustAccService().getFDAccCust();
    } else {
      response = await CustAccService().getLNAccCust();
    }
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        accountResponse = AccountResponse.fromJson(response.data);
        isLoading = !isLoading;
      });
    }
  }

  convert(value) {
    String formattedNumber = NumberFormat('#,##0 VND').format(value);
    return formattedNumber;
  }

  String? getStringLable(int value) {
    String? lable;
    switch (value) {
      case 0:
        lable = translation(context)!.total_available_balanceKey;
        break;
      case 2:
        lable = translation(context)!.total_owed_balanceKey;
        break;
      case 1:
        lable = translation(context)!.total_deposit_balanceKey;
        break;
    }
    return lable;
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
        title: Text(translation(context)!.account_listKey),
        backgroundColor: primaryColor,
      ),
      body: !isLoading ? renderBody() : const LoadingCircle(),
    );
  }

  renderBody() {
    lable = getStringLable(widget.type);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CardLayoutWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${accountResponse.length}"),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lable!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    convert(accountResponse.sum),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Divider(
              color: primaryColor,
              thickness: 1.2,
              height: 1,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 16.0),
                children: [
                  for (DDAcount dDAcount in accountResponse.list ?? [])
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChiTietTaiKhoan(
                              type: widget.type,
                              acctno: dDAcount.acctno,
                              listDDAcount: accountResponse.list,
                              label: widget.label,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          (widget.type == 0)
                              ? renderItemTKTT(dDAcount)
                              : renderItemTKTGTV(dDAcount),
                          if (accountResponse.list?.last != dDAcount)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Divider(
                                color: primaryColor,
                                height: 1.0,
                              ),
                            )
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  renderItemTKTT(DDAcount dDAcount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dDAcount.acctno ?? "---"),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              convert(int.tryParse(dDAcount.balance ?? "0")),
              style: const TextStyle(color: primaryColor),
            ),
          ],
        ),
        const Icon(
          Icons.arrow_circle_right_sharp,
          color: primaryColor,
        )
      ],
    );
  }

  renderItemTKTGTV(DDAcount dDAcount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dDAcount.acctno ?? "---"),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              convert(int.tryParse(dDAcount.balance ?? "0")),
              style: const TextStyle(color: primaryColor),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Text(
              "3 tháng",
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
            ),
          ],
        ),
        const Icon(
          Icons.arrow_circle_right_sharp,
          color: primaryColor,
        )
      ],
    );
  }

  renderRowTKTGTV({required String title, String? value, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
        ),
        Text(
          value ?? "---",
          style: isBold
              ? const TextStyle(
                  color: primaryColor, fontWeight: FontWeight.w600)
              : null,
        )
      ],
    );
  }
}
