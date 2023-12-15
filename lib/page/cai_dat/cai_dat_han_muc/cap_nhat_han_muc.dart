import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/input_moeny.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/network/services/get_code_gen_otp_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../model/model.dart';
import '../../../network/services/trans_limit_cust.dart';
import '../../../provider/providers.dart';

class CapNhatHanMucScreen extends StatefulWidget {
  final String title;
  final String accessCode;
  final int id;
  const CapNhatHanMucScreen(
      {super.key,
      required this.title,
      required this.accessCode,
      required this.id});

  @override
  State<CapNhatHanMucScreen> createState() => _CapNhatHanMucScreenState();
}

class _CapNhatHanMucScreenState extends State<CapNhatHanMucScreen>
    with BaseComponent<TransLimitCust> {
  String lableGiaoDich = "Hạn mức tối đa/giao dịch";
  String lableNgay = "Tổng hạn mức giao dịch/ngày";

  List<Map<String, dynamic>> tableData = [];

  @override
  void initState() {
    getTrainLimitByCust();
    super.initState();
  }

  getLimitCustCodeGenOTP(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.LIMITSETTING, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    } else {
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (Map<String, dynamic> data in tableData) {
      TextEditingController? controller =
          data['controller'] as TextEditingController?;
      if (controller != null) {
        controller.dispose();
      }
    }
  }

  getTrainLimitByCust() async {
    Cust cust = Cust(id: widget.id
        // widget.position == 3 ? widget.idDL : widget.idLL
        );
    BaseResponseDataList response =
        await TransLimitByCustService().getTransLimitByCust(cust);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listResponse = response.data!
            .map((translimitcust) => TransLimitCust.fromJson(translimitcust))
            .toList();
      });
      for (TransLimitCust item in listResponse) {
        var translimit = {
          "id": item.id,
          "maxdaily": item.maxdaily,
          "cust": {"id": widget.id},
          "maxtrans": item.maxtrans,
          "product": item.product,
          "productName": item.productName
        };
        tableData.add(translimit);
      }
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  checkLimitUpdate(requestBody, context) async {
    BaseResponse response =
        await TransLimitByCustService().checkLimitUpdate(requestBody);
    if (response.errorCode == FwError.THANHCONG.value) {
      verifyAndUpdate();
    } else if (response.errorCode == FwError.HANMUCKHONGHOPLE.value) {
      if (response.data != null) {
        setState(() {
          listResponse = response.data!
              .map((translimitcust) => TransLimitCust.fromJson(translimitcust))
              .toList();
        });
        for (TransLimitCust item in listResponse) {
          showToast(
              context: context,
              msg: 'Hạn mức ${item.productName!.toLowerCase()} không hợp lệ',
              color: Colors.red,
              icon: const Icon(Icons.error));
        }
      } else {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  updateTransLimitCust(requestBody, context) async {
    BaseResponse response =
        await TransLimitByCustService().updateTransLimitCust(requestBody);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      Navigator.pop(context, "Thành công");
    } else {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  verifyAndUpdate() async {
    var register = Provider.of<OtpProvider>(context, listen: false).isRegister;
    if (register) {
      final currentUser =
          LoginResponse.fromJson(localStorage.getItem('currentUser'));
      var codeGenOTP =
          await getLimitCustCodeGenOTP(currentUser.username, context);
      // ignore: use_build_context_synchronously
      OtpFunction().showDialogEnterPinOTP(
          context: context,
          transCode: codeGenOTP,
          callBack: (String otp, String code) async {
            var requestBody = {"code": code, "otp": otp, "data": tableData};
            await updateTransLimitCust(requestBody, context);
            // ignore: use_build_context_synchronously
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        title: Text(widget.title),
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: !isLoading
          ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: CardLayoutWidget(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mã truy cập",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.accessCode,
                          style: const TextStyle(
                              color: primaryColor, fontSize: 16),
                        )
                      ],
                    ),
                  )),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Lưu ý: ",
                        style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        " Đơn vị tiền tệ : Việt Nam đồng - VND",
                        style: TextStyle(
                            color: primaryColor, fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(139, 146, 165, 0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          children: [
                            for (Map<String, dynamic> item in tableData)
                              if (tableData.indexOf(item) < 5)
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: tableData.indexOf(item) < 4
                                            ? 20.0
                                            : 0),
                                    child: renderView(
                                        item, tableData.indexOf(item))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(139, 146, 165, 0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            for (Map<String, dynamic> item in tableData)
                              if (tableData.indexOf(item) >= 5)
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: tableData.indexOf(item) <
                                                tableData.length - 1
                                            ? 20.0
                                            : 0),
                                    child: renderView(
                                        item, tableData.indexOf(item))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: ButtonWidget(
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        await checkLimitUpdate(tableData, context);
                      },
                      text: translation(context)!.continueKey,
                      colorText: Colors.white,
                      haveBorder: false,
                      widthButton: double.infinity),
                ),
              ],
            )
          : const LoadingCircle(),
    );
  }

  renderView(item, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (index == 0 || index == 5)
            ? Container(
                width: double.infinity,
                height: 43,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: colorBlue_80ACD5.withOpacity(0.3)),
                child: Text(
                  item['productName'],
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 12, right: 12, bottom: 4.0),
                child: Text(
                  item['productName'],
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 12, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lableGiaoDich,
                style: const TextStyle(color: colorBlack_727374),
              ),
              const SizedBox(
                height: 5.0,
              ),
              InputMoenyWidget(
                onChange: (value) {
                  setState(() {
                    item['maxtrans'] = value;
                  });
                },
                // ignore: prefer_null_aware_operators
                value: item['maxtrans'] == null
                    ? null
                    : item['maxtrans'].toString(),
              )
            ],
          ),
        ),
        if (widget.title.compareTo('Cập nhật hạn mức lập lệnh') == 0)
          const SizedBox(
            height: 12.0,
          ),
        if (widget.title.compareTo('Cập nhật hạn mức lập lệnh') == 0)
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lableNgay,
                  style: const TextStyle(color: colorBlack_727374),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                InputMoenyWidget(
                  onChange: (value) {
                    setState(() {
                      item['maxdaily'] = value;
                    });
                  },
                  value:
                      // ignore: prefer_null_aware_operators
                      item['maxdaily'] == null
                          ? null
                          : item['maxdaily'].toString(),
                )
              ],
            ),
          )
      ],
    );
  }
}
