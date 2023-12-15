import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/cust_contact_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import '../../../../model/models.dart';
import '../../../../network/services/bank_receiving_service.dart';
import '../../../chuyen_tien/Transactions/ngan_hang_thu_huong_modal.dart';

class SuaThemDanhBaThuHuong extends StatefulWidget {
  final int? id;
  final String? bankAccountNumber;
  final String? userName;
  final String? bankName;
  final String? code;
  final int? typeTrading;
  final String? userNote;
  const SuaThemDanhBaThuHuong(
      {super.key,
      this.id,
      this.bankAccountNumber,
      this.userName,
      this.bankName,
      this.code,
      this.typeTrading,
      this.userNote});

  @override
  State<SuaThemDanhBaThuHuong> createState() => _SuaThemDanhBaThuHuongState();
}

class _SuaThemDanhBaThuHuongState extends State<SuaThemDanhBaThuHuong> {
  late TextEditingController searchControllerTypeTradding;
  late TextEditingController searchControllerNameBank;
  late TextEditingController textControllerName;
  late TextEditingController textControllerNumberBank;
  late TextEditingController textControllerNameNote;
  int? transTypeCode;
  String? code;
  List<BankReceivingModel> list = [];
  List<TransType> listTransType = [
    TransType.CORE,
    TransType.CITAD,
    TransType.NAPAS
  ];

  addCustContact(CustContact custContact, context) async {
    BaseResponse response =
        await CusContactService().saveCustContact(custContact);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      Navigator.pop(context, "Thành công");
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  updateCustContact(CustContact custContact, context) async {
    BaseResponse response =
        await CusContactService().updateCustContact(custContact);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      Navigator.pop(context, "Thành công");
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  _getBankReceivingByProduct(transType) async {
    BaseResponseDataList response =
        await BankReceiveService().getBankReceivingByProduct(transType);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        list = response.data!
            .map((bankReceive) => BankReceivingModel.fromJson(bankReceive))
            .toList();
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  _getBankReceiving() async {
    BaseResponseDataList response =
        await BankReceiveService().getBankReceiving(context);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        list = response.data!
            .map((bankReceive) => BankReceivingModel.fromJson(bankReceive))
            .toList();
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  @override
  void initState() {
    if (widget.typeTrading != null) {
      _getBankReceivingByProduct(widget.typeTrading);
    } else {
      _getBankReceiving();
    }
    super.initState();
    if (widget.id == null) {
      searchControllerTypeTradding = TextEditingController(text: '');
      searchControllerNameBank = TextEditingController(text: '');
      textControllerName = TextEditingController(text: '');
      textControllerNumberBank = TextEditingController(text: '');
      textControllerNameNote = TextEditingController(text: '');
    } else {
      searchControllerTypeTradding = TextEditingController(
          text: TransType.getNameByValue(widget.typeTrading));
      searchControllerNameBank =
          TextEditingController(text: '${widget.bankName}');
      textControllerName = TextEditingController(text: '${widget.userName}');
      textControllerNumberBank =
          TextEditingController(text: '${widget.bankAccountNumber}');
      textControllerNameNote =
          TextEditingController(text: '${widget.userNote}');
      transTypeCode = widget.typeTrading;
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchControllerNameBank.dispose();
    searchControllerTypeTradding.dispose();
    textControllerName.dispose();
    textControllerNameNote.dispose();
    textControllerNumberBank.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: widget.id == null
            ? const Text("Thêm danh bạ thụ hưởng")
            : const Text("Sửa danh bạ thụ hưởng"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: renderBodySuaDanhBaThuHuong(),
    );
  }

  renderBodySuaDanhBaThuHuong() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(children: [
            InputFormWidget(
              label: "Loại chuyển tiền",
              note: true,
              colors: colorBlack_15334A,
              controller: searchControllerTypeTradding,
              hintText: "Loại chuyển tiền",
              readOnly: true,
              showBottomSheetWidget: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Text(
                        "Loại chuyển tiền",
                        style: TextStyle(color: colorBlack_727374),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.2,
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: [
                            for (var item in listTransType)
                              InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);

                                    setState(() {
                                      searchControllerTypeTradding.text =
                                          TransType.getName(item);
                                      transTypeCode =
                                          TransType.getProductType(item);
                                    });
                                    searchControllerNameBank.text = '';
                                    await _getBankReceivingByProduct(
                                        transTypeCode);

                                    if (transTypeCode == 3) {
                                      setState(() {
                                        searchControllerNameBank.text =
                                            '${list[0].name} ${list[0].sortname != null ? '(${list[0].sortname})' : ''}';
                                        code = list[0].code;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: coloreWhite_EAEBEC))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          TransType.getName(item),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (searchControllerTypeTradding
                                                        .text
                                                        .compareTo(
                                                            TransType.getName(
                                                                item)) ==
                                                    0)
                                                ? primaryColor
                                                : primaryBlackColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        (searchControllerTypeTradding.text
                                                    .compareTo(
                                                        TransType.getName(
                                                            item)) ==
                                                0)
                                            ? const Icon(
                                                CupertinoIcons
                                                    .checkmark_alt_circle_fill,
                                                color: primaryColor,
                                                size: 24,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Ngân hàng thụ thưởng",
              note: true,
              maxLines: 2,
              colors: colorBlack_15334A,
              controller: searchControllerNameBank,
              hintText: "Ngân hàng thụ hưởng",
              readOnly: true,
              showBottomSheetWidget: NganHangThuHuongModal(
                listData: list,
                value: searchControllerNameBank.text,
                handleSelectedBank: (BankReceivingModel item) {
                  setState(
                    () {
                      searchControllerNameBank.text =
                          '${item.name} ${item.sortname != null ? '(${item.sortname})' : ''}';
                      code = item.code;
                    },
                  );
                },
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Tên người thụ hưởng",
              note: true,
              colors: colorBlack_15334A,
              controller: textControllerName,
              hintText: "Tên thụ hưởng",
              onChange: (value) async {
                String str = value.toString();
                if (value != null) {
                  str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
                  str = str.replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A');
                  str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
                  str = str.replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E');
                  str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
                  str = str.replaceAll(RegExp(r'[ÌÍỊỈĨ]'), 'I');
                  str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
                  str = str.replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O');
                  str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
                  str = str.replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U');
                  str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
                  str = str.replaceAll(RegExp(r'[ỲÝỴỶỸ]'), 'Y');
                  str = str.replaceAll('đ', 'd');
                  str = str.replaceAll('Đ', 'D');
                  str = str.replaceAll(
                      RegExp(r'\u0300|\u0301|\u0303|\u0309|\u0323'), '');
                  str = str.replaceAll(RegExp(r'\u02C6|\u0306|\u031B'), '');

                  textControllerName.value = TextEditingValue(
                    text: str.toUpperCase(),
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: str.length),
                    ),
                  );
                  textControllerNameNote.text = textControllerName.text;
                }
              },
              readOnly: false,
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Số tài khoản",
              note: true,
              colors: colorBlack_15334A,
              controller: textControllerNumberBank,
              hintText: "Số tài khoản",
              readOnly: false,
            ),
            const SizedBox(
              height: 16,
            ),
            InputFormWidget(
              label: "Tên gợi nhớ",
              colors: colorBlack_15334A,
              controller: textControllerNameNote,
              hintText: "Tên gợi nhớ",
              readOnly: false,
            ),
            const SizedBox(
              height: 32,
            ),
            ButtonWidget(
                backgroundColor: primaryColor,
                onPressed: widget.id == null
                    ? () async {
                        BankReceivingModel bank = BankReceivingModel(
                            code: code!, name: searchControllerNameBank.text);

                        CustContact custContact = CustContact(
                            product: transTypeCode,
                            bankReceiving: bank,
                            receiveAccount: textControllerNumberBank.text,
                            receiveName: textControllerName.text,
                            sortname: textControllerNameNote.text);
                        await addCustContact(custContact, context);
                      }
                    : () async {
                        BankReceivingModel bank = BankReceivingModel(
                            code: code ?? widget.code!, name: widget.bankName!);

                        CustContact custContact = CustContact(
                            id: widget.id,
                            product: transTypeCode,
                            bankReceiving: bank,
                            receiveAccount: textControllerNumberBank.text,
                            receiveName: textControllerName.text,
                            sortname: textControllerNameNote.text);
                        await updateCustContact(custContact, context);
                      },
                text: "Lưu",
                colorText: Colors.white,
                haveBorder: false,
                widthButton: MediaQuery.of(context).size.width - 32),
            const SizedBox(
              height: 16,
            ),
            ButtonWidget(
                backgroundColor: secondaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: translation(context)!.backKey,
                colorText: Colors.white,
                haveBorder: false,
                widthButton: MediaQuery.of(context).size.width - 32)
          ]),
        ),
      ),
    );
  }
}
