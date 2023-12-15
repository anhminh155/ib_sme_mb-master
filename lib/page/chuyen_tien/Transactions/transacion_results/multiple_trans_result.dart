// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../../../common/button.dart';
import '../../../../common/form_input_and_label/label.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../../provider/providers.dart';
import '../../../../utils/formatCurrency.dart';
import '../../../../utils/formatDatetime.dart';
import '../../../../utils/theme.dart';
import 'dart:ui' as ui;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import '../../../quan_ly_giao_dich/giao_dich_cho_duyet/giao_dich_cho_duyet.dart';
import '../../luu_danh_ba_thu_huong.dart';
import '../transaction_create/transaction_create.dart';

class MultipleTransResults extends StatefulWidget {
  final List<ListTransactionResponse> listTrans;
  final String transType;
  const MultipleTransResults({
    super.key,
    required this.transType,
    required this.listTrans,
  });

  @override
  State<MultipleTransResults> createState() => _MultipleTransResultsState();
}

class _MultipleTransResultsState extends State<MultipleTransResults> {
  final GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(translation(context)!.trans_typeKey(widget.transType)),
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        children: [
          _ketQuaCard(),
          // _ketQuaNote(),
          renderSpace(20),
          ButtonWidget(
              text: "Thực hiện giao dịch mới",
              backgroundColor: primaryColor,
              haveBorder: false,
              widthButton: MediaQuery.of(context).size.width,
              colorText: Colors.white,
              onPressed: _gotoCreateTransscreen),
          renderSpace(20),
        ],
      ),
    );
  }

  Widget _ketQuaCard() {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(139, 146, 165, 0.24),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: renderBody(),
      ),
    );
  }

  renderBody() {
    return Column(
      children: [
        renderSpace(20),
        SvgPicture.asset("assets/icons/check_result.svg"),
        const Text(
          "Giao dịch thành công",
          style: TextStyle(
            fontSize: 20,
            height: 1.5,
            fontWeight: FontWeight.w700,
            color: colorBlack_363E46,
          ),
        ),
        renderSpace(4),
        Text(
          Currency.formatCurrency(_getAllAmount()),
          style: TextStyle(
            fontSize: 18,
            height: 1,
            fontWeight: FontWeight.w700,
            color: colorBlack_363E46,
          ),
        ),
        renderSpace(4),
        Text(
          convertDateTimeFormat(widget.listTrans[0].data.createdAt),
          // DateTime.now().toLocal().toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colorBlack_363E46,
          ),
        ),
        renderSpace(10),
        renderListResults(),
        renderSpace(5),
        _ketQuaNote(),
      ],
    );
  }

  _getAllAmount() {
    int amount = 0;
    for (var element in widget.listTrans) {
      amount += int.parse(Currency.removeFormatNumber(element.data.amount));
    }
    return amount;
  }

  renderSpace(double size) => SizedBox(height: size);

  renderListResults() {
    return Column(
      children: [
        for (var i = 0; i < widget.listTrans.length; i++)
          Column(
            children: [
              InkWell(
                onTap: () => _showModelSheetInfo(i),
                child: ListTile(
                  leading: Container(
                      width: 50, // Đặt chiều rộng của Container tùy ý
                      height: 50, // Đặt chiều cao của Container tùy ý
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape
                            .circle, // Đặt hình dạng của Container là hình tròn
                        border: Border.all(
                          color: primaryColor, // Đặt màu biên viền
                          width: 2, // Đặt độ dày biên viền
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                  title: Text(widget.listTrans[i].data.receiveName.toString()),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            renderSpace(5),
                            Text(widget.listTrans[i].data.receiveAccount
                                .toString()),
                            renderSpace(10),
                            const Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                            renderSpace(10),
                            Text(
                                '${widget.listTrans[i].data.amount.toString()} VND'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.check_circle_sharp,
                              color: secondaryColor,
                            ),
                            Icon(Icons.navigate_next_sharp)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              renderSpace(10)
            ],
          )
      ],
    );
  }

  Widget _ketQuaNote() {
    var rolesAcc =
        Provider.of<CustInfoProvider>(context, listen: false).item?.roles;
    if (rolesAcc?.type == CompanyTypeEnum.MOHINHCAP2.value) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text.rich(
          TextSpan(
              text: 'Để kiểm tra lại thông tin giao dịch. Quý khách vui lòng '
                  'truy cập chức năng ',
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: colorBlack_727374,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: 'Quản lý trạng thái lệnh chờ duyệt',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _onEnterLinkScreent(),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: primaryColor,
                  ),
                )
              ]),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _onEnterLinkScreent() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const GiaoDichChoDuyetPageWidget(),
        ),
        (route) => route.isFirst);
  }

  _showModelSheetInfo(index) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    child: Text(
                      'Chi tiết',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Đóng',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  renderField("Số tài khoản",
                      widget.listTrans[index].data.receiveAccount),
                  renderLine(),
                  renderField("Người thụ hưởng",
                      widget.listTrans[index].data.receiveName),
                  renderLine(),
                  renderField(
                      "Ngân hàng", widget.listTrans[index].data.receiveBank),
                  renderLine(),
                  renderField(
                      "Số tiền",
                      Currency.formatCurrency(
                          int.parse(widget.listTrans[index].data.amount))),
                  renderReadAmout(Currency.removeFormatNumber(
                      widget.listTrans[index].data.amount)),
                  renderLine(),
                  renderField("Nội dung", widget.listTrans[index].data.content),
                  renderLine(),
                  renderField(
                      "Mã giao dịch", widget.listTrans[index].data.code),
                  renderLine(),
                  renderBtns(index)
                ],
              ),
            )
          ],
        );
      },
    );
  }

  renderLine() {
    return Divider(
      color: coloreWhite_EAEBEC, // Màu của đường kẻ
      thickness: 1.0, // Độ dày của đường kẻ
    );
  }

  renderField(lable, data) {
    return Center(
      child: LabelWidget(
        colors: colorBlack_727374,
        label: lable,
        fontWeight: FontWeight.w500,
        child: Text(
          data,
          style: const TextStyle(
            color: primaryBlackColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget renderBtns(index) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonWidget(
                  backgroundColor: secondaryColor,
                  onPressed: () async => _captureAndSharePng(),
                  text: 'Chia sẻ',
                  colorText: Colors.white,
                  haveBorder: false,
                  widthButton: MediaQuery.of(context).size.width * .45),
              ButtonWidget(
                  text: "Lưu danh bạ",
                  backgroundColor: secondaryColor,
                  haveBorder: false,
                  widthButton: MediaQuery.of(context).size.width * .45,
                  colorText: Colors.white,
                  onPressed: () => _onPressSaveContact(index)),
            ],
          ),
        ],
      ),
    );
  }

  void _onPressSaveContact(index) {
    TransSaveContactRequest request = TransSaveContactRequest(
        product: TransType.getProductTypeByString(widget.transType),
        bankReceiving: {
          "bankCode": widget.listTrans[index].data.receiveBankCode
        },
        receiveName: widget.listTrans[index].data.receiveName,
        receiveAccount: widget.listTrans[index].data.receiveAccount,
        sortname: widget.listTrans[index].data.receiveName);
    showDialog(
      context: context,
      builder: (context) {
        return SaveContacts(
          request: request,
        );
      },
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      // ignore: use_build_context_synchronously

      //Save the image to device gallery
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          await File('${directory.path}/chuyen_tien.png').create();
      await imagePath.writeAsBytes(pngBytes);

      Share.shareFiles([imagePath.path]);
    } catch (_) {}
  }

  renderReadAmout(String amount) {
    if (amount.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Text(
          Currency.numberToWords(int.parse(amount)),
          style: const TextStyle(color: primaryColor),
          textAlign: TextAlign.left,
        ),
      );
    }
    return Container();
  }

  _gotoCreateTransscreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionsCreate(
            tranType: widget.transType,
          ),
        ),
        (route) => route.isFirst);
  }
}
