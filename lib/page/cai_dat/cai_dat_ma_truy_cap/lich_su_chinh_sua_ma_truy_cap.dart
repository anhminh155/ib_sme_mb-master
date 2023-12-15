import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/date_time_picker.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/cus_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LichSuChinhSuaScreen extends StatefulWidget {
  final String custId;
  const LichSuChinhSuaScreen({super.key, required this.custId});

  @override
  State<LichSuChinhSuaScreen> createState() => _LichSuChinhSuaScreenState();
}

class _LichSuChinhSuaScreenState extends State<LichSuChinhSuaScreen>
    with BaseComponent {
  final TextEditingController _crateTimeFrom = TextEditingController();
  final TextEditingController _crateTimeTo = TextEditingController();
  String? userCode;
  List<CustHis> listCustHis = [];

  getListCustHis({String? dateFrom, String? dateTo}) async {
    setState(() {
      isLoading = true;
    });
    BasePagingResponse<CustHis> response = await CusService()
        .getListCustHis(widget.custId, dateFrom: dateFrom, dateTo: dateTo);
    if (response.errorCode == FwError.THANHCONG.value) {
      listCustHis =
          response.data!.content!.map((e) => CustHis.fromJson(e)).toList();
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }

    setState(() {
      isLoading = false;
    });
  }

  convertCustHis(String custHis) {
    String dataReplace = custHis.replaceAll("\\", "");
    Map<String, dynamic> mapData = json.decode(dataReplace);
    Cust cust = Cust.fromJson(mapData);
    return cust;
  }

  @override
  void initState() {
    userCode = Provider.of<CustInfoProvider>(context, listen: false).item?.code;
    super.initState();
    getListCustHis();
  }

  @override
  void dispose() {
    super.dispose();
    _crateTimeFrom.dispose();
    _crateTimeTo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 55,
          title: const Text("Lịch sử chỉnh sửa"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: renderBody());
  }

  DateFormat format = DateFormat('dd/MM/yyyy');
  renderBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CardLayoutWidget(
            child: FormControlWidget(
              label: 'Khoảng thời gian sửa',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: DateTimePickerWidget(
                        controllerDateTime: _crateTimeFrom,
                        hintText: "Từ ngày",
                        onConfirm: (date) {
                          setState(() {
                            _crateTimeFrom.text = format.format(date);
                            getListCustHis(
                                dateFrom: _crateTimeFrom.text,
                                dateTo: _crateTimeTo.text);
                          });
                        },
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: DateTimePickerWidget(
                      controllerDateTime: _crateTimeTo,
                      hintText: "Đến ngày",
                      onConfirm: (date) {
                        setState(() {
                          _crateTimeTo.text = format.format(date);
                          getListCustHis(
                              dateFrom: _crateTimeFrom.text,
                              dateTo: _crateTimeTo.text);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          (isLoading) ? const LoadingCircle() : renderContent(),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ButtonWidget(
              colorText: Colors.white,
              text: translation(context)!.backKey,
              onPressed: () {},
              backgroundColor: secondaryColor,
              haveBorder: false,
              widthButton: MediaQuery.of(context).size.width,
            ),
          )
        ],
      ),
    );
  }

  renderContent() {
    return CardLayoutWidget(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Người chỉnh sửa'),
              Text(
                userCode ?? '',
                style: const TextStyle(color: primaryColor),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: const Border.symmetric(
                  horizontal: BorderSide(width: 6.0, color: primaryColor),
                  vertical: BorderSide(width: 0.5, color: primaryColor))),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 71,
              maxHeight: 360,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (CustHis custHis in listCustHis)
                    renderHistoryContent(custHis,
                        line: listCustHis.length - 1 !=
                                listCustHis.indexOf(custHis)
                            ? true
                            : false)
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  renderHistoryContent(CustHis custHis, {bool line = true}) {
    return SizedBox(
      height: 70,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(convertDateFormat(custHis.createdAt.toString(),
                        time: true)),
                    Text(
                        ActionChange.getNameByValue(custHis.action.toString())),
                    custHis.custHis != null
                        ? SizedBox(
                            width: 20,
                            child: InkWell(
                                onTap: () {
                                  renderShowDialog(
                                      convertCustHis(custHis.custHis!));
                                },
                                child: const Icon(
                                  Icons.error_outline,
                                  color: colorBlack_727374,
                                )),
                          )
                        : const SizedBox(
                            width: 20,
                          )
                  ],
                ),
              ),
            ),
          ),
          if (line)
            const Divider(
              color: primaryColor,
              height: 0.1,
            )
        ],
      ),
    );
  }

  renderShowDialog(Cust cust) {
    return showDiaLogConfirm(
        close: true,
        context: context,
        title: "Chi tiết lịch sử chỉnh sửa",
        titleButton: translation(context)!.closeKey,
        content: Column(
          children: [
            renderLineContent(title: "Họ và tên", value: cust.fullname),
            renderLineContent(
                title: "Loại giấy tờ", value: cust.indentitypapers),
            renderLineContent(title: "Số giấy tờ", value: cust.idno),
            renderLineContent(
                title: "Ngày sinh",
                value: DateFormat('dd/MM/yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(cust.birthday!))),
            renderLineContent(title: "Số điện thoại", value: cust.tel),
            renderLineContent(title: "Email", value: cust.email),
            renderLineContent(
                title: "Vai trò",
                value: PositionEnum.getName(cust.position!, context)),
            renderLineContent(
                title: "Phương thức xác thực",
                value: VerifyTypeEnum.getName(cust.verifyType!)),
          ],
        ));
  }

  renderLineContent({String? title, dynamic value}) {
    return SizedBox(
      height: 40,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: colorBlack_727374),
              ),
              Text(value ?? ''),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          const Divider(
            height: 1.0,
          )
        ],
      ),
    );
  }
}
