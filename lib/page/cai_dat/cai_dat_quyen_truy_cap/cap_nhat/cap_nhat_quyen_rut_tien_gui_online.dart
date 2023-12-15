import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/cust_acc_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

import '../../../../base/base_component.dart';
import '../../../../common/button.dart';
import '../../../../common/checkbox.dart';
import '../../../../common/switch_button.dart';
import '../../../../enum/enum.dart';
import '../../../../network/services/cus_service.dart';
import '../xac_nhan/xac_nhan_quyen_rut_tien_gui_online.dart';

class CapNhatQuyenRutTienGuiOnlineWidget extends StatefulWidget {
  final int custId;
  const CapNhatQuyenRutTienGuiOnlineWidget({super.key, required this.custId});

  @override
  State<CapNhatQuyenRutTienGuiOnlineWidget> createState() =>
      _CapNhatQuyenRutTienGuiOnlineWidgetState();
}

class _CapNhatQuyenRutTienGuiOnlineWidgetState
    extends State<CapNhatQuyenRutTienGuiOnlineWidget> with BaseComponent<Cust> {
  int selectIndex = 1;
  List<Cust> listDuyetLenh = [];
  List<CustAcc> listTDDAcc = [];
  List listChuyenTien = [];
  List listThanhToan = [];
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
    super.initState();
    getInitPage();
  }

  getInitPage() async {
    await getCustDetail();
    await getListDuyetLenh(1);
    await getListTDDAcc();
    setState(() {
      isLoading = !isLoading;
    });
  }

  getCustDetail() async {
    BaseResponse response =
        await CusService().getCustWithCustAcc(widget.custId);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        dataResponse = Cust.fromJson(response.data);
        for (var items in listAllChuyenTien) {
          if (dataResponse!.custProduct!
              .any((element) => element.product == items["product"])) {
            listChuyenTien.add(items);
          }
        }
        for (var items in listAllThanhToan) {
          if (dataResponse!.custProduct!
              .any((element) => element.product == items["product"])) {
            listThanhToan.add(items);
          }
        }
      });
    }
  }

  getListDuyetLenh(int curentPage) async {
    page.curentPage = curentPage;
    page.size = 100;
    Cust cust = Cust(position: 3);
    BasePagingResponse<Cust> response =
        await CusService().searchPaging(page, cust);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listDuyetLenh =
            response.data!.content!.map((cust) => Cust.fromJson(cust)).toList();
      });
    }
  }

  getListTDDAcc() async {
    BaseResponseDataList response =
        await CustAccService().getCustTDDByCustId(widget.custId);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listTDDAcc =
            response.data!.map((cust) => CustAcc.fromJson(cust)).toList();
      });
    }
  }

  bool listsAreEqual(List<CustAcc> listOne, List<CustAcc> listTwo) {
    for (var oneItem in listOne) {
      var contain = listTwo.where((element) => element.id == oneItem.id);
      if (contain.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        title: const Text("Cập nhật quyền rút tiền gửi Online"),
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: !isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    custView(),
                    renderSelectContent(),
                    renderButton(),
                  ],
                ),
              ),
            )
          : const LoadingCircle(),
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
                dataResponse!.code ?? "",
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Họ và tên"),
              Text(dataResponse!.fullname ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Số điện thoại"),
              Text(dataResponse!.tel ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Vai trò"),
              Text(
                dataResponse!.position == PositionEnum.LAPLENH.value
                    ? "Mã lập lệnh"
                    : "Mã duyệt lệnh",
                style: const TextStyle(
                  color: primaryBlackColor,
                  //  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Quyền truy cập"),
              Text(
                "Quyền rút tiền gửi online",
                style: TextStyle(
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

  renderSelectContent() {
    return CardLayoutWidget(
      child: Column(
        children: [
          selectMenu(),
          const SizedBox(
            height: 16,
          ),
          if (selectIndex == 1) renderTransferAccount(),
          if (selectIndex == 2) renderAccsess(),
        ],
      ),
    );
  }

  selectMenu() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: coloreWhite_EAEBEC),
        borderRadius: const BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemMenu(index: 1, title: "Tài khoản tiền gửi online"),
          itemMenu(index: 2, title: "Duyệt lệnh"),
        ],
      ),
    );
  }

  Widget itemMenu({required int index, required String title}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectIndex = index;
          });
        },
        child: Container(
          height: 55,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: selectIndex == index
              ? BoxDecoration(
                  color: colorBlack_EAEBEC,
                  border: Border.all(width: 1, color: secondaryColor),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(9),
                  ),
                )
              : null,
          child: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  renderTransferAccount() {
    return Wrap(
      runSpacing: 16,
      children: [
        const Text(
          "Tài khoản cho phép người lập được phép tạo lệnh giao dịch",
          style: TextStyle(
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: colorBlack_727374),
        ),
        SwitchButtonWidget(
          title: "Tài khoản tiền gửi online",
          status: listsAreEqual(
              listTDDAcc,
              dataResponse!.custAcc!
                  .where((element) => element.type == "1")
                  .toList()),
          callback: (value) {
            setState(() {
              if (value!) {
                dataResponse!.custAcc!
                    .removeWhere((element) => element.type == "1");
              } else {
                dataResponse!.custAcc!.addAll(listTDDAcc);
              }
            });
          },
        ),
        for (CustAcc custAcc in listTDDAcc) checkBoxItem(custAcc, listTDDAcc)
      ],
    );
  }

  Widget checkBoxItem(CustAcc custAcc, List<CustAcc>? list) {
    return Column(
      children: [
        CheckBoxWidget(
          value:
              dataResponse!.custAcc!.any((element) => element.id == custAcc.id),
          content: Text(custAcc.acc ?? "---"),
          handleSelected: (bool? value) {
            onClickCheckBox(value, custAcc);
          },
        ),
        if (list!.last != custAcc)
          const SizedBox(
            height: 8.0,
          ),
      ],
    );
  }

  onClickCheckBox(bool? value, CustAcc custAcc) {
    setState(() {
      if (value!) {
        dataResponse!.custAcc ??= [];
        dataResponse!.custAcc!.add(custAcc);
      } else {
        dataResponse!.custAcc!
            .removeWhere((element) => element.id == custAcc.id);
      }
    });
  }

  renderAccsess() {
    return (listDuyetLenh.isNotEmpty)
        ? Wrap(
            runSpacing: 16,
            children: [
              const Text(
                "Vui lòng chọn các tài khoản cho phép user duyệt lệnh được phép duyệt lệnh giao dịch",
                style: TextStyle(
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: colorBlack_727374),
              ),
              for (Cust cust in listDuyetLenh)
                CheckBoxWidget(
                  value: true,
                  content: Text(cust.code ?? "---"),
                  handleSelected: (bool? value) {},
                ),
            ],
          )
        : const Text("Không có tài khoản duyệt lệnh");
  }

  Widget renderButton() {
    return Column(
      children: [
        ButtonWidget(
            backgroundColor: secondaryColor,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => XacNhanQuyenRutTienGuiOnlineWidget(
                    cust: dataResponse!,
                  ),
                ),
              );
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
            widthButton: double.infinity),
      ],
    );
  }
}
