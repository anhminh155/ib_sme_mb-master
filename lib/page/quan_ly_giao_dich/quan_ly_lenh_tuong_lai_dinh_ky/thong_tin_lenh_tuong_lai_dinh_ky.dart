// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/transaction_service.dart';
import 'package:ib_sme_mb_view/provider/custInfo_provider.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
import 'package:intl/intl.dart';
import '../../../common/dialog_confirm.dart';
import '../../../common/show_toast.dart';
import '../../../model/models.dart';
import '../../../network/services/transmanagement_service/download_file_service.dart';
import '../../../network/services/transmanagement_service/get_trans_schedule_detail.dart';
import '../../../network/services/transmanagement_service/update_trans_service.dart';
import '../../../utils/theme.dart';
import '../getcolor_status.dart';
import 'package:provider/provider.dart';

class ThongTinLenhTuongLaiDinhKy extends StatefulWidget {
  final String maGiaoDich;
  const ThongTinLenhTuongLaiDinhKy({super.key, required this.maGiaoDich});

  @override
  State<ThongTinLenhTuongLaiDinhKy> createState() =>
      _ThongTinLenhTuongLaiDinhKyState();
}

class _ThongTinLenhTuongLaiDinhKyState extends State<ThongTinLenhTuongLaiDinhKy>
    with BaseComponent {
  final convert = NumberFormat("#,### VND", "en_US");
  String? rolesCompany;
  Cust? cust;
  bool _isLoading = true;
  bool isCheckResend = false;
  bool isCheckCancel = false;
  TransSchedulesDetailsModel transSchedulesDetailsModel =
      TransSchedulesDetailsModel();
  @override
  void initState() {
    super.initState();
    cust = Provider.of<CustInfoProvider>(context, listen: false).item;
    rolesCompany = cust!.roles?.type;
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initData() async {
    await getTransScheduleDetail();
    if (transSchedulesDetailsModel.paymentStatus ==
        StatusPaymentTrans.LOI.value.toString()) {
      isCheckResend = checkResend();
    }

    if (transSchedulesDetailsModel.paymentStatus ==
        StatusPaymentTrans.CHOXULY.value.toString()) {
      isCheckCancel = checkCancel();
    }
  }

  getTransScheduleDetail() async {
    BaseResponse response = await GetTransactionScheduleService()
        .getTransDetail('/api/transschedulesdetail/detail', widget.maGiaoDich);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        dataResponse = TransSchedulesDetailsModel.fromJson(response.data);
        transSchedulesDetailsModel = dataResponse;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }

    setState(() {
      isLoading = false;
      _isLoading = false;
    });
  }

  cancelTrans(TransSchedulesDetailsModel trans, context) async {
    BaseResponse response =
        await UpdateTransactionService().cancelTransSchedule(trans);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      Navigator.pop(context, 'Thành công');
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  resendTrans(requestBody) async {
    BaseResponse response =
        await UpdateTransactionService().resendTrans(requestBody);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        isLoading = false;
      });
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      Navigator.pop(context, 'Thành công');
    } else if (mounted) {
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

  checkLimitTrans() async {
    setState(() {
      isLoading = true;
    });
    CheckLimitTransRequest request = CheckLimitTransRequest(
        amount: Currency.removeFormatNumber(
            transSchedulesDetailsModel.transSchedule?.amount ?? ''),
        fee: transSchedulesDetailsModel.transSchedule?.fee ?? '',
        type: transSchedulesDetailsModel.transSchedule?.type ?? '',
        vat: transSchedulesDetailsModel.transSchedule?.vat ?? '');
    BaseResponse limitResponse =
        await Transaction_Service().checkLimitTrans(request);
    if (limitResponse.errorCode == FwError.THANHCONG.value && mounted) {
      BaseResponse transCodeResponse = await Transaction_Service().getTransCode(
          transSchedulesDetailsModel.transSchedule?.type ?? '', context);
      if (transCodeResponse.errorCode == FwError.THANHCONG.value) {
        OtpFunction().showDialogEnterPinOTP(
            context: context,
            transCode: transCodeResponse.data,
            callBack: (String otp, String code) async {
              var requestBody = {
                'otp': otp,
                'code': code,
                'data': transSchedulesDetailsModel.code
              };
              await resendTrans(requestBody);
            });
      } else if (mounted) {
        setState(() {
          isLoading = false;
        });
        showToast(
            context: context,
            msg: limitResponse.errorMessage!,
            icon: const Icon(Icons.error),
            color: Colors.red);
      }
    } else if (mounted) {
      setState(() {
        isLoading = false;
      });
      showToast(
          context: context,
          msg: limitResponse.errorMessage!,
          icon: const Icon(Icons.error),
          color: Colors.red);
    }
  }

  //core cũ: 114 core mới: 0031
  checkResend() {
    if (transSchedulesDetailsModel.paymentStatus ==
            StatusPaymentTrans.LOI.value.toString() &&
        transSchedulesDetailsModel.resCode == '114' &&
        transSchedulesDetailsModel.repayStatus !=
            YesNoEnum.Y.value.toString()) {
      if (cust!.position == PositionEnum.QUANTRI.value) {
        return true;
      } else if (cust!.position == PositionEnum.LAPLENH.value &&
          cust!.id == transSchedulesDetailsModel.createdByCust?.id &&
          rolesCompany == CompanyTypeEnum.MOHINHCAP1.value &&
          cust!.roles?.tran == YesNoEnum.Y.value) {
        return true;
      } else {
        if (cust!.position == PositionEnum.DUYETLENH.value &&
            cust!.roles?.approve == YesNoEnum.Y.value) {
          return true;
        }
        return false;
      }
    } else {
      return false;
    }
  }

  checkCancel() {
    if (transSchedulesDetailsModel.paymentStatus ==
        StatusPaymentTrans.CHOXULY.value.toString()) {
      if ((rolesCompany == CompanyTypeEnum.MOHINHCAP1.value &&
              cust!.id == transSchedulesDetailsModel.createdByCust!.id) ||
          (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value &&
              cust!.position != PositionEnum.LAPLENH.value)) {
        return true;
      }
      return false;
    }
    return false;
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
        title: const Text('Chi tiết giao dịch'),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          if (!_isLoading)
            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                  Row(
                    mainAxisAlignment: (transSchedulesDetailsModel
                                    .paymentStatus! ==
                                StatusPaymentTrans.HUY.value.toString() ||
                            (!isCheckResend &&
                                transSchedulesDetailsModel.paymentStatus ==
                                    StatusPaymentTrans.LOI.value.toString()) ||
                            (!isCheckCancel &&
                                transSchedulesDetailsModel.paymentStatus ==
                                    StatusPaymentTrans.CHOXULY.value
                                        .toString()))
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (transSchedulesDetailsModel.paymentStatus! ==
                          StatusPaymentTrans.THANHCONG.value.toString())
                        renderButtonLoadChungTu(),
                      if (isCheckResend) renderButtonResend(),
                      if (isCheckCancel) renderButtonCancel(),
                      ButtonWidget(
                          backgroundColor: secondaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Về danh sách',
                          colorText: Colors.white,
                          haveBorder: false,
                          widthButton: MediaQuery.of(context).size.width * 0.4)
                    ],
                  ),
                ],
              ),
            ),
          if (isLoading) const LoadingCircle(),
        ],
      ),
    );
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

  contentZone1() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản nguồn",
            value: transSchedulesDetailsModel.transSchedule!.sendAccount!),
        renderLineInfo(
            label: "Loại giao dịch",
            value: TransType.getNameByStringKey(
                transSchedulesDetailsModel.transSchedule!.type!),
            line: false),
      ],
    );
  }

  contentZone2() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản thụ hưởng",
            value: transSchedulesDetailsModel.transSchedule!.receiveAccount!),
        renderLineInfo(
            label: "Tên người thụ hưởng",
            value: transSchedulesDetailsModel.transSchedule!.receiveName!),
        renderLineInfo(
            label: "Ngân hàng thụ hưởng",
            value: transSchedulesDetailsModel.transSchedule!.receiveBank!),
        renderLineInfo(
            label: "Số tiền giao dịch",
            value: convert.format(int.tryParse(
                transSchedulesDetailsModel.transSchedule!.amount.toString()))),
        renderLineInfo(
            label: "Số tiền phí",
            value: convert.format(int.parse(
                    transSchedulesDetailsModel.transSchedule!.fee ?? '0') +
                int.parse(
                    transSchedulesDetailsModel.transSchedule!.vat ?? '0'))),
        renderLineInfo(
            label: "Phí giao dịch",
            value: TransactionFeeType.getNameFeeType(
                transSchedulesDetailsModel.transSchedule!.feeType)),
        renderLineInfo(
            label: "User lập lệnh",
            value: transSchedulesDetailsModel.transSchedule!.username),
        renderLineInfo(
            label: "Ngày lập lệnh",
            value: convertDateFormat(
                transSchedulesDetailsModel.transSchedule?.createdAt,
                time: true)),
        if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
          Column(
            children: [
              renderLineInfo(
                  label: "User duyệt lệnh",
                  value: transSchedulesDetailsModel
                      .transSchedule?.updatedByCust?.code),
              renderLineInfo(
                  label: "Ngày duyệt lệnh",
                  value: convertDateFormat(
                      transSchedulesDetailsModel.transSchedule?.approvedDate,
                      time: true)),
            ],
          ),
        if (transSchedulesDetailsModel.repayOldCode != null)
          renderLineInfo(
              label: "Gửi lại cho",
              value: StatusPaymentTrans.getStringByValue(
                  transSchedulesDetailsModel.repayOldCode!)),
        renderLineInfo(
            label: "Trạng thái",
            value: StatusPaymentTrans.getStringByValue(
                transSchedulesDetailsModel.paymentStatus!)),
        renderLineInfo(
            label: "Nội dung giao dịch",
            value: transSchedulesDetailsModel.transSchedule!.content ?? ''),
        renderLineInfo(
            label: "Mã giao dịch",
            value: transSchedulesDetailsModel.code!,
            line: (transSchedulesDetailsModel.paymentStatus!.compareTo(
                        StatusPaymentTrans.THANHCONG.value.toString()) ==
                    0)
                ? false
                : true),
        if (transSchedulesDetailsModel.paymentStatus!
                .compareTo(StatusPaymentTrans.LOI.value.toString()) ==
            0)
          renderLineInfo(
              label: "Mô tả lỗi",
              value: transSchedulesDetailsModel.reason ?? '',
              line: false),
        if (transSchedulesDetailsModel.paymentStatus!
                .compareTo(StatusPaymentTrans.HUY.value.toString()) ==
            0)
          renderLineInfo(
              label: "Lý do hủy",
              value: transSchedulesDetailsModel.reason ?? '',
              line: false),
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
            SizedBox(
              width: 135,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value ?? '_ _ _ _ _',
                textAlign: TextAlign.end,
                style: (label.toString().compareTo('Trạng thái') == 0)
                    ? TextStyle(color: getColorByValue(value))
                    : null,
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

  renderButtonLoadChungTu() {
    return ButtonWidget(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              isDismissible: true,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Wrap(
                      children: [
                        Container(
                          height: 3.5,
                          width: 30,
                          margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  (MediaQuery.of(context).size.width * 0.45)),
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.1,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.45,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  await saveFileFromAPI(context,
                                      url: '/api/transschedulesdetail/chung-tu',
                                      fileName: 'GDTLDKCT',
                                      requestBody:
                                          transSchedulesDetailsModel.code);
                                },
                                child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: coloreWhite_EAEBEC))),
                                    child: const Text("Phiếu hoạch toán")),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  // handleStatusAccessCode!(item);
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: coloreWhite_EAEBEC))),
                                    child: const Text("Ủy nhiệm chi")),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        text: 'Tải chứng từ',
        colorText: primaryColor,
        haveBorder: true,
        colorBorder: primaryColor,
        widthButton: MediaQuery.of(context).size.width * 0.4);
  }

  renderButtonResend() {
    return ButtonWidget(
        backgroundColor: primaryColor,
        onPressed: () async {
          await checkLimitTrans();
        },
        text: "Gửi lại",
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width * 0.4);
  }

  renderButtonCancel() {
    return ButtonWidget(
        backgroundColor: primaryColor,
        onPressed: () async {
          await showDiaLogConfirm(
            context: context,
            close: true,
            content: const Text(
              "Quý khách có muốn hủy lệnh chuyển tiền trong tương lai này không?",
              textAlign: TextAlign.center,
            ),
            note: "Vui lòng nhập lý do",
            handleContinute: (String? reason) {
              transSchedulesDetailsModel.reason = reason;
              cancelTrans(transSchedulesDetailsModel, context);
            },
          );
        },
        text: "Hủy lệnh",
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width * 0.4);
  }
}
