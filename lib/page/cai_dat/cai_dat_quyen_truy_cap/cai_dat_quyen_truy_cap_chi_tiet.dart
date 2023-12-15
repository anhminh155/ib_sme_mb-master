import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/switch_button.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/IBRolesDefault_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_quyen_truy_cap/cap_nhat/cap_nhat_quyen_giao_dich.dart';
import '../../../common/dialog_confirm.dart';
import '../../../enum/enum.dart';
import '../../../network/services/cus_service.dart';
import '../../../utils/theme.dart';
import 'cap_nhat/cap_nhat_quyen_rut_tien_gui_online.dart';
import 'cap_nhat/cap_nhat_quyen_truy_van.dart';
import '../../../../common/show_dialog_otp.dart';
import '../../../../common/show_toast.dart';
import '../../../../network/services/get_code_gen_otp_service.dart';

class CaiDatQuyenTruyCapChiTietScreen extends StatefulWidget {
  final int custId;
  final String companyType;
  const CaiDatQuyenTruyCapChiTietScreen(
      {super.key, required this.custId, required this.companyType});

  @override
  State<CaiDatQuyenTruyCapChiTietScreen> createState() =>
      _CaiDatQuyenTruyCapChiTietScreenState();
}

class _CaiDatQuyenTruyCapChiTietScreenState
    extends State<CaiDatQuyenTruyCapChiTietScreen> {
  Cust custDetail = Cust();
  IBRolesDefaultModel rolesDefaultModelSearch = IBRolesDefaultModel();
  IBRolesDefaultModel rolesDefaultModelTrans = IBRolesDefaultModel();
  List<CustAcc> listTruyVanThanhToan = [];
  List<CustAcc> listTruyVanTienGui = [];
  List<CustAcc> listTruyVanTienVay = [];
  List<CustAcc> listGiaoDichThanhToan = [];
  List listAllChuyenTien = [
    {"product": "1", "title": "Chuyển khoản 24/7 đến số tài khoản"},
    {"product": "2", "title": "Chuyển khoản liên ngân hàng"},
    {"product": "3", "title": "Chuyển khoản nội bộ CB"},
    {"product": "4", "title": "Chuyển khoản theo danh sách"},
  ];
  List listAllThanhToan = [
    {"product": "5", "title": "Thanh toán hóa đơn điện"},
    {"product": "6", "title": "Thanh toán hóa đơn nước"},
    {"product": "7", "title": "Thanh toán cước điện thoại cố định"},
    {"product": "8", "title": "Thanh toán cước di động trả sau"},
    {"product": "9", "title": "Thanh toán cước Internet ADSL"},
  ];
  @override
  void initState() {
    getIBRolesDefaultSearch();
    getIBRolesDefaultTrans();
    getInitCust();
    super.initState();
  }

  getQuanLyMaTruyCapCode(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.QUANLYQUYENTRUYCAP, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    }
  }

  updateRoleTranCust(requestBody) async {
    BaseResponse response = await CusService().updateRoleTranCust(requestBody);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.done));
      getInitCust();
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  updateRoleSearchCust(requestBody) async {
    BaseResponse response =
        await CusService().updateRoleSearchCust(requestBody);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.done));
      getInitCust();
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getInitCust() async {
    listTruyVanThanhToan = [];
    listTruyVanTienVay = [];
    listTruyVanTienGui = [];
    listGiaoDichThanhToan = [];
    BaseResponse response =
        await CusService().getCustWithCustAcc(widget.custId);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        custDetail = Cust.fromJson(response.data);
        for (CustAcc custAcc in custDetail.custAcc ?? []) {
          if (custAcc.type == "2" && custAcc.accType == "1") {
            listTruyVanThanhToan.add(custAcc);
          }
          if (custAcc.type == "2" && custAcc.accType == "2") {
            listTruyVanTienGui.add(custAcc);
          }
          if (custAcc.type == "2" && custAcc.accType == "3") {
            listTruyVanTienVay.add(custAcc);
          }
          if (custAcc.type == "1") {
            listGiaoDichThanhToan.add(custAcc);
          }
        }
      });
    }
  }

  getIBRolesDefaultSearch() async {
    BaseResponse response = await IBRolesDefaultService()
        .getIBRolesDefault(widget.custId, 'role-search');
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        rolesDefaultModelSearch = IBRolesDefaultModel.fromJson(response.data);
      });
    }
  }

  getIBRolesDefaultTrans() async {
    BaseResponse response = await IBRolesDefaultService()
        .getIBRolesDefault(widget.custId, 'role-tran');
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        rolesDefaultModelTrans = IBRolesDefaultModel.fromJson(response.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        title: Text(
            "Quyền truy cập - ${custDetail.position == PositionEnum.LAPLENH.value ? "Lập lệnh" : "Duyệt lệnh"}"),
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Wrap(
            runSpacing: 16,
            children: [
              custView(),
              if (rolesDefaultModelSearch.status ==
                  YesNoEnum.Y.value.toString())
                renderQueryPermission(),
              if (custDetail.position == PositionEnum.LAPLENH.value &&
                  rolesDefaultModelTrans.status == YesNoEnum.Y.value.toString())
                renderTransferPermission(),
              // Giai đoạn 2
              // if (custDetail.position == PositionEnum.LAPLENH.value)
              //   renderOnlineMoney(),
            ],
          ),
        ),
      ),
    );
  }

  custView() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Mã truy cập"),
              Text(
                custDetail.code ?? "",
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Họ và tên"),
              Text(custDetail.fullname ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Số điện thoại"),
              Text(custDetail.tel ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Vai trò"),
              Text(
                custDetail.position == PositionEnum.LAPLENH.value
                    ? "Mã lập lệnh"
                    : "Mã duyệt lệnh",
                style: const TextStyle(
                  color: primaryBlackColor,
                  //  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  renderQueryPermission() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          SwitchButtonWidget(
            title: "Quyền truy vấn",
            callback: (val) {
              showDiaLogConfirm(
                  context: context,
                  content: RichText(
                    text: TextSpan(
                      text:
                          'Quý khách có chắc chắn ${custDetail.rolesearch == 1 ? "khóa" : "mở khóa"} quyền truy vấn với mã truy cập ',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 16, height: 1.6),
                      children: <TextSpan>[
                        TextSpan(
                            text: custDetail.code,
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600)),
                        const TextSpan(text: ' này không ?'),
                      ],
                    ),
                  ),
                  close: true,
                  titleButton: "Đồng ý",
                  handleContinute: () async {
                    String codeGenOTP = await getQuanLyMaTruyCapCode(
                        widget.custId.toString(), context);
                    if (mounted) {
                      OtpFunction().showDialogEnterPinOTP(
                          context: context,
                          transCode: codeGenOTP,
                          callBack: (String otp, String code) async {
                            var requestBody = {
                              'otp': otp,
                              'code': code,
                              'data': {
                                "id": custDetail.id,
                                "rolesearch":
                                    custDetail.rolesearch == 1 ? "0" : "1"
                              }
                            };
                            await updateRoleSearchCust(requestBody);
                          });
                    }
                  });
            },
            status: custDetail.rolesearch == 1,
          ),
          if (listTruyVanThanhToan.isNotEmpty)
            renderContentQueryPermission(
              title: "Tài khoản thanh toán",
              custAccList: listTruyVanThanhToan,
              isIcon: true,
            ),
          if (listTruyVanTienGui.isNotEmpty)
            renderContentQueryPermission(
              title: "Tài khoản tiền gửi",
              custAccList: listTruyVanTienGui,
              isIcon: true,
            ),
          if (listTruyVanTienVay.isNotEmpty)
            renderContentQueryPermission(
              title: "Tài khoản tiền vay",
              custAccList: listTruyVanTienVay,
              isIcon: true,
            ),
          renderButonEditQueryPermission(
            onClicked: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CapNhatQuyenTruyVanScreen(
                          custId: custDetail.id!,
                        ))),
          ),
        ],
      ),
    );
  }

  renderContentQueryPermission(
      {required String title,
      List<CustAcc>? custAccList,
      isFontWeight = false,
      isIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                color: colorBlack_727374,
                fontWeight: isFontWeight ? FontWeight.w600 : null),
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (CustAcc custAcc in custAccList ?? [])
              isIcon
                  ? Row(
                      children: [
                        Text(custAcc.acc ?? "---"),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: colorGreen_56AB01.withOpacity(0.4),
                        )
                      ],
                    )
                  : Text(custAcc.acc ?? "---"),
          ],
        )
      ],
    );
  }

  renderTransferPermission() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          SwitchButtonWidget(
            title: "Quyền giao dịch",
            callback: (val) async {
              showDiaLogConfirm(
                  context: context,
                  content: RichText(
                    text: TextSpan(
                      text:
                          'Quý khách có chắc chắn ${custDetail.roletrans == 1 ? "khóa" : "mở khóa"} quyền giao dịch với mã truy cập ',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 16, height: 1.6),
                      children: <TextSpan>[
                        TextSpan(
                            text: custDetail.code,
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600)),
                        const TextSpan(text: ' này không ?'),
                      ],
                    ),
                  ),
                  close: true,
                  titleButton: "Đồng ý",
                  handleContinute: () async {
                    String codeGenOTP = await getQuanLyMaTruyCapCode(
                        widget.custId.toString(), context);
                    if (mounted) {
                      OtpFunction().showDialogEnterPinOTP(
                          context: context,
                          transCode: codeGenOTP,
                          callBack: (String otp, String code) async {
                            var requestBody = {
                              'otp': otp,
                              'code': code,
                              'data': {
                                "id": custDetail.id,
                                "roletrans":
                                    custDetail.roletrans == 1 ? "0" : "1"
                              }
                            };
                            await updateRoleTranCust(requestBody);
                          });
                    }
                  });
            },
            status: custDetail.roletrans == 1,
          ),
          renderContentQueryPermission(
              title: "Tài khoản thanh toán",
              custAccList: listGiaoDichThanhToan,
              isFontWeight: true),
          const Text(
            "Dịch vụ và mã duyệt lệnh",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorBlack_727374),
          ),
          for (var chuyenTien in listAllChuyenTien)
            if (custDetail.custProduct != null &&
                custDetail.custProduct!.any(
                    (element) => (element.product == chuyenTien["product"])))
              renderRowContent(
                  title: chuyenTien["title"],
                  custAccList: (custDetail.custProduct!
                              .firstWhere((element) =>
                                  element.product == chuyenTien["product"])
                              .custCode ??
                          "")
                      .split(",")),
          for (var thanhToan in listAllThanhToan)
            if (custDetail.custProduct != null &&
                custDetail.custProduct!.any(
                    (element) => (element.product == thanhToan["product"])))
              renderRowContent(
                  title: thanhToan["title"],
                  custAccList: (custDetail.custProduct!
                              .firstWhere((element) =>
                                  element.product == thanhToan["product"])
                              .custCode ??
                          "")
                      .split(",")),
          renderButonEditQueryPermission(
            onClicked: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CapNhatQuyenGiaoDichScreen(
                  custId: custDetail.id!,
                  companyType: widget.companyType,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkValueDuyetLenhItem(String listCustCode, String custCode) {
    List<String> list = listCustCode.split(",");
    return list.contains(custCode);
  }

  renderOnlineMoney() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          SwitchButtonWidget(
            title: "Quyền rút tiền gửi Online",
            callback: (val) async {
              showDiaLogConfirm(
                  context: context,
                  content: RichText(
                    text: TextSpan(
                      text:
                          'Quý khách có chắc chắn khóa quyền rút tiền gửi Online với mã truy cập ',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 16, height: 1.6),
                      children: <TextSpan>[
                        TextSpan(
                            text: custDetail.code,
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600)),
                        const TextSpan(text: ' này không ?'),
                      ],
                    ),
                  ),
                  close: true,
                  titleButton: "Đồng ý",
                  handleContinute: () async {});
            },
            status: true,
          ),
          renderRowContent(
              title: "Tài khoản tiền gửi Online",
              custAccList: [
                "0300123456785",
                "0300123456784",
                "0300123456783",
                "0300123456782",
                "0300123456781"
              ],
              isFontWeight: true),
          renderRowContent(
            title: "Mã duyệt lệnh",
            custAccList: ["0123456789DL01", "0123456789DL02"],
          ),
          renderButonEditQueryPermission(
            onClicked: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CapNhatQuyenRutTienGuiOnlineWidget(
                  custId: custDetail.id!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  renderRowContent(
      {required String title,
      required List<String> custAccList,
      isFontWeight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                color: colorBlack_727374,
                fontWeight: isFontWeight ? FontWeight.w600 : null),
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var acc in custAccList) Text(acc),
          ],
        )
      ],
    );
  }

  renderButonEditQueryPermission({onClicked}) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: colorBlack_727374),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/pencil.svg"),
            const SizedBox(
              width: 5,
            ),
            const Text("Chỉnh sửa"),
          ],
        ),
      ),
    );
  }
}
