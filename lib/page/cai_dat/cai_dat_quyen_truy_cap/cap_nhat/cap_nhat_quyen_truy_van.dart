import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_quyen_truy_cap/xac_nhan/xac_nhan_quyen_truy_van.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

import '../../../../common/button.dart';
import '../../../../common/checkbox.dart';
import '../../../../common/switch_button.dart';
import '../../../../network/services/cus_service.dart';
import '../../../../network/services/cust_acc_service.dart';

class CapNhatQuyenTruyVanScreen extends StatefulWidget {
  final int custId;
  const CapNhatQuyenTruyVanScreen({super.key, required this.custId});

  @override
  State<CapNhatQuyenTruyVanScreen> createState() =>
      _CapNhatQuyenTruyVanScreenState();
}

class _CapNhatQuyenTruyVanScreenState extends State<CapNhatQuyenTruyVanScreen>
    with BaseComponent<Cust> {
  AllAccountResponse allAccountResponse = AllAccountResponse();
  @override
  void initState() {
    super.initState();
    getInitPage();
  }

  getInitPage() async {
    await getCustDetail();
    await getAllAccountResponse(dataResponse!.id);
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
        if (dataResponse!.custAcc == null) {
          dataResponse!.custAcc = [];
        }
      });
    }
  }

  getAllAccountResponse(int? custId) async {
    BaseResponse response = await CustAccService().getCustAccByCustId(custId!);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        allAccountResponse = AllAccountResponse.fromJson(response.data);
      });
    }
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
        title: const Text("Cập nhật quyền truy vấn"),
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
                    taiKhoanThanhToan(),
                    taiKhoanTienGuiVay(),
                    renderButton()
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
                "Quyền truy vấn",
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

  Widget taiKhoanThanhToan() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          const Text(
            "Tài khoản thanh toán cho phép mã truy cập thực hiện truy vấn",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SwitchButtonWidget(
            title: "Tài khoản thanh toán",
            status: listsAreEqual(
                allAccountResponse.dd!,
                dataResponse!.custAcc!
                    .where((element) =>
                        element.type == "2" && element.accType == "1")
                    .toList()),
            callback: (value) {
              setState(() {
                if (value!) {
                  dataResponse!.custAcc!.removeWhere((element) =>
                      element.type == "2" && element.accType == "1");
                } else {
                  dataResponse!.custAcc!.addAll(allAccountResponse.dd ?? []);
                }
              });
            },
          ),
          for (CustAcc custAcc in allAccountResponse.dd ?? [])
            checkBoxItem(custAcc, allAccountResponse.dd ?? [])
        ],
      ),
    );
  }

  Widget taiKhoanTienGuiVay() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          if (allAccountResponse.fd != null &&
              allAccountResponse.fd!.isNotEmpty)
            SwitchButtonWidget(
              title: "Tài khoản tiền gửi",
              status: listsAreEqual(
                  allAccountResponse.fd!,
                  dataResponse!.custAcc!
                      .where((element) =>
                          element.type == "2" && element.accType == "2")
                      .toList()),
              callback: (value) {
                setState(() {
                  if (value!) {
                    dataResponse!.custAcc!.removeWhere((element) =>
                        element.type == "2" && element.accType == "2");
                  } else {
                    dataResponse!.custAcc!.addAll(allAccountResponse.fd ?? []);
                  }
                });
              },
            ),
          for (CustAcc custAcc in allAccountResponse.fd ?? [])
            checkBoxItem(custAcc, allAccountResponse.fd ?? []),
          if (allAccountResponse.ln != null &&
              allAccountResponse.ln!.isNotEmpty)
            SwitchButtonWidget(
              title: "Tài khoản tiền vay",
              status: listsAreEqual(
                  allAccountResponse.ln!,
                  dataResponse!.custAcc!
                      .where((element) =>
                          element.type == "2" && element.accType == "3")
                      .toList()),
              callback: (value) {
                setState(() {
                  if (value!) {
                    dataResponse!.custAcc!.removeWhere((element) =>
                        element.type == "2" && element.accType == "3");
                  } else {
                    dataResponse!.custAcc!.addAll(allAccountResponse.ln ?? []);
                  }
                });
              },
            ),
          for (CustAcc custAcc in allAccountResponse.ln ?? [])
            checkBoxItem(custAcc, allAccountResponse.ln ?? [])
        ],
      ),
    );
  }

  Widget checkBoxItem(CustAcc custAcc, List<CustAcc> list) {
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
        if (list.last != custAcc)
          const SizedBox(
            height: 8.0,
          ),
      ],
    );
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
                  builder: (context) => XacNhanQuyenTruyVanWidget(
                      cust: dataResponse!,
                      allAccountResponse: allAccountResponse),
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
