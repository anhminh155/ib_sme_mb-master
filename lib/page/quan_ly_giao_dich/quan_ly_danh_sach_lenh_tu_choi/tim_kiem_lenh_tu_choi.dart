// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/bottom_sheet_code.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/trang_thai_giao_dich_bottomSheet.dart';
import 'package:ib_sme_mb_view/common/tai_khoan_nguon.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/reject_trans_service.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_danh_sach_lenh_tu_choi/danh_sach_lenh_tu_choi.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/date_time_picker.dart';
import '../../../common/dialog_confirm.dart';
import '../../../common/form/form_control.dart';
import '../../../common/form/input_show_bottom_sheet.dart';
import '../../../common/form_input_and_label/text_field.dart';
import '../../../provider/providers.dart';
import '../../chuyen_tien/danh_ba_thu_huong.dart';

class SearchDanhSachLenhTuChoi extends StatefulWidget {
  const SearchDanhSachLenhTuChoi({super.key});

  @override
  State<SearchDanhSachLenhTuChoi> createState() =>
      _SearchDanhSachLenhTuChoiState();
}

class _SearchDanhSachLenhTuChoiState extends State<SearchDanhSachLenhTuChoi> {
  bool _isLoading = false;
  bool isShowSearch = false;
  String currentTranstype = TransType.ALL.value;
  String tranType = "";
  String tranStatus = "";
  final FocusNode _focusNode = FocusNode();
  final tranTypeController = TextEditingController(text: "Tất cả");
  final sendAccController = TextEditingController(text: 'Tất cả');
  final createdTimeFrom = TextEditingController();
  final createdTimeTo = TextEditingController();
  final confirmTimeFrom = TextEditingController();
  final confirmTimeTo = TextEditingController();
  final recieveAccController = TextEditingController();
  final recieveNameController = TextEditingController();
  final recieveBankController = TextEditingController();
  final createdController = TextEditingController(text: "Tất cả");
  final approvedController = TextEditingController(text: "Tất cả");
  final statusTransController = TextEditingController(text: "Tất cả");
  final transCodeController = TextEditingController();
  final amountFrom = TextEditingController();
  final amountTo = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    tranTypeController.dispose();
    sendAccController.dispose();
    createdTimeFrom.dispose();
    createdTimeTo.dispose();
    confirmTimeFrom.dispose();
    confirmTimeTo.dispose();
    recieveAccController.dispose();
    recieveNameController.dispose();
    recieveBankController.dispose();
    createdController.dispose();
    approvedController.dispose();
    statusTransController.dispose();
    transCodeController.dispose();
    amountFrom.dispose();
    amountTo.dispose();
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
        title: const Text('Danh sách lệnh từ chối'),
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
      body: Stack(
        children: [_renderBody(), if (_isLoading) const LoadingCircle()],
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
              renderTransType(),
              const SizedBox(
                height: 12.0,
              ),
              SourceAccount(
                selectAll: true,
                value: sendAccController.text,
                function: (TDDAcount item) {
                  if (mounted) {
                    setState(() {
                      sendAccController.text = item.acctno ?? '';
                    });
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              _renderTimezone1(),
              const SizedBox(
                height: 12.0,
              ),
              _renderTimezone2(),
              if (isShowSearch == true) _showSomeSearch(),
            ],
          ),
        ),
      ],
    );
  }

  renderTransType() {
    return FormControlWidget(
      label: "Loại giao dịch",
      child: InputShowBottomSheet(
          controller: tranTypeController,
          hintText: "Chọn loại giao dịch",
          bodyWidget: buildTransType()),
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
                _showBottomSheet(context);
              },
            ),
            onSubmitted: (value) {},
            controller: recieveAccController,
            hintText: "Nhập số tài khoản khoản thụ hưởng",
            focusNode: _focusNode,
            textInputType: TextInputType.number,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "Tên người thụ hưởng/Nhà cung cấp",
          child: TextFieldWidget(
            onSubmitted: (value) {},
            controller: recieveNameController,
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
            controller: approvedController,
            hintText: "Chọn user lập lệnh",
            bodyWidget: BottomSheetCode(
              position: 2,
              value: approvedController.text,
              handleSelectAccessCode: (String? valueCode, int valueId) {
                setState(() {
                  approvedController.text = valueCode ?? "";
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "User lập lệnh",
          child: InputShowBottomSheet(
            controller: createdController,
            hintText: "Chọn user lập lệnh",
            bodyWidget: BottomSheetCode(
              position: 2,
              value: createdController.text,
              handleSelectAccessCode: (String? valueCode, int valueId) {
                setState(() {
                  createdController.text = valueCode ?? "";
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
              controller: statusTransController,
              hintText: "Trạng thái giao dịch",
              bodyWidget: BottomSheetStatusTrans(
                listRegularTransactionStatus: StatusTrans.values,
                value: statusTransController.text,
                handleSelectAccessCode:
                    (String? stringStatus, dynamic valueStatusTemp) {
                  setState(() {
                    statusTransController.text = stringStatus ?? "";
                    tranStatus = valueStatusTemp.toString();
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
            controller: transCodeController,
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
                  controller: amountFrom,
                  hintText: "Từ",
                  textInputType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldWidget(
                  onSubmitted: (value) {},
                  controller: amountTo,
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

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Constacts(
          recieveAccController: recieveAccController,
          recieveNameController: recieveNameController,
          recieveBankController: recieveBankController,
          transType: TransType.CORE.value,
        );
      },
    );
  }

  buildTransType() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (TransType item in TransType.values)
          InkWell(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  tranTypeController.text =
                      translation(context)!.trans_typeKey(item.name);
                  currentTranstype = item.name;
                  tranType = item.value;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: (TransType.values.indexOf(item) !=
                        TransType.values.length - 1)
                    ? const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: coloreWhite_EAEBEC),
                        ),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translation(context)!.trans_typeKey(item.name),
                      style: TextStyle(
                        fontSize: 16,
                        color: (currentTranstype == item.name)
                            ? primaryColor
                            : primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (currentTranstype == item.name)
                        ? const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: primaryColor,
                            size: 24,
                          )
                        : const SizedBox(),
                  ],
                ),
              )),
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
                controllerDateTime: createdTimeFrom,
                hintText: "Từ ngày",
                maxTime: createdTimeFrom.text.isNotEmpty
                    ? DateFormat('dd/MM/yyyy').parse(createdTimeFrom.text)
                    : null,
                onConfirm: (date) {
                  setState(() {
                    createdTimeFrom.text =
                        DateFormat('dd/MM/yyyy').format(date);
                  });
                },
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: DateTimePickerWidget(
              controllerDateTime: createdTimeTo,
              hintText: "Đến ngày",
              minTime: createdTimeTo.text.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').parse(createdTimeTo.text)
                  : null,
              onConfirm: (date) {
                setState(() {
                  createdTimeTo.text = DateFormat('dd/MM/yyyy').format(date);
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
                controllerDateTime: confirmTimeFrom,
                hintText: "Từ ngày",
                maxTime: confirmTimeFrom.text.isNotEmpty
                    ? DateFormat('dd/MM/yyyy').parse(confirmTimeFrom.text)
                    : null,
                onConfirm: (date) {
                  setState(() {
                    confirmTimeFrom.text =
                        DateFormat('dd/MM/yyyy').format(date);
                  });
                },
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: DateTimePickerWidget(
              controllerDateTime: confirmTimeTo,
              hintText: "Đến ngày",
              minTime: confirmTimeTo.text.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').parse(confirmTimeTo.text)
                  : null,
              onConfirm: (date) {
                setState(() {
                  confirmTimeTo.text = DateFormat('dd/MM/yyyy').format(date);
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
    try {
      var requestTT = _getRequestTT();
      var requestTL = _getRequestTL();
      setState(() => _isLoading = true);
      BasePagingResponse responseTT =
          await RejectTransactionService().getTTTransaction(requestTT);
      BasePagingResponse responseTL =
          await RejectTransactionService().getTLTransaction(requestTL);
      setState(() => _isLoading = false);

      if (responseTT.errorCode == FwError.THANHCONG.value &&
          responseTL.errorCode == FwError.THANHCONG.value) {
        var transTT = responseTT.data!.content!
            .map((e) => RejectTransResponse.fromJson(e))
            .toList();

        var transTL = responseTL.data!.content!
            .map((e) => RejectTransResponse.fromJson(e))
            .toList();
        await Provider.of<RejectTransProvider>(context, listen: false)
            .setTransTT(
                listTransTT: transTT,
                requestTT: requestTT,
                totalTransTT: responseTT.data!.totalElements);
        await Provider.of<RejectTransProvider>(context, listen: false)
            .setTransTL(
                listTransTL: transTL,
                requestTL: requestTL,
                totalTransTL: responseTL.data!.totalElements);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DanhSachLenhTuChoi(),
            ));
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _getRequestTT() {
    RejectTransSearchRequest request = RejectTransSearchRequest();
    request.type = _removeAllValue(tranType);
    request.taiKhoanNguon = _removeAllValue(sendAccController.text);
    request.tenNguoiThuHuong = _removeAllValue(recieveNameController.text);
    request.taiKhoanThuHuong = _removeAllValue(sendAccController.text);
    request.thoiGianLapLenhTu = createdTimeFrom.text;
    request.thoiGianLapLenhDen = createdTimeTo.text;
    request.thoiGianDuyetLenhTu = confirmTimeFrom.text;
    request.thoiGianLapLenhDen = createdTimeTo.text;
    request.userLapLenh = _removeAllValue(createdController.text);
    request.userDuyetLenh = _removeAllValue(approvedController.text);
    request.status = _removeAllValue(tranStatus);
    request.maGiaoDich = _removeAllValue(transCodeController.text);
    request.khoangTienTu = _removeAllValue(amountFrom.text);
    request.khoangTienDen = _removeAllValue(amountTo.text);
    request.sort = "createdAt,desc";
    request.size = 5;
    request.page = 0;
    return request;
  }

  _getRequestTL() {
    RejectTransSearchRequest request = RejectTransSearchRequest();
    if (currentTranstype.contains("DK")) {
      request.schedule = 1;
    }
    if (currentTranstype.contains("TL")) {
      request.schedule = 0;
    }
    request.type = _removeAllValue(tranType);
    request.taiKhoanNguon = _removeAllValue(sendAccController.text);
    request.tenNguoiThuHuong = _removeAllValue(recieveNameController.text);
    request.taiKhoanThuHuong = _removeAllValue(sendAccController.text);
    request.thoiGianLapLenhTu = createdTimeFrom.text;
    request.thoiGianLapLenhDen = createdTimeTo.text;
    request.thoiGianDuyetLenhTu = confirmTimeFrom.text;
    request.thoiGianLapLenhDen = createdTimeTo.text;
    request.userLapLenh = _removeAllValue(createdController.text);
    request.userDuyetLenh = _removeAllValue(approvedController.text);
    request.status = _removeAllValue(tranStatus);
    request.maGiaoDich = _removeAllValue(transCodeController.text);
    request.khoangTienTu = _removeAllValue(amountFrom.text);
    request.khoangTienDen = _removeAllValue(amountTo.text);
    request.sort = "createdAt,desc";
    request.size = 5;
    request.page = 0;
    return request;
  }

  static _removeAllValue(String? value) {
    if (value != null && value != 'Tất cả') {
      return value;
    }
    return '';
  }
}
