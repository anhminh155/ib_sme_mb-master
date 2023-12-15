// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/tai_khoan_nguon.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/ddAcount/TddAccount_model.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/statement_trans_service.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/bang_ke_cho_duyet.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
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
import '../../../model/JsonSerializable_model/StatementTransfer/statement_transfer_search_model.dart';
import '../../../model/JsonSerializable_model/StatementTransfer/statement_transfer_search_response.dart';

class GiaoDichBangKeChoDuyet extends StatefulWidget {
  const GiaoDichBangKeChoDuyet({super.key});

  @override
  State<GiaoDichBangKeChoDuyet> createState() =>
      _QuanLyGiaoDichThongThuongState();
}

class _QuanLyGiaoDichThongThuongState extends State<GiaoDichBangKeChoDuyet> {
  final sendAccController = TextEditingController(text: 'Tất cả');
  final custController = TextEditingController(text: 'Tất cả');
  final transLotCodeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startAmountController = TextEditingController();
  final endAmountController = TextEditingController();
  final statusController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();
  int page = 0;
  TDDAcount account = TDDAcount();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    sendAccController.dispose();
    transLotCodeController.dispose();
    startAmountController.dispose();
    endDateController.dispose();
    endAmountController.dispose();
    statusController.dispose();
  }

  _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _offLoading() {
    setState(() {
      _isLoading = false;
    });
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
        title: const Text('Giao dịch bảng kê chờ duyệt'),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          _renderBody(),
          if (_isLoading == true) const LoadingCircle()
        ],
      ),
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
                function: (TDDAcount item) {
                  if (mounted) {
                    setState(() {
                      sendAccController.text = item.acctno!;
                      account = item;
                    });
                  }
                },
                selectAll: true,
                value: sendAccController.text,
              ),
              const SizedBox(
                height: 12.0,
              ),
              FormControlWidget(
                label: "User lập lệnh",
                child: InputShowBottomSheet(
                  controller: custController,
                  hintText: "Chọn user lập lệnh",
                  bodyWidget: BottomSheetCode(
                    position: PositionEnum.LAPLENH.value,
                    value: custController.text,
                    handleSelectAccessCode: (String? valueCode, int valueId) {
                      setState(() {
                        custController.text = valueCode!;
                        // if (valueId != 0) {
                        //   userLL = valueCode;
                        // }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              FormControlWidget(
                label: "Mã giao dịch (Mã lô)",
                child: TextFieldWidget(
                  onSubmitted: (value) {},
                  controller: transLotCodeController,
                  hintText: "Nhập mã giao dịch",
                  textInputType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              _renderTimezone1(),
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
                        controller: startAmountController,
                        hintText: "Từ",
                        textInputType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFieldWidget(
                        onSubmitted: (value) {},
                        controller: endAmountController,
                        hintText: "Đến",
                        textInputType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _renderTimezone1() {
    return FormControlWidget(
      label: 'Khoảng thời gian lập',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: DateTimePickerWidget(
                controllerDateTime: startDateController,
                hintText: "Từ ngày",
                maxTime: endDateController.text.isNotEmpty
                    ? DateFormat('dd/MM/yyyy').parse(endDateController.text)
                    : null,
                onConfirm: (date) {
                  setState(() {
                    startDateController.text =
                        DateFormat('dd/MM/yyyy').format(date);
                  });
                },
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: DateTimePickerWidget(
              controllerDateTime: endDateController,
              hintText: "Đến ngày",
              minTime: startDateController.text.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').parse(startDateController.text)
                  : null,
              onConfirm: (date) {
                setState(() {
                  endDateController.text =
                      DateFormat('dd/MM/yyyy').format(date);
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
        onPressed: () => _onSearch(),
        // onPressed: () => _goToNextScreen(),
        text: 'Tìm kiếm',
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width);
  }

  // _goToNextScreen(List<StmTransferResponse> data) {
  _goToNextScreen(TDDAcount account, StmTransferRequest request) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DanhSachBangKeChoDuyet(
                  account: account,
                  request: request,
                )));
  }

  Future<void> _onSearch() async {
    StmTransferRequest request = StmTransferRequest(
        sort: 'createdAt,desc',
        page: page,
        size: 5,
        sendAccount: _removeAllValue(sendAccController.text),
        custCode: _removeAllValue(custController.text),
        transLotCode: transLotCodeController.text,
        startAmount: startAmountController.text,
        endAmount: endAmountController.text,
        startDate: formatDateString(value: startDateController.text),
        endDate: formatDateString(value: endDateController.text),
        status: TRANSLOTSTATUSEUM.CHODUYET.value);
    _onLoading();
    BasePagingResponse response =
        await StatementTransService().searchStmTrans(context, request);
    _offLoading();
    if (response.errorCode == FwError.THANHCONG.value) {
      var items = response.data?.content!
          .map((e) => StmTransferResponse.fromJson(e))
          .toList();
      Provider.of<TransLotProvider>(context, listen: false).setData(
          items: items,
          totalTrans: response.data?.totalElements,
          request: request);
      _goToNextScreen(account, request);
    }
  }

  _removeAllValue(String? value) {
    if (value != null && value != 'Tất cả') {
      return value;
    }
    return '';
  }
}
