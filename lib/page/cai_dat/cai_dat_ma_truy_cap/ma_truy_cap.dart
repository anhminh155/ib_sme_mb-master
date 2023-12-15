import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/label.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/lich_su_chinh_sua_ma_truy_cap.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/ma_truy_cap_detail.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/model_Matruycap/email_model.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/model_Matruycap/trangthai_model.dart';
import 'package:ib_sme_mb_view/network/services/cus_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import '../../../common/badge_rounded_corner.dart';
import '../../../common/dialog_confirm.dart';
import '../../../common/form_input_and_label/text_field.dart';
import '../../../common/loading_circle.dart';
import '../../../common/show_dialog_otp.dart';
import '../../../common/switch_button.dart';
import '../../../network/services/get_code_gen_otp_service.dart';
import 'model_Matruycap/matruycap_model.dart';
import 'model_Matruycap/matruycap_sdt_model.dart';

class MaTruyCapWidget extends StatefulWidget {
  const MaTruyCapWidget({super.key});

  @override
  State<MaTruyCapWidget> createState() => _MaTruyCapWidgetState();
}

class _MaTruyCapWidgetState extends State<MaTruyCapWidget>
    with BaseComponent<Cust> {
  TextEditingController codeController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  bool length = false;
  bool isLoadingUpdate = false;
  List<Cust> listTemp = [];
  @override
  void initState() {
    super.initState();
    getInitPage();
  }

  getInitPage() async {
    await checkLength();
    await searchPaging(1);
    setState(() {
      isLoading = !isLoading;
    });
  }

  searchPaging(int curentPage) async {
    page.curentPage = curentPage;
    page.size = 100;
    Cust cust = Cust();
    BasePagingResponse<Cust> response =
        await CusService().searchPaging(page, cust);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listResponse =
            response.data!.content!.map((cust) => Cust.fromJson(cust)).toList();
      });
      listTemp = listResponse;
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getQuanLyMaTruyCapCode(code, context) async {
    BaseResponse response = await GetCodeGenOTP()
        .getCodeGenOTP(TypeCode.QUANLYMATRUYCAP, code.toString());
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    }
  }

  updateSMSCust(requestBody) async {
    if (!isLoading && mounted) {
      setState(() {
        isLoadingUpdate = true;
      });
    }
    BaseResponse response = await CusService().updateSMSCust(requestBody);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.done));
      await searchPaging(1);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    if (!isLoading && mounted) {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }

  updateNotiCust(requestBody) async {
    if (!isLoading && mounted) {
      setState(() {
        isLoadingUpdate = true;
      });
    }
    BaseResponse response = await CusService().updateNotiCust(requestBody);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.done));
      await searchPaging(1);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    if (!isLoading && mounted) {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }

  updateStatusCust(requestBody, status) async {
    if (!isLoading && mounted) {
      setState(() {
        isLoadingUpdate = true;
      });
    }
    BaseResponse response = BaseResponse();
    if (status == 2) {
      response = await CusService().updateStatusCustLock(requestBody);
    } else if (status == 0) {
      response = await CusService().updateStatusCustUnLock(requestBody);
    } else if (status == 3) {
      response = await CusService().updateStatusCustCancel(requestBody);
    }

    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.done));
      await searchPaging(1);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    if (!isLoading && mounted) {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }

  checkLength() async {
    BaseResponse<dynamic> response = await CusService().checkLength();
    if (response.errorCode == FwError.THANHCONG.value) {
      length = true;
    } else {
      length = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
    telController.dispose();
    emailController.dispose();
    statusController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        title: const Text("Quản lý mã truy cập"),
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        actions: length == true
            ? [
                // if (length)
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MaTruyCapDetailWidget(
                            type: 'create',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 25,
                    ))
              ]
            : null,
      ),
      body: isLoading
          ? const LoadingCircle()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            renderSearch(
                                textController: codeController,
                                label: "Mã truy cập",
                                hintText: "Chọn/Nhập mã truy cập",
                                onChange: (value) {
                                  searchAction(
                                      codeController.text,
                                      telController.text,
                                      emailController.text,
                                      null);
                                },
                                showWidget: AccessCodeBottom(
                                  listCust: listResponse,
                                  value: codeController.text,
                                  handleSelectAccessCode: (String accessCode) {
                                    setState(() {
                                      codeController.text = accessCode;
                                    });
                                    searchAction(
                                        codeController.text,
                                        telController.text,
                                        emailController.text,
                                        null);
                                  },
                                )),
                            renderSearch(
                                textController: telController,
                                label: "Số điện thoại",
                                hintText: "Chọn/Nhập số điện thoại",
                                onChange: (value) {
                                  searchAction(
                                      codeController.text,
                                      telController.text,
                                      emailController.text,
                                      null);
                                },
                                showWidget: NumberPhoneAccessCodeBottom(
                                  listCust: listResponse,
                                  value: telController.text,
                                  handleSelectNumberPhoneAccessCode:
                                      (String numberPhoneAccessCode) {
                                    setState(() {
                                      telController.text =
                                          numberPhoneAccessCode;
                                    });
                                    searchAction(
                                        codeController.text,
                                        telController.text,
                                        emailController.text,
                                        null);
                                  },
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            renderSearch(
                                textController: emailController,
                                label: "Email",
                                hintText: "Chọn/Nhập email",
                                onChange: (value) {
                                  searchAction(
                                      codeController.text,
                                      telController.text,
                                      emailController.text,
                                      null);
                                },
                                showWidget: EmailAccessCodeBottom(
                                  listCust: listResponse,
                                  value: emailController.text,
                                  handleSelectEmailAccessCode:
                                      (String emailAccessCode) {
                                    setState(() {
                                      emailController.text = emailAccessCode;
                                    });
                                    searchAction(
                                        codeController.text,
                                        telController.text,
                                        emailController.text,
                                        null);
                                  },
                                )),
                            renderSearch(
                                textController: statusController,
                                label: "Trạng thái",
                                readOnly: true,
                                hintText: "Chọn trạng thái",
                                showWidget: StatusAccessCodeBottom(
                                  value: statusController.text,
                                  handleStatusAccessCode:
                                      (String statusAccessCode) {
                                    setState(() {
                                      statusController.text = statusAccessCode;
                                    });
                                    searchAction(
                                        codeController.text,
                                        telController.text,
                                        emailController.text,
                                        statusController.text.compareTo(
                                                    'Chờ kích hoạt') ==
                                                0
                                            ? "0"
                                            : statusController.text.compareTo(
                                                        'Hoạt động') ==
                                                    0
                                                ? "1"
                                                : statusController.text
                                                            .compareTo(
                                                                'Khóa') ==
                                                        0
                                                    ? "2"
                                                    : statusController.text
                                                                .compareTo(
                                                                    'Hủy') ==
                                                            0
                                                        ? "3"
                                                        : null);
                                  },
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        if (listTemp.isEmpty)
                          const Center(
                            child: Text("Không tìm thấy"),
                          ),
                        for (Cust cust in listTemp)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: renderContentAccessCode(cust),
                          ),
                      ],
                    ),
                  ),
                ),
                if (isLoadingUpdate) const LoadingCircle()
              ],
            ),
    );
  }

  Widget renderSearch({
    textController,
    label,
    hintText,
    showWidget,
    onChange,
    onSubmitted,
    bool? readOnly,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 20,
      child: LabelWidget(
          label: label,
          colors: colorBlack_727374,
          child: TextFieldWidget(
            onSubmitted: onSubmitted,
            controller: textController,
            onChange: onChange,
            fontSize: 14.0,
            horizontal: 6,
            readOnly: readOnly ?? false,
            onTapInput: (readOnly == true)
                ? () {
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: showWidget,
                          );
                        });
                  }
                : null,
            hintText: hintText,
            suffixIcon: Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: InkWell(
                  onTap: (readOnly == null)
                      ? () {
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
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: showWidget,
                                );
                              });
                        }
                      : null,
                  child: const Icon(Icons.keyboard_arrow_down)),
            ),
          )),
    );
  }

  Widget renderContentAccessCode(Cust cust) {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          rowSpaceBW(
            children: [
              textTitle("Mã truy cập"),
              textContent(cust.code, fontWeight: FontWeight.w600),
            ],
          ),
          rowSpaceBW(
            children: [
              textTitle("Họ và tên"),
              textContent(cust.fullname),
            ],
          ),
          rowSpaceBW(
            children: [
              textTitle("Vai trò"),
              textContent(
                cust.position == PositionEnum.QUANTRI.value
                    ? "Quản lý"
                    : cust.position == PositionEnum.LAPLENH.value
                        ? "Lập lệnh"
                        : cust.position == PositionEnum.DUYETLENH.value
                            ? "Duyệt lệnh"
                            : null,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ],
          ),
          rowSpaceBW(
            children: [
              textTitle("Trạng thái"),
              BadgeRoundedCornersWidget(
                background: cust.status == CustStatusEnum.CHOKICHHOAT.value
                    ? const Color.fromRGBO(253, 166, 1, 0.2)
                    : cust.status == CustStatusEnum.HOATDONG.value
                        ? const Color.fromRGBO(86, 171, 1, 0.2)
                        : cust.status == CustStatusEnum.KHOA.value
                            ? const Color.fromRGBO(213, 1, 1, 0.2)
                            : cust.status == CustStatusEnum.HUY.value
                                ? const Color.fromRGBO(114, 115, 116, 0.2)
                                : null,
                child: textContent(
                  cust.status == CustStatusEnum.CHOKICHHOAT.value
                      ? "Chờ kích hoạt"
                      : cust.status == CustStatusEnum.HOATDONG.value
                          ? "Hoạt động"
                          : cust.status == CustStatusEnum.KHOA.value
                              ? "Khóa"
                              : cust.status == CustStatusEnum.HUY.value
                                  ? "Hủy"
                                  : null,
                  color: cust.status == CustStatusEnum.CHOKICHHOAT.value
                      ? secondaryColor
                      : cust.status == CustStatusEnum.HOATDONG.value
                          ? colorGreen_56AB01
                          : cust.status == CustStatusEnum.KHOA.value
                              ? colorRed_D50101
                              : cust.status == CustStatusEnum.HUY.value
                                  ? colorBlack_727374
                                  : null,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          if (cust.status != CustStatusEnum.HUY.value)
            SwitchButtonWidget(
              title: "SMS Banking",
              callback: (val) {
                showDiaLogConfirm(
                    context: context,
                    content: Text(
                      "Quý khách có chắc chắn ${cust.sms == YesNoEnum.Y.value ? "ngưng" : "mở"} SMS Banking này không?",
                      textAlign: TextAlign.center,
                    ),
                    close: true,
                    titleButton: "Đồng ý",
                    handleContinute: () async {
                      String codeGenOTP =
                          await getQuanLyMaTruyCapCode(cust.id, context);
                      if (mounted) {
                        OtpFunction().showDialogEnterPinOTP(
                            context: context,
                            transCode: codeGenOTP,
                            callBack: (String otp, String code) async {
                              var requestBody = {
                                'otp': otp,
                                'code': code,
                                'data': {
                                  "id": cust.id,
                                  "sms":
                                      cust.sms == YesNoEnum.Y.value ? "0" : "1"
                                }
                              };
                              await updateSMSCust(requestBody);
                            });
                      }
                    });
              },
              status: cust.sms == YesNoEnum.Y.value,
              style: const TextStyle(
                color: colorBlack_727374,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              disabled: !(cust.status == CustStatusEnum.CHOKICHHOAT.value ||
                  cust.status == CustStatusEnum.HOATDONG.value),
            ),
          if (cust.status != CustStatusEnum.HUY.value)
            SwitchButtonWidget(
              title: "Nhận thông báo",
              callback: (val) {
                showDiaLogConfirm(
                    context: context,
                    content: Text(
                      "Quý khách có chắc chắn ${cust.notification == YesNoEnum.Y.value ? "tắt" : "mở"} nhận thông báo biến động số dư này không?",
                      textAlign: TextAlign.center,
                    ),
                    close: true,
                    titleButton: "Đồng ý",
                    handleContinute: () async {
                      String codeGenOTP =
                          await getQuanLyMaTruyCapCode(cust.id, context);
                      if (mounted) {
                        OtpFunction().showDialogEnterPinOTP(
                            context: context,
                            transCode: codeGenOTP,
                            callBack: (String otp, String code) async {
                              var requestBody = {
                                'otp': otp,
                                'code': code,
                                'data': {
                                  "id": cust.id,
                                  "notification":
                                      cust.notification == YesNoEnum.Y.value
                                          ? "0"
                                          : "1"
                                }
                              };
                              await updateNotiCust(requestBody);
                            });
                      }
                    });
              },
              status: cust.notification == YesNoEnum.Y.value,
              style: const TextStyle(
                color: colorBlack_727374,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              disabled: !(cust.status == CustStatusEnum.CHOKICHHOAT.value ||
                  cust.status == CustStatusEnum.HOATDONG.value),
            ),
          if (cust.status != CustStatusEnum.HUY.value)
            Column(
              children: [
                const Divider(
                  thickness: 1,
                  color: colorBlack_EAEBEC,
                ),
                GridView.count(
                  crossAxisCount:
                      cust.status == CustStatusEnum.KHOA.value ? 2 : 3,
                  childAspectRatio: (1 / .2),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if (cust.status == CustStatusEnum.HOATDONG.value ||
                        cust.status == CustStatusEnum.KHOA.value)
                      btnOption(Icons.edit, "Chỉnh sửa", onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaTruyCapDetailWidget(
                              cust: cust,
                              type: 'edit',
                            ),
                          ),
                        );
                      }),
                    if (cust.status == CustStatusEnum.HOATDONG.value)
                      btnOption(Icons.lock, "Khóa mã", onTap: () {
                        showDiaLogConfirm(
                            context: context,
                            content: const Text(
                              "Quý khách có chắc chắn khóa mã truy cập này?",
                              textAlign: TextAlign.center,
                            ),
                            close: true,
                            titleButton: "Đồng ý",
                            handleContinute: () async {
                              String codeGenOTP = await getQuanLyMaTruyCapCode(
                                  cust.id, context);
                              if (mounted) {
                                OtpFunction().showDialogEnterPinOTP(
                                    context: context,
                                    transCode: codeGenOTP,
                                    callBack: (String otp, String code) async {
                                      var requestBody = {
                                        'otp': otp,
                                        'code': code,
                                        'data': {"id": cust.id}
                                      };
                                      await updateStatusCust(requestBody, 2);
                                    });
                              }
                            });
                      }),
                    if (cust.status == CustStatusEnum.KHOA.value)
                      btnOption(Icons.lock_open, "Mở khóa mã", onTap: () {
                        showDiaLogConfirm(
                            context: context,
                            content: const Text(
                              "Quý khách có chắc chắn mở khóa mã truy cập này?",
                              textAlign: TextAlign.center,
                            ),
                            close: true,
                            titleButton: "Đồng ý",
                            handleContinute: () async {
                              String codeGenOTP = await getQuanLyMaTruyCapCode(
                                  cust.id, context);
                              if (mounted) {
                                OtpFunction().showDialogEnterPinOTP(
                                    context: context,
                                    transCode: codeGenOTP,
                                    callBack: (String otp, String code) async {
                                      var requestBody = {
                                        'otp': otp,
                                        'code': code,
                                        'data': {"id": cust.id}
                                      };
                                      await updateStatusCust(requestBody, 0);
                                    });
                              }
                            });
                      }),
                    if (cust.status == CustStatusEnum.KHOA.value)
                      btnOption(Icons.delete_forever, "Hủy mã", onTap: () {
                        showDiaLogConfirm(
                            context: context,
                            content: const Text(
                              "Quý khách có chắc chắn hủy mã truy cập này?",
                              textAlign: TextAlign.center,
                            ),
                            close: true,
                            titleButton: "Đồng ý",
                            handleContinute: () async {
                              String codeGenOTP = await getQuanLyMaTruyCapCode(
                                  cust.id, context);
                              if (mounted) {
                                OtpFunction().showDialogEnterPinOTP(
                                    context: context,
                                    transCode: codeGenOTP,
                                    callBack: (String otp, String code) async {
                                      var requestBody = {
                                        'otp': otp,
                                        'code': code,
                                        'data': {"id": cust.id, "status": "3"}
                                      };
                                      await updateStatusCust(requestBody, 3);
                                    });
                              }
                            });
                      }),
                    btnOption(Icons.history, "Lịch sử", onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LichSuChinhSuaScreen(
                                    custId: cust.id.toString(),
                                  )));
                    }),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget btnOption(IconData icon, String title, {Function? onTap}) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              onTap();
            }
          : null,
      child: Row(
        children: [
          Icon(
            icon,
            color: secondaryColor,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: Text(title))
        ],
      ),
    );
  }

  Widget rowSpaceBW({required List<Widget> children}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Widget textTitle(String? title, {Color? color}) {
    return Text(
      title ?? "",
      style: TextStyle(
        color: color ?? colorBlack_727374,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget textContent(String? content, {Color? color, FontWeight? fontWeight}) {
    return Text(
      content ?? "",
      style: TextStyle(
        color: color ?? colorBlack_363E46,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }

  void searchAction(String? codeQuery, String? phoneQuery, String? emailQuery,
      String? statusQuery) {
    final suggestions = listResponse.where((matruyCap) {
      int matchCount = 0;
      final codes = matruyCap.code.toString().toLowerCase();
      final inputCode = codeQuery?.toLowerCase();
      final phones = matruyCap.tel.toString().toLowerCase();
      final inputPhone = phoneQuery?.toLowerCase();
      final emails = matruyCap.email.toString().toLowerCase();
      final inputEmail = emailQuery?.toLowerCase();
      final statuses = matruyCap.status.toString().toLowerCase();
      final inputStatus = statusQuery?.toLowerCase();

      if (inputCode != null && codes.contains(inputCode)) {
        matchCount++;
      }
      if (inputPhone != null && phones.contains(inputPhone)) {
        matchCount++;
      }
      if (inputEmail != null && emails.contains(inputEmail)) {
        matchCount++;
      }
      if (inputStatus != null && statuses.contains(inputStatus)) {
        matchCount++;
      }
      return matchCount ==
          (inputCode != null ? 1 : 0) +
              (inputPhone != null ? 1 : 0) +
              (inputEmail != null ? 1 : 0) +
              (inputStatus != null ? 1 : 0);
    }).toList();

    setState(() {
      listTemp = suggestions;
    });
  }
}
