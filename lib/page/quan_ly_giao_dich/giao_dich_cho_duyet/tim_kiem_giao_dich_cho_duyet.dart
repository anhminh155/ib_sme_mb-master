import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/bottom_sheet_code.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/loai_giao_dich_bottomSheet.dart';
import 'package:ib_sme_mb_view/common/tai_khoan_nguon.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_cho_duyet/giao_dich_cho_duyet.dart';
import 'package:intl/intl.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/date_time_picker.dart';
import '../../../common/form/form_control.dart';
import '../../../common/form/input_show_bottom_sheet.dart';
import '../../../common/form_input_and_label/text_field.dart';
import '../../../utils/theme.dart';
import '../../chuyen_tien/danh_ba_thu_huong.dart';

class QuanLyGiaoDichChoDuyet extends StatefulWidget {
  final RolesAcc? rolesAcc;
  const QuanLyGiaoDichChoDuyet({super.key, this.rolesAcc});

  @override
  State<QuanLyGiaoDichChoDuyet> createState() => _QuanLyGiaoDichChoDuyetState();
}

class _QuanLyGiaoDichChoDuyetState extends State<QuanLyGiaoDichChoDuyet> {
  bool isShowSearch = false;
  String? transType;
  TransType? transTypes;
  String? userLL;
  String? userDL;

  final TextEditingController _sendAccController = TextEditingController();
  final TextEditingController _crateTimeFrom = TextEditingController();
  final TextEditingController _crateTimeTo = TextEditingController();
  final TextEditingController _recieveAccController = TextEditingController();
  final TextEditingController _recieveNameController = TextEditingController();
  final TextEditingController _recieveBankController = TextEditingController();
  final TextEditingController _moneyForm = TextEditingController();
  final TextEditingController _moneyTo = TextEditingController();
  final TextEditingController _codeTrans = TextEditingController();
  final TextEditingController _typeTrans =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _setCommand =
      TextEditingController(text: 'Tất cả');
  final TextEditingController _browseCommand =
      TextEditingController(text: 'Tất cả');

  final FocusNode _focusNode = FocusNode();

  final List<StatusTrans> listStatus = [];

  @override
  void dispose() {
    super.dispose();
    _sendAccController.dispose();
    _crateTimeFrom.dispose();
    _crateTimeTo.dispose();
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
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: const Text('Quản lý giao dịch chờ duyệt'),
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
                value: _sendAccController.text,
                function: (TDDAcount item) {
                  if (mounted) {
                    setState(() {
                      _sendAccController.text = item.acctno ?? '';
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
                  controller: _recieveAccController,
                  hintText: "Nhập số tài khoản khoản thụ hưởng",
                  focusNode: _focusNode,
                  textInputType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Visibility(visible: isShowSearch, child: _showSomeSearch())
            ],
          ),
        ),
      ],
    );
  }

  _showSomeSearch() {
    return Column(
      children: [
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
              position: 2,
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
        const SizedBox(
          height: 12.0,
        ),
        FormControlWidget(
          label: "Mã giao dịch",
          child: TextFieldWidget(
            onSubmitted: (value) {},
            controller: _codeTrans,
            hintText: "Nhập mã giao dịch",
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
                  // focusNode: _focusNode,
                  textInputType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldWidget(
                  onSubmitted: (value) {},
                  controller: _moneyTo,
                  hintText: "Đến",
                  // focusNode: _focusNode,
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
          recieveAccController: _recieveAccController,
          recieveNameController: _recieveNameController,
          recieveBankController: _recieveBankController,
          transType: TransType.CORE.value,
        );
      },
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
                controllerDateTime: _crateTimeFrom,
                hintText: "Từ ngày",
                maxTime: _crateTimeTo.text.isNotEmpty
                    ? DateFormat('dd/MM/yyyy').parse(_crateTimeTo.text)
                    : null,
                onConfirm: (date) {
                  setState(() {
                    _crateTimeFrom.text = DateFormat('dd/MM/yyyy').format(date);
                  });
                },
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: DateTimePickerWidget(
              controllerDateTime: _crateTimeTo,
              hintText: "Đến ngày",
              minTime: _crateTimeFrom.text.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').parse(_crateTimeFrom.text)
                  : null,
              onConfirm: (date) {
                setState(() {
                  _crateTimeTo.text = DateFormat('dd/MM/yyyy').format(date);
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
            TranSearch regularTransaction = TranSearch(
                type: transType,
                taiKhoanNguon: _sendAccController.text.compareTo('Tất cả') == 0
                    ? null
                    : _sendAccController.text,
                tenNguoiThuHuong: _recieveNameController.text,
                taiKhoanThuHuong: _recieveAccController.text,
                thoiGianLapLenhTu: _crateTimeFrom.text,
                thoiGianLapLenhDen: _crateTimeTo.text,
                userLapLenh: userLL,
                maGiaoDich: _codeTrans.text,
                khoangTienTu: _moneyForm.text,
                khoangTienDen: _moneyTo.text);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GiaoDichChoDuyetPageWidget(
                          tranSearch: regularTransaction,
                          rolesAcc: widget.rolesAcc,
                        )));
          });
        },
        text: 'Tìm kiếm',
        colorText: Colors.white,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width);
  }
}
