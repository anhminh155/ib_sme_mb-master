import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/show_bottomSheet/bottom_sheet_code.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/trang_thai_giao_dich_bottomSheet.dart';
import 'package:ib_sme_mb_view/common/tai_khoan_nguon.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_trang_thai_bang_ke/trang_thai_bang_ke.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/date_time_picker.dart';
import '../../../common/form/form_control.dart';
import '../../../common/form/input_show_bottom_sheet.dart';
import '../../../common/form_input_and_label/text_field.dart';

class QuanLyGiaoDichBangKe extends StatefulWidget {
  const QuanLyGiaoDichBangKe({super.key});

  @override
  State<QuanLyGiaoDichBangKe> createState() =>
      _QuanLyGiaoDichThongThuongState();
}

class _QuanLyGiaoDichThongThuongState extends State<QuanLyGiaoDichBangKe> {
  bool isShowSearch = false;
  String? userLL;
  String? userDL;
  String? rolesCompany;
  dynamic valueStatus;
  final List<StatusApprovetranslot> listStatus = [];

  final TextEditingController _sendAccController =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _status = TextEditingController(text: 'Tất cả');
  final TextEditingController _crateTimeFrom = TextEditingController();
  final TextEditingController _crateTimeTo = TextEditingController();
  final TextEditingController _confirmTimeFrom = TextEditingController();
  final TextEditingController _confirmTimeTo = TextEditingController();
  final TextEditingController _setCommand =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _browseCommand =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _codeTrans = TextEditingController();
  final TextEditingController _moneyForm = TextEditingController();
  final TextEditingController _moneyTo = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    rolesCompany =
        Provider.of<CustInfoProvider>(context, listen: false).item?.roles?.type;
    if (rolesCompany! == CompanyTypeEnum.MOHINHCAP1.value) {
      listStatus.addAll([
        StatusApprovetranslot.TATCA,
        StatusApprovetranslot.HOANTHANH,
        StatusApprovetranslot.THANHCONG,
        StatusApprovetranslot.LOI,
      ]);
    }

    if (rolesCompany! == CompanyTypeEnum.MOHINHCAP2.value) {
      listStatus.addAll([
        StatusApprovetranslot.TATCA,
        StatusApprovetranslot.CHODUYET,
        StatusApprovetranslot.DADUYET,
        StatusApprovetranslot.TUCHOI,
        StatusApprovetranslot.THANHCONG,
        StatusApprovetranslot.LOI
      ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _sendAccController.dispose();
    _status.dispose();
    _crateTimeFrom.dispose();
    _crateTimeTo.dispose();
    _confirmTimeFrom.dispose();
    _confirmTimeTo.dispose();
    _setCommand.dispose();
    _browseCommand.dispose();
    _codeTrans.dispose();
    _moneyForm.dispose();
    _moneyTo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: const Text('Quản lý giao dịch bảng kê'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isShowSearch = !isShowSearch;
                });
              },
              icon: const Icon(Icons.filter_alt_rounded))
        ],
      ),
      body: _renderBody(),
    );
  }

  _renderBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: _renderCard1(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _renderButtons(),
        )
      ],
    );
  }

  _renderCard1() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        CardLayoutWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SourceAccount(
                selectAll: true,
                value: _sendAccController.text,
                function: (TDDAcount item) {
                  setState(() {
                    _sendAccController.text = item.acctno ?? '';
                  });
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              FormControlWidget(
                label: "Trạng thái",
                child: InputShowBottomSheet(
                  controller: _status,
                  hintText: "Trạng thái",
                  bodyWidget: BottomSheetStatusTrans(
                    listApproveTranslot: listStatus,
                    value: _status.text,
                    handleSelectAccessCode:
                        (String? stringStatus, dynamic valueStatusTemp) {
                      setState(() {
                        _status.text = stringStatus!;
                        valueStatus = valueStatusTemp;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              _renderTimezone1(),
              if (isShowSearch == true) _showSomeSearch(),
            ],
          ),
        ),
      ],
    );
  }

  _showSomeSearch() {
    return Column(
      children: [
        const SizedBox(
          height: 12.0,
        ),
        if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
          _renderTimezone2(),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "User lập lệnh",
          child: InputShowBottomSheet(
            controller: _sendAccController,
            hintText: "Chọn user lập lệnh",
            bodyWidget: BottomSheetCode(
              position: PositionEnum.LAPLENH.value,
              value: _setCommand.text,
              handleSelectAccessCode: (String? valueCode, int valueId) {
                setState(() {
                  _setCommand.text = valueCode!;
                  if (valueId != 0) {
                    userLL = valueCode;
                  }
                });
              },
            ),
          ),
        ),
        if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
          const SizedBox(
            height: 12.0,
          ),
        if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
          FormControlWidget(
            label: "User duyệt lệnh",
            child: InputShowBottomSheet(
              controller: _sendAccController,
              hintText: "Chọn user duyệt lệnh",
              bodyWidget: BottomSheetCode(
                position: PositionEnum.DUYETLENH.value,
                value: _browseCommand.text,
                handleSelectAccessCode: (String? valueCode, int valueId) {
                  setState(() {
                    _browseCommand.text = valueCode!;
                    if (valueId != 0) {
                      userDL = valueCode;
                    }
                  });
                },
              ),
            ),
          ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "Mã giao dịch",
          child: TextFieldWidget(
            onSubmitted: (value) {},
            controller: _codeTrans,
            hintText: "Nhập mã giao dịch",
            focusNode: _focusNode,
            textInputType: TextInputType.number,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: 'Khoảng tiền',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldWidget(
                  onSubmitted: (value) {},
                  controller: _moneyForm,
                  hintText: "Từ",
                  focusNode: _focusNode,
                  textInputType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldWidget(
                  onSubmitted: (value) {},
                  controller: _moneyTo,
                  hintText: "Đến",
                  focusNode: _focusNode,
                  textInputType: TextInputType.number,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  DateFormat format = DateFormat('dd/MM/yyyy');
  DateTime dateNow = DateTime.now();
  _renderTimezone1() {
    return FormControlWidget(
      label: 'Khoảng thời gian lập',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: DateTimePickerWidget(
                controllerDateTime: _crateTimeFrom,
                hintText: "Từ ngày",
                maxTime: _crateTimeTo.text.isNotEmpty
                    ? format.parse(_crateTimeTo.text)
                    : null,
                minTime: format.parse(format.format(
                    DateTime(dateNow.year, dateNow.month - 6, dateNow.day))),
                onConfirm: (date) {
                  setState(() {
                    _crateTimeFrom.text = format.format(date);
                    if (_crateTimeTo.text.isEmpty) {
                      _crateTimeTo.text =
                          DateTime(date.year, date.month + 3, date.day)
                                  .isBefore(dateNow)
                              ? format.format(
                                  DateTime(date.year, date.month + 3, date.day))
                              : format.format(dateNow);
                    } else if (DateTime(date.year, date.month + 3, date.day)
                        .isBefore(format.parse(_crateTimeTo.text))) {
                      _crateTimeTo.text = format.format(
                          DateTime(date.year, date.month + 3, date.day));
                    }
                  });
                },
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: DateTimePickerWidget(
              controllerDateTime: _crateTimeTo,
              hintText: "Đến ngày",
              minTime: _crateTimeFrom.text.isNotEmpty
                  ? format.parse(_crateTimeFrom.text)
                  : format.parse(format.format(
                      DateTime(dateNow.year, dateNow.month - 6, dateNow.day))),
              maxTime: (_crateTimeFrom.text.isNotEmpty &&
                      (format.parse(_crateTimeFrom.text).month + 3) <
                          dateNow.month)
                  ? DateTime(
                      format.parse(_crateTimeFrom.text).year,
                      format.parse(_crateTimeFrom.text).month + 3,
                      format.parse(_crateTimeFrom.text).day)
                  : null,
              onConfirm: (date) {
                setState(() {
                  _crateTimeTo.text = format.format(date);
                  if (_crateTimeFrom.text.isEmpty) {
                    _crateTimeFrom
                        .text = DateTime(date.year, date.month - 3, date.day)
                            .isBefore(DateTime(
                                dateNow.year, dateNow.month - 6, dateNow.day))
                        ? format.format(DateTime(
                            dateNow.year, dateNow.month - 6, dateNow.day))
                        : format.format(
                            DateTime(date.year, date.month - 3, date.day));
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _renderTimezone2() {
    return FormControlWidget(
      label: 'Khoảng thời gian duyệt',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: DateTimePickerWidget(
                controllerDateTime: _confirmTimeFrom,
                hintText: "Từ ngày",
                maxTime: _confirmTimeTo.text.isNotEmpty
                    ? format.parse(_confirmTimeTo.text)
                    : null,
                minTime: format.parse(format.format(
                    DateTime(dateNow.year, dateNow.month - 6, dateNow.day))),
                onConfirm: (date) {
                  setState(() {
                    _confirmTimeFrom.text = format.format(date);
                    if (_confirmTimeTo.text.isEmpty) {
                      _confirmTimeTo.text =
                          DateTime(date.year, date.month + 3, date.day)
                                  .isBefore(dateNow)
                              ? format.format(
                                  DateTime(date.year, date.month + 3, date.day))
                              : format.format(dateNow);
                    } else if (DateTime(date.year, date.month + 3, date.day)
                        .isBefore(format.parse(_confirmTimeTo.text))) {
                      _confirmTimeTo.text = format.format(
                          DateTime(date.year, date.month + 3, date.day));
                    }
                  });
                },
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: DateTimePickerWidget(
              controllerDateTime: _confirmTimeTo,
              hintText: "Đến ngày",
              minTime: _confirmTimeFrom.text.isNotEmpty
                  ? format.parse(_confirmTimeFrom.text)
                  : format.parse(format.format(
                      DateTime(dateNow.year, dateNow.month - 6, dateNow.day))),
              maxTime: (_confirmTimeFrom.text.isNotEmpty &&
                      (format.parse(_confirmTimeFrom.text).month + 3) <
                          dateNow.month)
                  ? DateTime(
                      format.parse(_confirmTimeFrom.text).year,
                      format.parse(_confirmTimeFrom.text).month + 3,
                      format.parse(_confirmTimeFrom.text).day)
                  : null,
              onConfirm: (date) {
                setState(() {
                  _confirmTimeTo.text = format.format(date);
                  if (_confirmTimeFrom.text.isEmpty) {
                    _confirmTimeFrom
                        .text = DateTime(date.year, date.month - 3, date.day)
                            .isBefore(DateTime(
                                dateNow.year, dateNow.month - 6, dateNow.day))
                        ? format.format(DateTime(
                            dateNow.year, dateNow.month - 6, dateNow.day))
                        : format.format(
                            DateTime(date.year, date.month - 3, date.day));
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _renderButtons() {
    return ButtonWidget(
        backgroundColor: primaryColor,
        onPressed: _onPressSearch,
        text: 'Tìm kiếm',
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width);
  }

  _onPressSearch() async {
    StatementTransRequest request = StatementTransRequest();
    request.sendAccount = _sendAccController.text.compareTo('Tất cả') == 0
        ? null
        : _sendAccController.text;
    request.status = valueStatus;
    request.startDate = _crateTimeFrom.text;
    request.endDate = _crateTimeTo.text != '' ? _crateTimeTo.text : null;
    request.approvedStartDate =
        _confirmTimeFrom.text != '' ? _confirmTimeFrom.text : null;
    request.approvedEndDate =
        _confirmTimeTo.text != '' ? _confirmTimeTo.text : null;
    request.updatedByCust = userLL;
    request.approvedBy = userDL;
    request.transLotCode = _codeTrans.text != '' ? _codeTrans.text : null;
    request.startAmount = _moneyForm.text != '' ? _moneyForm.text : null;
    request.endAmount = _moneyTo.text != '' ? _moneyTo.text : null;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListResltStatementTransaction(
            requestParams: request,
            accountNumber: _sendAccController.text,
          ),
        ));
  }
}
