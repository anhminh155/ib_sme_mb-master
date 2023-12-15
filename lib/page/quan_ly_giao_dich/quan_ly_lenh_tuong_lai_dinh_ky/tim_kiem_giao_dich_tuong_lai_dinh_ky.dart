import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/loai_giao_dich_bottomSheet.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/trang_thai_giao_dich_bottomSheet.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/transSearch/trans_search.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_lenh_tuong_lai_dinh_ky/lenh_tuong_lai_dinh_ky.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';

import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/date_time_picker.dart';
import '../../../common/form/form_control.dart';
import '../../../common/form/input_show_bottom_sheet.dart';

class QuanLyLenhTuongLaiDinhKy extends StatefulWidget {
  const QuanLyLenhTuongLaiDinhKy({super.key});

  @override
  State<QuanLyLenhTuongLaiDinhKy> createState() =>
      _QuanLyLenhTuongLaiDinhKyState();
}

class _QuanLyLenhTuongLaiDinhKyState extends State<QuanLyLenhTuongLaiDinhKy> {
  bool isShowSearch = false;
  String? transType;
  TransType? transTypes;
  String? valueStatus;

  List<String> listTieuChi = ['Theo thời gian', 'Theo trạng thái giao dịch'];
  List<StatusPaymentTrans> listStatus = [
    StatusPaymentTrans.TATCA,
    StatusPaymentTrans.CHOXULY,
    StatusPaymentTrans.THANHCONG,
    StatusPaymentTrans.LOI,
    StatusPaymentTrans.HUY,
  ];

  final TextEditingController _typeTransfer = TextEditingController();
  final TextEditingController _crateTimeFrom = TextEditingController();
  final TextEditingController _crateTimeTo = TextEditingController();
  final TextEditingController _searchCriteria = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _statusTrans = TextEditingController();

  @override
  void initState() {
    _statusTrans.text = 'Tất cả';
    _searchCriteria.text = 'Theo thời gian';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _typeTransfer.dispose();
    _crateTimeFrom.dispose();
    _crateTimeTo.dispose();
    _searchCriteria.dispose();
    _code.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        titleSpacing: 0.0,
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: const Text('Quản lý lệnh tương lai/định kỳ'),
        backgroundColor: primaryColor,
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
                    controller: _typeTransfer,
                    hintText: "Chọn loại giao dịch",
                    bodyWidget: BottomSheetTypeTrans(
                      value: _typeTransfer.text,
                      handleSelectAccessCode: (String? value,
                          String? transTypeTemp, TransType? transTypeTemps) {
                        setState(() {
                          _typeTransfer.text = value!;
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
              FormControlWidget(
                label: "Tiêu chí tìm kiếm",
                child: InputShowBottomSheet(
                    controller: _searchCriteria,
                    hintText: "Chọn tiêu chí tìm kiếm",
                    bodyWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (String item in listTieuChi)
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  _searchCriteria.text = item;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                decoration: (listTieuChi.indexOf(item) !=
                                        listTieuChi.length - 1)
                                    ? const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: coloreWhite_EAEBEC),
                                        ),
                                      )
                                    : null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: (_searchCriteria.text
                                                    .compareTo(item) ==
                                                0)
                                            ? primaryColor
                                            : primaryBlackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    (_searchCriteria.text.compareTo(item) == 0)
                                        ? const Icon(
                                            CupertinoIcons
                                                .checkmark_alt_circle_fill,
                                            color: primaryColor,
                                            size: 24,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )),
                      ],
                    )),
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (_searchCriteria.text.compareTo('Theo thời gian') == 0)
                _renderTimezone1(),
              if (_searchCriteria.text.compareTo('Theo trạng thái giao dịch') ==
                  0)
                FormControlWidget(
                  label: "Trạng thái giao dịch",
                  child: InputShowBottomSheet(
                      controller: _statusTrans,
                      hintText: "Trạng thái giao dịch",
                      bodyWidget: BottomSheetStatusTrans(
                        listScheduleTransactionStatus: listStatus,
                        value: _statusTrans.text,
                        handleSelectAccessCode:
                            (String? stringStatus, int? valueStatusTemp) {
                          setState(() {
                            _statusTrans.text = stringStatus!;
                            if (valueStatusTemp != null) {
                              valueStatus = valueStatusTemp.toString();
                            } else {
                              valueStatus = null;
                            }
                          });
                        },
                      )),
                ),
              const SizedBox(
                height: 12.0,
              ),
              InputFormWidget(
                label: "Mã tham chiếu",
                readOnly: false,
                controller: _code,
                hintText: "Nhập mã",
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Quý khách có thể tra cứu trạng thái lệnh chuyển tiền định kỳ, chuyển tiền tương lai trên ứng dụng CBWay Biz",
            style: TextStyle(color: Colors.green, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  DateFormat format = DateFormat('dd/MM/yyyy');
  DateTime dateNow = DateTime.now();
  _renderTimezone1() {
    return FormControlWidget(
      label: 'Khoảng thời gian',
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

  _renderButtons() {
    return ButtonWidget(
        backgroundColor: primaryColor,
        onPressed: () {
          setState(() {
            // if (isShowSearch == true) {
            //   isShowSearch = false;
            // }
            TranSearch tranSearchSchedule =
                _searchCriteria.text.compareTo('Theo thời gian') == 0
                    ? TranSearch(
                        type: transType,
                        thoiGianLapLenhTu: _crateTimeFrom.text,
                        thoiGianLapLenhDen: _crateTimeTo.text,
                        maGiaoDich: _code.text)
                    : TranSearch(
                        type: transType,
                        paymentStatus: valueStatus,
                        maGiaoDich: _code.text);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListResltRecurringFuture(
                          tranSearch: tranSearchSchedule,
                        )));
          });
        },
        text: 'Tìm kiếm',
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width);
  }
}
