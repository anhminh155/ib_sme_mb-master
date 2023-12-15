import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
import 'package:provider/provider.dart';
import '../../../provider/providers.dart';
import '../../../utils/theme.dart';
import '../../chuyen_tien/Transactions/transaction_create/transaction_create.dart';
import '../getcolor_status.dart';

class ThongTinLenhTuChoi extends StatelessWidget {
  final RejectTransDetailTTResponse transInfo;

  const ThongTinLenhTuChoi({super.key, required this.transInfo});

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
        title: const Text('Chi tiết lệnh từ chối'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            renderBody(
              contentZone1(context),
            ),
            const SizedBox(
              height: 16.0,
            ),
            renderBody(
              contentZone2(),
            ),
            const SizedBox(
              height: 16.0,
            ),
            renderButton(context)
          ],
        ),
      ),
    );
  }

  renderButton(BuildContext context) {
    final cust = Provider.of<CustInfoProvider>(context, listen: false).cust;
    final position = cust?.position;
    final roleType = cust?.roles?.type;
    final roleTran = cust?.roles?.tran;
    if (transInfo.status == RejectTransStatus.TUCHOI.value &&
        roleType == CompanyTypeEnum.MOHINHCAP2.value &&
        position == PositionEnum.LAPLENH.value &&
        roleTran == 1) {
      return ButtonWidget(
          backgroundColor: primaryColor,
          onPressed: () => _onPressDoTrans(context),
          text: 'Thực hiện lại giao dịch',
          colorText: Colors.white,
          haveBorder: false,
          widthButton: MediaQuery.of(context).size.width);
    } else {
      return Container();
    }
  }

  _onPressDoTrans(BuildContext context) {
    Transaction transaction = Transaction(
        transType: 'MB',
        amount: transInfo.amount ?? "0",
        content: transInfo.content ?? "",
        fee: transInfo.fee ?? "",
        vat: transInfo.vat ?? "",
        sendAccount: transInfo.sendAccount ?? "",
        receiveAccount: transInfo.receiveAccount ?? "",
        receiveName: transInfo.receiveName ?? "",
        type: transInfo.type ?? "",
        feeType: int.parse(transInfo.feeType ?? "0"),
        receiveBank: transInfo.receiveBank ?? "",
        receiveBankCode: transInfo.receiveBankCode ?? "");

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionsCreate(
            tranType: transInfo.type!,
            initTrans: transaction,
          ),
        ));
  }

  renderBody(renderContent) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(width: 2, color: secondaryColor),
        ),
        child: renderContent);
  }

  contentZone1(BuildContext context) {
    return Column(
      children: [
        renderLineInfo(label: "Tài khoản nguồn", value: transInfo.sendAccount),
        renderLineInfo(
            label: "Loại giao dịch",
            value: translation(context)?.trans_typeKey(transInfo.type ?? ""),
            line: false)
      ],
    );
  }

  contentZone2() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản thụ hưởng", value: transInfo.receiveAccount),
        renderLineInfo(
            label: "Tên người thụ hưởng", value: transInfo.receiveName),
        renderLineInfo(
            label: "Ngân hàng thụ hưởng", value: transInfo.receiveBank),
        renderLineInfo(
            label: "Số tiền giao dịch",
            value: Currency.formatCurrency(int.parse(transInfo.amount ?? "0"))),
        renderLineInfo(
            label: "Số tiền phí",
            value: Currency.formatCurrency(int.parse(transInfo.fee ?? "0") +
                int.parse(transInfo.vat ?? "0"))),
        renderLineInfo(
            label: "Phí giao dịch",
            value: TransactionFeeType.getNameFeeType(transInfo.feeType)),
        renderLineInfo(
            label: "User lập lệnh", value: transInfo.createdByCust?["code"]),
        renderLineInfo(
            label: "Thời gian lập",
            value: convertDateTimeFormat(transInfo.createdAt ?? "")),
        renderLineInfo(
            label: "User duyệt lệnh", value: transInfo.approvedBy?["code"]),
        renderLineInfo(
            label: "Thời gian duyệt",
            value: convertDateTimeFormat(transInfo.approvedDate ?? "")),
        renderLineInfo(label: "Nội dung giao dịch", value: transInfo.content),
        renderLineInfo(
            label: "Trạng thái",
            value: RejectTransStatus.getStringByValue(transInfo.status)),
        renderLineInfo(label: "Ý kiến người duyệt", value: transInfo.reason),
        renderLineInfo(
            label: "Mã giao dịch", value: transInfo.code, line: false),
      ],
    );
  }

  renderLineInfo({label, value, bool line = true}) {
    return Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value ?? '',
                style: TextStyle(color: getColorByValue(value ?? "")),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        if (line == true)
          const Divider(
            thickness: 1,
          ),
      ],
    );
  }
}
