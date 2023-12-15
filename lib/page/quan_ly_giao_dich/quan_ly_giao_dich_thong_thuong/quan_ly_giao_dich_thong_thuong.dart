import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/trang_thai_giao_dich_bottomSheet.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_giao_dich_thong_thuong/giao_dich_thong_thuong.dart';
import 'package:ib_sme_mb_view/provider/custInfo_provider.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/date_time_picker.dart';
import '../../../common/form/form_control.dart';
import '../../../common/form/input_show_bottom_sheet.dart';
import '../../../common/form_input_and_label/text_field.dart';
import '../../../common/show_bottomSheet/bottom_sheet_code.dart';
import '../../../common/tai_khoan_nguon.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../chuyen_tien/danh_ba_thu_huong.dart';
import '../../../common/show_bottomSheet/loai_giao_dich_bottomSheet.dart';
// import 'dart:developer' as dev;

class QuanLyGiaoDichThongThuong extends StatefulWidget {
  const QuanLyGiaoDichThongThuong({super.key});

  @override
  State<QuanLyGiaoDichThongThuong> createState() =>
      _QuanLyGiaoDichThongThuongState();
}

class _QuanLyGiaoDichThongThuongState extends State<QuanLyGiaoDichThongThuong> {
  bool isShowSearch = false;
  String? rolesCompany;
  String? transType;
  TransType? transTypes;
  dynamic valueStatus;
  String? userLL;
  String? userDL;

  final FocusNode _focusNode = FocusNode();

  final TextEditingController _accController =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _crateTimeFrom = TextEditingController();
  final TextEditingController _crateTimeTo = TextEditingController();
  final TextEditingController _confirmTimeFrom = TextEditingController();
  final TextEditingController _confirmTimeTo = TextEditingController();
  final TextEditingController _setCommand =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _browseCommand =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _recieveAccController = TextEditingController();
  final TextEditingController _recieveNameController = TextEditingController();
  final TextEditingController _recieveBankController = TextEditingController();
  final TextEditingController _statusTrans =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _moneyForm = TextEditingController();
  final TextEditingController _moneyTo = TextEditingController();
  final TextEditingController _codeTrans = TextEditingController();
  final TextEditingController _typeTrans =
      TextEditingController(text: 'Tất cả');
  bool checkSignOut = false;
  final List<StatusTrans> listStatus = [];

  @override
  void initState() {
    rolesCompany =
        Provider.of<CustInfoProvider>(context, listen: false).item?.roles?.type;
    super.initState();
    if (rolesCompany! == CompanyTypeEnum.MOHINHCAP1.value) {
      listStatus.addAll([
        StatusTrans.TATCA,
        StatusTrans.THANHCONG,
        StatusTrans.LOI,
      ]);
    }

    if (rolesCompany! == CompanyTypeEnum.MOHINHCAP2.value) {
      listStatus.addAll([
        StatusTrans.TATCA,
        StatusTrans.CHODUYET,
        StatusTrans.DADUYET,
        StatusTrans.TUCHOI,
        StatusTrans.THANHCONG,
        StatusTrans.LOI
      ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _accController.dispose();
    _crateTimeFrom.dispose();
    _crateTimeTo.dispose();
    _confirmTimeFrom.dispose();
    _confirmTimeTo.dispose();
    _recieveAccController.dispose();
    _recieveNameController.dispose();
    _recieveBankController.dispose();
    _moneyForm.dispose();
    _moneyTo.dispose();
    _typeTrans.dispose();
    _setCommand.dispose();
    _browseCommand.dispose();
    _codeTrans.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        titleSpacing: 0.0,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: const Text('Giao dịch thông thường'),
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
              FormControlWidget(
                label: "Loại giao dịch",
                child: InputShowBottomSheet(
                    controller: _typeTrans,
                    hintText: "Chọn loại giao dịch",
                    bodyWidget: BottomSheetTypeTrans(
                      value: _typeTrans.text,
                      handleSelectAccessCode: (String? value,
                          String? transTypeTemp, TransType? transTypeTemps) {
                        setState(() {
                          _typeTrans.text = value!;
                          transTypes = transTypeTemps;
                          if (transTypeTemp != '') {
                            transType = transTypeTemp;
                          } else {
                            transType = null;
                          }
                        });
                      },
                    )),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SourceAccount(
                selectAll: true,
                value: _accController.text,
                function: (TDDAcount item) {
                  setState(() {
                    _accController.text = item.acctno ?? '';
                  });
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              _renderTimezone1(),
              if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
                const SizedBox(
                  height: 12.0,
                ),
              if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
                _renderTimezone2(),
              if (isShowSearch) _showSomeSearch(),
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
        FormControlWidget(
          label: "Tài khoản thụ hưởng",
          child: TextFieldWidget(
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/danh_ba.svg',
                // ignore: deprecated_member_use
                color: _focusNode.hasFocus ? null : colorBlack_727374,
              ),
              onPressed: () {
                _showBottomSheet(context, transTypes);
              },
            ),
            onSubmitted: (value) {},
            controller: _recieveAccController,
            hintText: "Nhập số tài khoản khoản thụ hưởng",
            textInputType: TextInputType.number,
            focusNode: _focusNode,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "Tên người thụ hưởng/Nhà cung cấp",
          child: TextFieldWidget(
            onSubmitted: (value) {},
            controller: _recieveNameController,
            hintText: "Người thụ hưởng/Nhà cung cấp",
            textInputType: TextInputType.number,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "User lập lệnh",
          child: InputShowBottomSheet(
            controller: _setCommand,
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
              controller: _browseCommand,
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
          label: "Trạng thái giao dịch",
          child: InputShowBottomSheet(
              controller: _statusTrans,
              hintText: "Trạng thái giao dịch",
              bodyWidget: BottomSheetStatusTrans(
                listRegularTransactionStatus: listStatus,
                value: _statusTrans.text,
                handleSelectAccessCode:
                    (String? stringStatus, dynamic valueStatusTemp) {
                  setState(() {
                    _statusTrans.text = stringStatus!;
                    valueStatus = valueStatusTemp;
                  });
                },
              )),
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
                  textInputType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldWidget(
                  onSubmitted: (value) {},
                  controller: _moneyTo,
                  hintText: "Đến",
                  textInputType: TextInputType.number,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, TransType? transType) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Constacts(
          recieveAccController: _recieveAccController,
          recieveNameController: _recieveNameController,
          recieveBankController: _recieveBankController,
          transType: transType?.value ?? "",
        );
      },
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
        onPressed: () {
          setState(() {
            if (isShowSearch == true) {
              isShowSearch = false;
            }
            TranSearch regularTransaction = TranSearch(
                type: transType,
                taiKhoanNguon: _accController.text.compareTo('Tất cả') == 0
                    ? null
                    : _accController.text,
                tenNguoiThuHuong: _recieveNameController.text,
                taiKhoanThuHuong: _recieveAccController.text,
                thoiGianLapLenhTu: _crateTimeFrom.text,
                thoiGianLapLenhDen: _crateTimeTo.text,
                thoiGianDuyetLenhTu: _confirmTimeFrom.text,
                thoiGianDuyetLenhDen: _confirmTimeTo.text,
                userLapLenh: userLL,
                userDuyetLenh: userDL,
                status: valueStatus,
                maGiaoDich: _codeTrans.text,
                khoangTienTu: _moneyForm.text,
                khoangTienDen: _moneyTo.text);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListResltNormalTransaction(
                  regularTransaction: regularTransaction,
                  acoountCode: _accController.text,
                ),
              ),
            );
          });
        },
        text: 'Tìm kiếm',
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width);
  }
}
