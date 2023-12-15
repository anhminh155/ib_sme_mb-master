// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/danh_sach_giao_dich.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/result_screen.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;
import '../../../network/services/transmanagement_service/statement_trans_service.dart';
import '../../../provider/providers.dart';
import '../../../utils/formatDatetime.dart';

class ThongTinBangKeChoDuyet extends StatefulWidget {
  final StmTransferResponse tran;
  final TDDAcount ddAccount;
  const ThongTinBangKeChoDuyet(
      {super.key, required this.tran, required this.ddAccount});

  @override
  State<ThongTinBangKeChoDuyet> createState() => _ThongTinBangKeChoDuyetState();
}

class _ThongTinBangKeChoDuyetState extends State<ThongTinBangKeChoDuyet> {
  bool _isLoading = false;
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
          title: const Text('Chi tiết giao dịch bảng kê'),
          backgroundColor: primaryColor,
        ),
        body: Stack(
          children: [renderBody(), if (_isLoading) const LoadingCircle()],
        ));
  }

  renderBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Thông tin tài khoản trích nợ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          renderCard(
            contentZone1(),
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Thông tin thụ hưởng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          renderCard(
            contentZone2(context),
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Thông tin giao dịch',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          renderCard(
            contentZone3(),
          ),
          const SizedBox(
            height: 16.0,
          ),
          renderCard(
            contentZone4(),
          ),
          const SizedBox(
            height: 16.0,
          ),
          renderButtons()
        ],
      ),
    );
  }

  renderButtons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [renderRefuseBtn(), renderConfirmBtn()]);
  }

  Widget renderConfirmBtn() {
    _checkRoleConfirmTrans();
    if (!_checkRoleConfirmTrans()) {
      return Container();
    }

    return Consumer<OtpProvider>(builder: (context, otpProvider, child) {
      var inituser = otpProvider.inituser;
      return ButtonWidget(
          backgroundColor: primaryColor,
          onPressed: () async {
            if (inituser != null) {
              var transCode = await _checkLimit();
              OtpFunction().showDialogEnterPinOTP(
                  context: context,
                  transCode: transCode,
                  callBack: (otp, transCode) =>
                      _onConfirm(context, otp, transCode));
            } else {
              showToast(
                  context: context,
                  msg: 'Quý khách chưa đăng ký smartOTP',
                  color: Colors.red,
                  icon: const Icon(Icons.error));
            }
          },
          text: 'Duyệt lệnh',
          colorText: Colors.white,
          haveBorder: false,
          widthButton: MediaQuery.of(context).size.width * 0.4);
    });
  }

  bool _checkRoleConfirmTrans() {
    final cust = Provider.of<CustInfoProvider>(context, listen: false).cust;
    final position = cust?.position;
    final roleApproved = cust?.roles?.approve;
    final roleType = cust?.roles?.type;
    if (roleType == CompanyTypeEnum.MOHINHCAP2.value &&
        roleApproved == 1 &&
        (position == PositionEnum.DUYETLENH.value ||
            position == PositionEnum.QUANTRI.value)) {
      return true;
    }
    return false;
  }

  ButtonWidget renderRefuseBtn() {
    return ButtonWidget(
        backgroundColor: Colors.white,
        onPressed: () async {
          await showDiaLogConfirm(
              context: context,
              close: true,
              content: const Text(
                "Quý khách có chắc chắn muốn từ chối lệnh giao dịch này không?",
                textAlign: TextAlign.center,
              ),
              note: "Vui lòng nhập lý do",
              titleButton: "Đồng ý",
              handleContinute: (reason) {
                _refuse(reason);
              });
        },
        text: 'Từ chối',
        colorText: secondaryColor,
        haveBorder: true,
        colorBorder: secondaryColor,
        widthButton: MediaQuery.of(context).size.width * 0.4);
  }

  Future<void> _refuse(String resson) async {
    try {
      setState(() {
        _isLoading = true;
      });
      BaseResponse response = await StatementTransService()
          .refuse(context, widget.tran.code ?? "", resson);
      setState(() {
        _isLoading = false;
      });
      if (response.errorCode == FwError.THANHCONG.value) {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.green,
            icon: const Icon(Icons.check));
        await _updateData();
        Navigator.of(context).pop();
      } else {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _checkLimit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      BaseResponse checkLimitTransLotResponse = await StatementTransService()
          .checkLimitTransLot(context, widget.tran.code!,
              widget.tran.amount ?? '', widget.tran.fee ?? '', '');
      setState(() {
        _isLoading = false;
      });
      if (checkLimitTransLotResponse.errorCode == FwError.THANHCONG.value) {
        return checkLimitTransLotResponse.data;
      }
      return '';
    } catch (ex) {
      dev.log(ex.toString());
      return '';
    }
  }

  Future<void> _onConfirm(BuildContext context, otp, transCode) async {
    try {
      setState(() {
        _isLoading = true;
      });
      BaseResponse duyetLenhResponse = await StatementTransService()
          .confirm(transCode, otp, widget.tran.code ?? "");
      setState(() {
        _isLoading = false;
      });
      if (duyetLenhResponse.errorCode == FwError.THANHCONG.value) {
        var data = StmTransferResponse.fromJson(duyetLenhResponse.data);
        showToast(
            context: context,
            msg: duyetLenhResponse.errorMessage!,
            color: Colors.green,
            icon: const Icon(Icons.check));
        await _updateData();

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransLotResultScreen(
                tran: data,
              ),
            )).whenComplete(() => Navigator.pop(context));
      } else {
        showToast(
            context: context,
            msg: duyetLenhResponse.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  renderCard(renderContent) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(width: 2, color: secondaryColor),
        ),
        child: renderContent);
  }

  contentZone1() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản nguồn", value: widget.tran.sendAccount),
        renderLineInfo(
            label: "Số dư",
            value: Currency.formatCurrency(widget.ddAccount.curbalance),
            line: false),
      ],
    );
  }

  contentZone2(context) {
    return Column(
      children: [
        renderLineInfo(
          label: "Tổng số giao dịch",
          value: widget.tran.total ?? "",
        ),
        renderLineInfo(label: "Trạng thái bảng ghi", value: "Bảng kê hợp lệ"),
        const SizedBox(
          height: 8.0,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListTrans(
                              tran: widget.tran,
                            )));
              },
              child: const Text(
                "Xem danh sách giao dịch",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: primaryColor,
                    decoration: TextDecoration.underline),
              )),
        ),
      ],
    );
  }

  contentZone3() {
    return Column(
      children: [
        renderLineInfo(
            label: "Mã giao dịch", value: widget.tran.transLotCode ?? ""),
        renderLineInfo(
          label: "Tổng tiền",
          value:
              '${Currency.formatCurrency(int.tryParse(widget.tran.amount ?? '0') ?? 0)} \n ${Currency.numberToWords(int.tryParse(widget.tran.amount ?? '0') ?? 0)}',
          // renderReadNumber(tran.amount!),
        ),
        renderLineInfo(
          label: "Tổng phí",
          value:
              '${Currency.formatCurrency(_getTotalFee())} \n ${Currency.numberToWords(_getTotalFee())}',
        ),
        renderLineInfo(
            label: "Phí giao dịch",
            value: TransactionFeeType.getNameFeeType(widget.tran.feeType)),
        renderLineInfo(
            label: "Mục đích thanh toán", value: widget.tran.paymentDes),
        renderLineInfo(
            label: "Thời gian lập",
            value: convertDateTimeFormat(widget.tran.createdAt ?? "")),
        renderLineInfo(
            label: "Nội dung thanh toán",
            value: widget.tran.content ?? "",
            line: false),
      ],
    );
  }

  int _getTotalFee() {
    int fee = int.tryParse(widget.tran.fee ?? '0') ?? 0;
    int vat = int.tryParse(widget.tran.vat ?? '0') ?? 0;
    return fee + vat;
  }

  renderReadNumber(String amount) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
          Currency.numberToWords(int.tryParse(widget.tran.amount ?? "0") ?? 0)),
    );
  }

  contentZone4() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "Phương thức xác thực",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Smart OTP",
            textAlign: TextAlign.end,
          ),
        ),
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
                value ?? "",
                style: TextStyle(
                    color: value.toString().compareTo('Bảng kê hợp lệ') == 0
                        ? Colors.green
                        : null),
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

  Future<void> _updateData() async {
    var request = Provider.of<TransLotProvider>(context, listen: false).request;
    if (request != null) {
      try {
        setState(() {
          _isLoading = true;
        });
        BasePagingResponse response =
            await StatementTransService().searchStmTrans(context, request);
        setState(() {
          _isLoading = false;
        });
        if (response.errorCode == FwError.THANHCONG.value) {
          var newValue = response.data?.content!
              .map((e) => StmTransferResponse.fromJson(e))
              .toList();
          Provider.of<TransLotProvider>(context, listen: false).setData(
              items: newValue, totalTrans: response.data!.totalElements);
          Provider.of<CountTransProvider>(context, listen: false)
              .setCountLotpending(response.data!.totalElements);
        }
      } catch (_) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
