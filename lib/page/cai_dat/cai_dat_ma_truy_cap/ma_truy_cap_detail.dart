import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/date_time_picker.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/validate_form.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/ma_truy_cap_xac_thuc.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/model_Matruycap/loaigiayto_model.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/model_Matruycap/vaitro_model.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../../../common/button.dart';
import '../../../../common/form_input_and_label/label.dart';
import '../../../../utils/theme.dart';
import '../../../enum/enum.dart';
import '../../../network/services/cus_service.dart';

class MaTruyCapDetailWidget extends StatefulWidget {
  final Cust? cust;
  final String type;
  const MaTruyCapDetailWidget({super.key, this.cust, required this.type});

  @override
  State<MaTruyCapDetailWidget> createState() => _MaTruyCapDetailWidgetState();
}

class _MaTruyCapDetailWidgetState extends State<MaTruyCapDetailWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController loaiGiayToController =
      TextEditingController(text: "CCCD");
  final TextEditingController idnoController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rolesController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  int? verifyType = 1;
  bool isShowNote = false;
  Cust cust = Cust();
  final _formKey = GlobalKey<FormState>();
  bool isExistsTel = false;
  bool isExistsIdno = false;
  bool isExistsEmail = false;
  @override
  void initState() {
    super.initState();
    if (widget.cust != null) {
      setInitCust();
    }
  }

  setInitCust() {
    cust = widget.cust!;
    nameController.text = cust.fullname!;
    codeController.text = cust.code!;
    loaiGiayToController.text =
        cust.indentitypapers == IndentifypapersEnum.CMND.value
            ? "CMND"
            : cust.indentitypapers == IndentifypapersEnum.HOCHIEU.value
                ? "Hộ chiếu"
                : "CCCD";
    idnoController.text = cust.idno!;
    birthdayController.text = (DateFormat("dd/MM/yyyy")
        .format(DateFormat("yyyy-MM-dd").parse(cust.birthday!)));
    // DateFormat("dd/MM/yyyy").parse(cust.birthday!).toString();
    phoneNumberController.text = cust.tel!;
    emailController.text = cust.email!;
    rolesController.text = cust.position == PositionEnum.QUANTRI.value
        ? "Quản lý"
        : cust.position == PositionEnum.LAPLENH.value
            ? "Mã lập lệnh"
            : cust.position == PositionEnum.DUYETLENH.value
                ? "Mã duyệt lệnh"
                : 'Vui lòng chọn';
  }

  checkDup(Cust cust) async {
    BaseResponse<dynamic> response = await CusService().checkDuplicate(cust);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        isExistsTel = response.data["codeTel"] == FwError.DLDATONTAI.value;
        isExistsIdno = response.data["codeIdNo"] == FwError.DLDATONTAI.value;
        isExistsEmail = response.data["codeEmail"] == FwError.DLDATONTAI.value;
      });
    }
  }

  getCodeCust(int position) async {
    BaseResponse<dynamic> response = await CusService().getCodeCust(position);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        codeController.text = response.data;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    codeController.dispose();
    loaiGiayToController.dispose();
    idnoController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    rolesController.dispose();
    birthdayController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          toolbarHeight: 55,
          title: Text(widget.cust != null
              ? "Chỉnh sửa mã truy cập"
              : "Thêm mới mã truy cập"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                formCreateCust(),
                const SizedBox(
                  height: 24,
                ),
                renderNote(),
                const SizedBox(
                  height: 26,
                ),
                ButtonWidget(
                    backgroundColor: secondaryColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        cust.fullname = nameController.text;
                        cust.code = codeController.text;
                        cust.indentitypapers =
                            loaiGiayToController.text == "CMND"
                                ? IndentifypapersEnum.CMND.value
                                : loaiGiayToController.text == "Hộ chiếu"
                                    ? IndentifypapersEnum.HOCHIEU.value
                                    : IndentifypapersEnum.CCCD.value;
                        loaiGiayToController.text;
                        cust.idno = idnoController.text;
                        cust.birthday = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                            .format(DateFormat("dd/MM/yyyy")
                                .parse(birthdayController.text));
                        cust.tel = phoneNumberController.text;
                        cust.email = emailController.text;
                        cust.position = rolesController.text == "Quản lý"
                            ? PositionEnum.QUANTRI.value
                            : rolesController.text == "Mã lập lệnh"
                                ? PositionEnum.LAPLENH.value
                                : rolesController.text == "Mã duyệt lệnh"
                                    ? PositionEnum.DUYETLENH.value
                                    : null;
                        await checkDup(cust);
                        if (!isExistsEmail &&
                            !isExistsIdno &&
                            !isExistsTel &&
                            mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaTruyCapXacThucWidget(
                                cust: cust,
                                type: widget.type,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    text: translation(context)!.continueKey,
                    colorText: Colors.white,
                    haveBorder: false,
                    widthButton: double.infinity),
                const SizedBox(
                  height: 12,
                ),
                ButtonWidget(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: translation(context)!.backKey,
                    colorText: colorBlack_727374,
                    haveBorder: true,
                    colorBorder: colorBlack_727374.withOpacity(0.5),
                    widthButton: double.infinity)
              ],
            ),
          ),
        ));
  }

  formCreateCust() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 151, 156, 168).withOpacity(0.16),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputFormWidget(
              label: "Họ và tên",
              note: true,
              colors: colorBlack_15334A,
              controller: nameController,
              hintText: "Nhập họ và tên",
              readOnly: widget.type != "create",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Trường họ và tên không được phép bỏ trống';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Loại giấy tờ",
              note: true,
              colors: colorBlack_15334A,
              controller: loaiGiayToController,
              hintText: "Chọn loại giấy tờ",
              readOnly: true,
              showBottomSheetWidget: LoaiGiayToBottom(
                value: loaiGiayToController.text,
                handleSelectLoaiGiayTo: (String loaiGiayTo) {
                  setState(() {
                    loaiGiayToController.text = loaiGiayTo;
                  });
                },
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Trường loại giấy tờ không được phép bỏ trống';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Số giấy tờ",
              note: true,
              colors: colorBlack_15334A,
              controller: idnoController,
              hintText: "Nhập số giấy tờ",
              readOnly: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Trường số giấy tờ không được phép bỏ trống';
                }
                return null;
              },
            ),
            if (isExistsIdno)
              const Text(
                "Số giấy tờ đã tồn tại",
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 16,
            ),
            LabelWidget(
              label: "Ngày sinh",
              note: true,
              colors: colorBlack_15334A,
              child: DateTimePickerWidget(
                disable: widget.type != "create",
                controllerDateTime: birthdayController,
                validator: (date) {
                  if (date == null || date.isEmpty) {
                    return 'Ngày sinh không được để trống!';
                  }
                  return null;
                },
                onConfirm: (date) {
                  birthdayController.text =
                      DateFormat('dd/MM/yyyy').format(date);
                },
                hintText: "Ngày sinh",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Số điện thoại",
              note: true,
              colors: colorBlack_15334A,
              controller: phoneNumberController,
              readOnly: widget.type != "create",
              hintText: "Nhập số điện thoại",
              textInputType: TextInputType.phone,
              validator: ValidateForm(context: context).validatePhoneNumber,
            ),
            if (isExistsTel)
              const Text(
                "Số điện thoại đã tồn tại",
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Email",
              note: true,
              colors: colorBlack_15334A,
              controller: emailController,
              hintText: "Nhập Email",
              readOnly: false,
              textInputType: TextInputType.emailAddress,
              validator: ValidateForm(context: context).validateEmail,
            ),
            if (isExistsEmail)
              const Text(
                "Email đã tồn tại",
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 16,
            ),
            (widget.type == "create")
                ? InputFormWidget(
                    label: "Vai trò",
                    note: true,
                    colors: colorBlack_15334A,
                    controller: rolesController,
                    hintText: "Chọn vai trò",
                    readOnly: true,
                    showBottomSheetWidget: RolesAccessCodeBottom(
                      value: rolesController.text,
                      handleSelectRolesAccessCode: (String rloes) {
                        setState(() {
                          rolesController.text = rloes;
                          getCodeCust(rolesController.text == "Quản lý"
                              ? PositionEnum.QUANTRI.value
                              : rolesController.text == "Mã lập lệnh"
                                  ? PositionEnum.LAPLENH.value
                                  : PositionEnum.DUYETLENH.value);
                        });
                      },
                    ),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Trường vai trò không được phép bỏ trống';
                      }
                      return null;
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Vai trò",
                        style: TextStyle(color: colorBlack_727374),
                      ),
                      Text(
                        rolesController.text,
                        style: const TextStyle(color: primaryColor),
                      )
                    ],
                  ),
            if (codeController.text.isNotEmpty)
              const SizedBox(
                height: 20,
              ),
            if (codeController.text.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mã truy cập",
                    style: TextStyle(color: colorBlack_727374),
                  ),
                  Text(
                    codeController.text,
                    style: const TextStyle(color: primaryColor),
                  )
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phương thức xác thực",
                  style: TextStyle(color: colorBlack_727374),
                ),
                Text(
                  "Smart OTP",
                  style: TextStyle(color: primaryColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget renderNote() {
    return InkWell(
      onTap: () {
        setState(() {
          isShowNote = !isShowNote;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 151, 156, 168).withOpacity(0.16),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: secondaryColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Lưu ý",
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
                Transform.rotate(
                  angle: isShowNote ? 0 : math.pi * -1,
                  alignment: Alignment.center,
                  child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: colorBlack_727374.withOpacity(0.8),
                      )),
                ),
              ],
            ),
            (isShowNote == true)
                ? const Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                    child: Column(
                      children: [
                        Text(
                          "• Số lượng mã truy cập không vượt quá số mã tối đa đối với mã lập lệnh theo chính sách Ngân hàng CB quy định.",
                          style:
                              TextStyle(color: colorBlack_727374, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "• Thông tin mã truy cập sẽ được gửi đến Email đăng ký. Mật khẩu kích hoạt được gửi qua SMS đến số điện thoại đăng ký.",
                          style:
                              TextStyle(color: colorBlack_727374, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
