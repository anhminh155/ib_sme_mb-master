import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/cust_acc_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/package_product_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import '../../../../base/base_component.dart';
import '../../../../common/button.dart';
import '../../../../common/checkbox.dart';
import '../../../../common/switch_button.dart';
import '../../../../enum/enum.dart';
import '../../../../network/services/cus_service.dart';
import '../xac_nhan/xac_nhan_quyen_giao_dich.dart';
import 'dart:developer' as dev;

class CapNhatQuyenGiaoDichScreen extends StatefulWidget {
  final int custId;
  final String companyType;
  const CapNhatQuyenGiaoDichScreen(
      {super.key, required this.custId, required this.companyType});

  @override
  State<CapNhatQuyenGiaoDichScreen> createState() =>
      _CapNhatQuyenGiaoDichScreenState();
}

class _CapNhatQuyenGiaoDichScreenState extends State<CapNhatQuyenGiaoDichScreen>
    with BaseComponent<Cust> {
  int selectIndex = 1;
  List<Cust> listDuyetLenh = [];
  List<CustAcc> listTDDAcc = [];
  List<CustProduct> listChuyenTien = [];
  List<CustProduct> listThanhToan = [];
  List listAllChuyenTien = [];
  List listAllThanhToan = [];
  @override
  void initState() {
    super.initState();
    getInitPage();
  }

  getInitPage() async {
    final futures = <Future>[
      getListPackageProduct(),
      getListTDDAcc(),
      if (widget.companyType.toString() == CompanyTypeEnum.MOHINHCAP2.value)
        getListDuyetLenh(1),
    ];
    final result = await Future.wait<dynamic>(futures);
    if (result.isNotEmpty) {
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  getListPackageProduct() async {
    try {
      BaseResponseDataList responseDataList =
          await PackageProductService().getPackageProduct();
      if (responseDataList.errorCode == FwError.THANHCONG.value) {
        if (responseDataList.data!.isNotEmpty) {
          for (var items in responseDataList.data!) {
            if (int.parse(items.toString()) <= 4 &&
                int.parse(items.toString()) >= 1) {
              listAllChuyenTien.add(createProduct(items));
            } else if (int.parse(items.toString()) <= 10 &&
                int.parse(items.toString()) >= 5) {
              listAllThanhToan.add(createProduct(items));
            }
          }
        }
      }
    } catch (e) {
      dev.log(e.toString());
    }
    getCustDetail();
  }

  getCustDetail() async {
    BaseResponse response =
        await CusService().getCustWithCustAcc(widget.custId);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        dataResponse = Cust.fromJson(response.data);
        if (dataResponse!.custProduct!.isNotEmpty) {
          for (var items in dataResponse!.custProduct!) {
            if (listAllChuyenTien
                .any((element) => element['product'] == items.product)) {
              listChuyenTien.add(items);
            }
          }
          for (var items in dataResponse!.custProduct!) {
            if (listAllThanhToan
                .any((element) => element['product'] == items.product)) {
              listThanhToan.add(items);
            }
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
      listTDDAcc =
          response.data!.map((cust) => CustAcc.fromJson(cust)).toList();
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

  createProduct(value) {
    Map<String, dynamic> mapProduct = {
      "product": value,
      "title": SERVICE.getNameProduct(value, context)
    };
    return mapProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        title: const Text("Cập nhật quyền giao dịch"),
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
                dataResponse?.code ?? "",
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Họ và tên"),
              Text(dataResponse?.fullname ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Số điện thoại"),
              Text(dataResponse?.tel ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Vai trò"),
              Text(
                dataResponse?.position == PositionEnum.LAPLENH.value
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
                "Quyền giao dịch",
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
          if (selectIndex == 2) renderService(),
          if (selectIndex == 3 &&
              widget.companyType.toString() == CompanyTypeEnum.MOHINHCAP2.value)
            renderAccsess(),
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
          itemMenu(index: 1, title: "Tài khoản giao dịch"),
          itemMenu(index: 2, title: "Dịch vụ"),
          if (widget.companyType.toString() == CompanyTypeEnum.MOHINHCAP2.value)
            itemMenu(index: 3, title: "Duyệt lệnh"),
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
        Text(
          "Quý khách có thể cập nhật thông tin theo nhu cầu trong phân quyền giao dịch. Sau khi cập nhật, Quý khách nhấn"
          ' ${translation(context)!.continueKey} '
          "để thực hiện các bước tiếp theo.",
          style: const TextStyle(
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: colorBlack_727374),
        ),
        const Text(
          "Vui lòng chọn các tài khoản cho phép người lập được phép tạo lệnh giao dịch",
          style: TextStyle(
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: colorBlack_727374),
        ),
        SwitchButtonWidget(
          title: "Tài khoản thanh toán",
          status: listsAreEqual(
              listTDDAcc,
              dataResponse != null
                  ? dataResponse!.custAcc!
                      .where((element) => element.type == "1")
                      .toList()
                  : []),
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
              dataResponse?.custAcc?.any((element) => element.id == custAcc.id),
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

  checkBoxValueProduct(List listItem, items) {
    if (listItem.any((element) => element.product.contains(items['product']))) {
      return true;
    }
    return false;
  }

  renderService() {
    return Wrap(
      runSpacing: 16,
      children: [
        const Text(
          "Chuyển tiền",
          style: TextStyle(
              color: colorBlack_17191B,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        for (var items in listAllChuyenTien)
          CheckBoxWidget(
            content: Text(items["title"]),
            value: checkBoxValueProduct(listChuyenTien, items),
            handleSelected: (bool? value) {
              CustProduct custProduct = CustProduct(product: items["product"]);
              if (value! == true) {
                setState(() {
                  listChuyenTien.add(custProduct);
                });
              } else {
                setState(() {
                  listChuyenTien.remove(listChuyenTien.firstWhere(
                      (element) => element.product == items["product"]));
                });
              }
            },
          ),
        if (listAllThanhToan.isNotEmpty)
          const Text(
            "Thanh toán",
            style: TextStyle(
                color: colorBlack_17191B,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        for (var items in listAllThanhToan)
          CheckBoxWidget(
            content: Text(items["title"]),
            value: checkBoxValueProduct(listThanhToan, items),
            handleSelected: (bool? value) {
              CustProduct custProduct = CustProduct(product: items["product"]);
              if (value! == true) {
                setState(() {
                  listThanhToan.add(custProduct);
                });
              } else {
                setState(() {
                  listThanhToan.remove(listThanhToan.firstWhere(
                      (element) => element.product == items["product"]));
                });
              }
            },
          ),
      ],
    );
  }

  renderAccsess() {
    return (listDuyetLenh.isNotEmpty)
        ? Wrap(
            runSpacing: 16,
            children: [
              for (var items in listChuyenTien)
                Wrap(
                  runSpacing: 16,
                  children: [
                    Text(
                      SERVICE.getNameProduct(items.product!, context),
                      style: const TextStyle(
                          color: colorBlack_17191B,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    for (Cust cust in listDuyetLenh)
                      CheckBoxWidget(
                        value: checkValueDuyetLenhItem(
                            dataResponse!.custProduct!
                                    .firstWhere((element) =>
                                        element.product == items.product)
                                    .custCode ??
                                "",
                            cust.code ?? ""),
                        content: Text(cust.code ?? "---"),
                        handleSelected: (bool? value) {
                          onClickCheckBoxDuyetLenh(
                              cust.code ?? "", value ?? false, items.product);
                        },
                      ),
                  ],
                ),
              for (var items in listThanhToan)
                Wrap(
                  runSpacing: 16,
                  children: [
                    Text(
                      SERVICE.getNameProduct(items.product!, context),
                      style: const TextStyle(
                          color: colorBlack_17191B,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    for (Cust cust in listDuyetLenh)
                      CheckBoxWidget(
                        value: checkValueDuyetLenhItem(
                            dataResponse!.custProduct!
                                    .firstWhere((element) =>
                                        element.product == items.product)
                                    .custCode ??
                                "",
                            cust.code ?? ""),
                        content: Text(cust.code ?? "---"),
                        handleSelected: (bool? value) {
                          onClickCheckBoxDuyetLenh(
                              cust.code ?? "", value ?? false, items.product);
                        },
                      ),
                  ],
                ),
            ],
          )
        : const Text("Không có tài khoản duyệt lệnh");
  }

  checkValueDuyetLenhItem(String listCustCode, String custCode) {
    List<String> list = listCustCode.split(",");
    return list.contains(custCode);
  }

  onClickCheckBoxDuyetLenh(String custCode, bool selected, product) {
    setState(() {
      CustProduct custProduct = dataResponse!.custProduct!
          .firstWhere((element) => element.product == product);
      if (selected) {
        custProduct.custCode = "${custProduct.custCode ?? ''},$custCode";
      } else {
        List<String> list = custProduct.custCode!.split(",");
        if (list.contains(custCode)) {
          list.removeWhere((element) => element == custCode);
        }
        custProduct.custCode = list.join(",");
      }
    });
  }

  renderRadioButton(title, value, group, Function callback) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: primaryColor,
            value: value,
            groupValue: group,
            onChanged: (value) {
              callback(value);
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(title),
      ],
    );
  }

  Widget renderButton() {
    dataResponse?.custProduct?.clear();
    dataResponse?.custProduct?.addAll(listChuyenTien);
    dataResponse?.custProduct?.addAll(listThanhToan);
    return Column(
      children: [
        ButtonWidget(
            backgroundColor: secondaryColor,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => XacNhanQuyenGiaoDichWidget(
                      cust: dataResponse!,
                      listChuyenTien: listChuyenTien,
                      listThanhToan: listThanhToan),
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
