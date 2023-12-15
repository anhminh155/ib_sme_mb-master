// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/ddacount_detail_service.dart';
import 'package:ib_sme_mb_view/network/services/fee_service.dart';
import 'package:ib_sme_mb_view/network/services/get_code_gen_otp_service.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/count_tran_service.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_cho_duyet/ket_qua_duyet.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_giao_dich_thong_thuong/quan_ly_giao_dich_thong_thuong.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/button.dart';
import '../../../enum/enum.dart';
import '../../../network/services/transmanagement_service/get_trans_schedule_detail.dart';
import '../../../network/services/transmanagement_service/update_trans_service.dart';
import '../../../utils/theme.dart';

class ThongTinGiaoDichChoDuyet extends StatefulWidget {
  final String? code;
  final int? value;
  final String? sendAccount;
  final RolesAcc? rolesAcc;
  const ThongTinGiaoDichChoDuyet(
      {super.key, this.code, this.value, this.sendAccount, this.rolesAcc});

  @override
  State<ThongTinGiaoDichChoDuyet> createState() =>
      _ThongTinGiaoDichChoDuyetState();
}

class _ThongTinGiaoDichChoDuyetState extends State<ThongTinGiaoDichChoDuyet>
    with BaseComponent {
  final convert = NumberFormat("#,### VND", "en_US");
  dynamic transSchedulesDetails;
  String? code;
  dynamic tranTemp;
  DDAcount ddAcount = DDAcount();
  FeeModel feeModel = FeeModel();
  int totalFee = 0;
  bool checkLimit = false;
  bool _isLoading = true;
  String message = '';
  bool checkButton = true;

  getDDAcountDetail() async {
    BaseResponse response = await DDACountDetailService()
        .getDDAcountDetail({"acc": widget.sendAccount!});
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        ddAcount = DDAcount.fromJson(response.data);
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getFee() async {
    BaseResponse response = await FeeService().getFee({
      "product": TransType.getProductTypeByString(transSchedulesDetails.type!),
      "amount": transSchedulesDetails.amount
    });
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        feeModel = FeeModel.fromJson(response.data);
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getTransSchedule() async {
    BaseResponse response = await GetTransactionScheduleService()
        .getTransDetail('/api/transschedule/${widget.code}', null);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        dataResponse = TransScheduleModel.fromJson(response.data);
        transSchedulesDetails = dataResponse;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getTrans() async {
    BaseResponse response = await GetTransactionScheduleService()
        .getTransDetail('/api/tran/${widget.code}', null);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        dataResponse = Tran.fromJson(response.data);
        transSchedulesDetails = dataResponse;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  cancelTransPendingApproval(requestBody, context) async {
    BaseResponse response = await UpdateTransactionService()
        .canelTransPendingApproval(requestBody, widget.value);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      Navigator.pop(context, 'Thành công');
    } else {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getTransCode(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.DUYETGIAODICH, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    } else {
      return;
    }
  }

  accessTransPendingApproval(requestBody, context) async {
    setState(() {
      isLoading = true;
    });
    BaseResponse response = await UpdateTransactionService()
        .accessTransPendingApproval(requestBody, widget.value);
    if (response.errorCode == FwError.THANHCONG.value) {
      if (widget.value == 1) {
        tranTemp = Tran.fromJson(response.data);
      } else if (widget.value == 2) {
        tranTemp = TransScheduleModel.fromJson(response.data);
      }
      setState(() {
        isLoading = false;
        getCountTrans();
      });
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));

      final result = await Navigator.push(
        context,
        (MaterialPageRoute(
          builder: (context) =>
              KetQuaDuyetWidget(transTemp: tranTemp, value: widget.value!),
        )),
      );
      if (result.toString() == 'Thành công') {
        Navigator.pop(context, result);
      }
    } else if (response.errorCode == FwError.KHONGTHANHCONG.value) {
      setState(() {
        isLoading = false;
        getCountTrans();
      });
      showDialogError(
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: response.errorMessage.toString(),
            style: const TextStyle(
              color: colorBlack_20262C,
              fontSize: 14,
              height: 1.5,
            ),
            children: <TextSpan>[
              const TextSpan(
                  text:
                      '\n\nĐể kiểm tra lại thông tin duyệt lệnh, Quý khách truy cập chức năng ',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black45)),
              TextSpan(
                  text: 'Quản lý giao dịch thông thường',
                  style: const TextStyle(
                      color: primaryColor, fontStyle: FontStyle.italic),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const QuanLyGiaoDichThongThuong()),
                          (route) => route.isFirst);
                    }),
            ],
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  Future<void> getCountTrans() async {
    BaseResponse<CountTrans> response =
        await CountTransSeervice().getCountTrans();
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        if (response.data != null) {
          Provider.of<CountTransProvider>(context, listen: false)
              .saveCountTrans(CountTrans.fromJson(response.data));
        }
      });
    }
  }

  getCheckLimitTransDuyet(transChedulesDetail) async {
    setState(() {
      isLoading = true;
    });
    BaseResponse response =
        await UpdateTransactionService().getCheckLimitTransDuyet({
      "code": transSchedulesDetails.code,
      "fee": feeModel.fee,
      "vat": feeModel.vat,
    }, widget.value);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        checkLimit = true;
        message = response.errorMessage.toString();
        isLoading = false;
      });
    } else {
      setState(() {
        checkLimit = false;
        message = response.errorMessage.toString();
        isLoading = false;
      });
    }
  }

  _initData() async {
    bool check = true;
    await getDDAcountDetail();
    if (widget.value == 1) {
      await getTrans();
    } else if (widget.value == 2) {
      await getTransSchedule();
    }
    check = await _checkButtonAccessTransSchedules(dataResponse);
    await getFee();

    totalFee = await _totalFee();
    setState(() {
      isLoading = false;
      _isLoading = false;
      checkButton = check;
    });
  }

  _checkButtonAccessTransSchedules(data) async {
    DateTime dateNow = DateFormat('dd/MM/yyyy')
        .parse(convertDateFormat(DateTime.now().toString()));
    if (widget.rolesAcc?.approve == YesNoEnum.Y.value &&
        widget.rolesAcc?.position != PositionEnum.LAPLENH.value) {
      if (widget.value == 2) {
        if (data.schedules == YesNoEnum.N.value) {
          DateTime schedulesFuture = DateFormat('dd/MM/yyyy')
              .parse(convertDateFormat(data.schedulesFuture));

          if (schedulesFuture.isAfter(dateNow)) {
            return true;
          }
          return false;
        } else if (data.schedules == YesNoEnum.Y.value) {
          DateTime schedulesFromDate = DateFormat('dd/MM/yyyy')
              .parse(convertDateFormat(data.schedulesFromDate));
          if (schedulesFromDate.isAfter(dateNow) ||
              schedulesFromDate == dateNow) {
            return true;
          }
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  _totalFee() async {
    int fee = int.parse(feeModel.fee ?? '0');
    int vat = int.parse(feeModel.vat ?? '0');
    return fee + vat;
  }

  _accessTransDuyet() async {
    var register = Provider.of<OtpProvider>(context, listen: false).isRegister;
    if (register) {
      var codeGenOTP = await getTransCode(widget.code, context);
      OtpFunction().showDialogEnterPinOTP(
          context: context,
          transCode: codeGenOTP,
          callBack: (String otp, String code) async {
            var requestBody = {
              'otp': otp,
              'code': code,
              'data': {
                'code': widget.code,
                'fee': feeModel.fee,
                'vat': feeModel.vat
              }
            };
            await accessTransPendingApproval(requestBody, context);
          });
    } else {
      showToast(
        context: context,
        msg: 'Vui lòng đăng ký Smart-OTP để thực hiện chức năng này',
        color: Colors.orange,
      );
    }
  }

  @override
  void initState() {
    _initData();
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
        title: const Text('Chi tiết giao dịch chờ duyệt'),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          if (!_isLoading) _renderBody(),
          if (isLoading) const LoadingCircle()
        ],
      ),
    );
  }

  _renderBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          renderBody(
            contentZone1(),
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
          renderBody(
            contentZone3(),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (widget.rolesAcc?.position != PositionEnum.LAPLENH.value &&
                widget.rolesAcc?.approve == YesNoEnum.Y.value)
              ButtonWidget(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await showDiaLogConfirm(
                        context: context,
                        content: const Text(
                          "Quý khách có chắc chắn muốn từ chối lệnh giao dịch này không?",
                          textAlign: TextAlign.center,
                        ),
                        note: "Vui lòng nhập lý do",
                        titleButton: "Đồng ý",
                        handleContinute: (String reason) async {
                          var requestBody = {
                            "code": widget.code,
                            "reason": reason
                          };
                          await cancelTransPendingApproval(
                              requestBody, context);
                        });
                  },
                  text: 'Từ chối',
                  colorText: secondaryColor,
                  haveBorder: true,
                  colorBorder: secondaryColor,
                  widthButton: checkButton
                      ? MediaQuery.of(context).size.width * 0.4
                      : MediaQuery.of(context).size.width - 32),
            if (checkButton)
              ButtonWidget(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    await getCheckLimitTransDuyet(transSchedulesDetails);
                    if (checkLimit) {
                      await _accessTransDuyet();
                    } else {
                      showDiaLogConfirm(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              message,
                              style: const TextStyle(height: 1.6),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          context: context);
                    }
                  },
                  text: 'Duyệt lệnh',
                  colorText: Colors.white,
                  haveBorder: false,
                  widthButton: MediaQuery.of(context).size.width * 0.4),
          ]),
        ],
      ),
    );
  }

  renderBody(renderContent) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
            label: "Tài khoản nguồn",
            value: transSchedulesDetails.sendAccount ?? ''),
        renderLineInfo(
            label: "Số dư khả dụng",
            value: convert.format(ddAcount.curbalance ?? 0)),
        renderLineInfo(
            label: "Loại giao dịch",
            value: TransType.getNameByStringKey(transSchedulesDetails.type!),
            line: false),
      ],
    );
  }

  contentZone2() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản thụ hưởng",
            value: transSchedulesDetails.receiveAccount ?? ''),
        renderLineInfo(
            label: "Tên người thụ hưởng",
            value: transSchedulesDetails.receiveName ?? ''),
        renderLineInfo(
            label: "Ngân hàng thụ hưởng",
            value: transSchedulesDetails.receiveBank ?? ''),
        renderLineInfo(
            label: "Số tiền giao dịch",
            value:
                '${Currency.formatCurrency(double.tryParse(transSchedulesDetails.amount.toString()))}\n${Currency.numberToWords(int.tryParse(transSchedulesDetails.amount!) ?? 0)}'),
        renderLineInfo(
            label: "Số tiền phí",
            value:
                Currency.formatCurrency(double.tryParse(totalFee.toString()))),
        renderLineInfo(
            label: "Phí giao dịch",
            value: TransactionFeeType.getNameFeeType(
                transSchedulesDetails.feeType)),
        renderLineInfo(
            label: "User lập lệnh",
            value: transSchedulesDetails.username ?? ''),
        renderLineInfo(
            label: "Thời gian lập",
            value: convertDateFormat(transSchedulesDetails.createdAt)),
        if (widget.value == 2)
          renderLineInfo(
              label: 'Ngày hiệu lực',
              value: convertDateFormat(transSchedulesDetails.schedules == 0
                  ? transSchedulesDetails.schedulesFuture
                  : transSchedulesDetails.schedulesFromDate)),
        renderLineInfo(
            label: "Nội dung giao dịch", value: transSchedulesDetails.content),
        renderLineInfo(
            label: "Mã giao dịch",
            value: transSchedulesDetails.code,
            line: false)
      ],
    );
  }

  contentZone3() {
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
                value ?? '',
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

  showDialogError({Widget? content}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext contextDialog) {
        return Dialog(
          shadowColor: Colors.black,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo1.svg',
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Thông báo",
                        style: TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(contextDialog);
                          Navigator.pop(context, "Thành công");
                        },
                        child: const Icon(
                          Icons.close,
                          size: 22,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: content,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
