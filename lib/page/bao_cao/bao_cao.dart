import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/tai_khoan_nguon.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/reportTransfeeResponse/reportTransfee_response.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:intl/intl.dart';
import '../../../common/button.dart';
import '../../../common/date_time_picker.dart';
import '../../../common/form/form_control.dart';
import '../../../utils/theme.dart';
import '../../../model/models.dart';
import '../../network/services/transmanagement_service/report_transfee_service.dart';

class BaoCaoPhiGaoDich extends StatefulWidget {
  final int routate;
  //routate = 0 no leading  routate = 1 have leading
  const BaoCaoPhiGaoDich({super.key, required this.routate});

  @override
  State<BaoCaoPhiGaoDich> createState() => _BaoCaoPhiGaoDichState();
}

class _BaoCaoPhiGaoDichState extends State<BaoCaoPhiGaoDich> {
  final accontController = TextEditingController();
  final timeStartController = TextEditingController();
  final timeEndController = TextEditingController();
  DateTime initDate = DateTime.now();
  final format = DateFormat('dd/MM/yyyy');
  bool _isLoading = false;
  double totalAmount = 0;
  double totalFee = 0;
  int totalTrans = 0;

  @override
  void initState() {
    super.initState();
    _onpressSearch();
    accontController.text = 'Tất cả';
  }

  @override
  void dispose() {
    super.dispose();
    accontController.dispose();
    timeEndController.dispose();
    timeStartController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          toolbarHeight: 55,
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
          title: const Text("Báo cáo chi phí giao dịch"),
          backgroundColor: primaryColor,
          automaticallyImplyLeading: widget.routate == 1 ? true : false,
        ),
        body: Stack(
          children: [renderBody(), if (_isLoading) const LoadingCircle()],
        ));
  }

  renderBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: CardLayoutWidget(
              child: renderSearch(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: renderContent(),
          ),
          const SizedBox(
            height: 16.0,
          )
        ],
      ),
    );
  }

  renderSearch() {
    return Column(
      children: [
        SourceAccount(
          function: (TDDAcount item) {
            setState(() => accontController.text = item.acctno ?? 'Tất cả');
          },
          value: accontController.text,
          selectAll: true,
        ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: 'Thời gian',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DateTimePickerWidget(
                    controllerDateTime: timeStartController,
                    hintText: "Từ ngày",
                    maxTime: timeEndController.text.isNotEmpty
                        ? format.parse(timeEndController.text)
                        : null,
                    minTime: format.parse(format.format(DateTime(
                        initDate.year, initDate.month - 6, initDate.day))),
                    onConfirm: (date) {
                      setState(() {
                        timeStartController.text = format.format(date);
                        if (timeEndController.text.isEmpty) {
                          timeEndController.text = DateTime(
                                      date.year, date.month + 3, date.day)
                                  .isBefore(initDate)
                              ? format.format(
                                  DateTime(date.year, date.month + 3, date.day))
                              : format.format(initDate);
                        } else if (DateTime(date.year, date.month + 3, date.day)
                            .isBefore(format.parse(timeEndController.text))) {
                          timeEndController.text = format.format(
                              DateTime(date.year, date.month + 3, date.day));
                        }
                      });
                    },
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DateTimePickerWidget(
                  controllerDateTime: timeEndController,
                  hintText: "Đến ngày",
                  minTime: timeStartController.text.isNotEmpty
                      ? format.parse(timeStartController.text)
                      : format.parse(format.format(DateTime(
                          initDate.year, initDate.month - 6, initDate.day))),
                  maxTime: (timeStartController.text.isNotEmpty &&
                          (format.parse(timeStartController.text).month + 3) <
                              initDate.month)
                      ? DateTime(
                          format.parse(timeStartController.text).year,
                          format.parse(timeStartController.text).month + 3,
                          format.parse(timeStartController.text).day)
                      : null,
                  onConfirm: (date) {
                    setState(() {
                      timeEndController.text = format.format(date);
                      if (timeStartController.text.isEmpty) {
                        timeStartController.text = DateTime(
                                    date.year, date.month - 3, date.day)
                                .isBefore(DateTime(initDate.year,
                                    initDate.month - 6, initDate.day))
                            ? format.format(DateTime(initDate.year,
                                initDate.month - 6, initDate.day))
                            : format.format(
                                DateTime(date.year, date.month - 3, date.day));
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        ButtonWidget(
            backgroundColor: primaryColor,
            onPressed: () => _onpressSearch(),
            text: 'Tìm kiếm',
            colorText: Colors.white,
            haveBorder: false,
            widthButton: MediaQuery.of(context).size.width),
      ],
    );
  }

  Future<void> _onpressSearch() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    ReportTransfeeRequest request = ReportTransfeeRequest(
        timeStartController.text,
        timeEndController.text,
        accontController.text == 'Tất cả' ? '' : accontController.text);
    BaseResponse baseResponse =
        await ReportTransfeeService().searchReportTransfee(request);
    if (mounted) {
      setState(() => _isLoading = false);
    }
    if (baseResponse.errorCode == FwError.THANHCONG.value) {
      ReportTransfeeResponse response =
          ReportTransfeeResponse.fromJson(baseResponse.data);
      if (mounted) {
        setState(() {
          totalAmount = response.amount;
          totalFee = response.fee;
          totalTrans = response.list['totalElements'];
        });
      }
    }
  }

  renderContent() {
    return CardLayoutWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _exportData,
            child:
                const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(
                Icons.download,
                color: primaryColor,
              ),
              Text(
                "Tải danh sách",
                style: TextStyle(color: primaryColor),
              )
            ]),
          ),
          renderBox(
              label: "Tổng số giao dịch :",
              value: Currency.formatNumber(totalTrans)),
          renderBox(
              label: "Số tiền giao dịch :",
              value: Currency.formatCurrency(totalAmount)),
          renderBox(
              label: "Tổng số tiền phí :",
              value: Currency.formatCurrency(totalFee))
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ReportTransfeeService().downloadFile(context);
    } catch (_) {}
    setState(() {
      _isLoading = false;
    });
  }

  renderBox({label, value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: primaryColor),
                  ),
                  Text(
                    value.toString(),
                    style: const TextStyle(color: secondaryColor),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
