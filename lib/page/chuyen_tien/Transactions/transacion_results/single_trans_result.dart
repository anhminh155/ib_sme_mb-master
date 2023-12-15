import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/chuyen_tien/luu_danh_ba_thu_huong.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../../../../common/button.dart';
import 'dart:ui' as ui;
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../../provider/custInfo_provider.dart';
import '../../../../utils/formatDatetime.dart';
import '../../../quan_ly_giao_dich/giao_dich_cho_duyet/giao_dich_cho_duyet.dart';
import '../transaction_create/transaction_create.dart';

class SingleTranResult extends StatefulWidget {
  final TransactionResponse response;
  final String transType;
  const SingleTranResult(
      {super.key, required this.response, required this.transType});

  @override
  State<SingleTranResult> createState() => _SingleTranResultState();
}

class _SingleTranResultState extends State<SingleTranResult> {
  final GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home))
        ],
        centerTitle: true,
        title: Text(translation(context)!.trans_typeKey(widget.transType)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        children: [
          const SizedBox(height: 40),
          _ketQuaCard(),
          _ketQuaNote(),
          _ketQuaBtn(),
        ],
      ),
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

  Widget _ketQuaCard() {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
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

  Widget _ketQuaNote() {
    var rolesAcc =
        Provider.of<CustInfoProvider>(context, listen: false).item?.roles;
    if (rolesAcc?.type == CompanyTypeEnum.MOHINHCAP2.value) {
      return Container(
        padding: const EdgeInsets.only(top: 12),
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
    }
    return const SizedBox();
  }

  Widget _ketQuaBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 35),
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
                  haveBorder: true,
                  colorBorder: secondaryColor,
                  widthButton: MediaQuery.of(context).size.width * .45),
              ButtonWidget(
                text: 'Lưu danh bạ',
                colorText: Colors.white,
                haveBorder: true,
                colorBorder: secondaryColor,
                widthButton: MediaQuery.of(context).size.width * .45,
                onPressed: _onPressSaveContact,
                backgroundColor: secondaryColor,
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          ButtonWidget(
              text: "Thực hiện giao dịch mới",
              backgroundColor: primaryColor,
              haveBorder: false,
              widthButton: MediaQuery.of(context).size.width,
              colorText: Colors.white,
              onPressed: _gotoCreateTransscreen),
        ],
      ),
    );
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

  renderBody() {
    return Center(
      child: Column(
        children: [
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
          const SizedBox(height: 4),
          Text(
            Currency.formatCurrency(int.tryParse(widget.response.amount) ?? 0),
            style: const TextStyle(
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.w700,
              color: colorBlack_363E46,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            convertDateTimeFormat(widget.response.createdAt),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: colorBlack_363E46,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          _itemContent(
              label: "Số tài khoản", content: widget.response.receiveAccount),
          const Divider(
            height: 0.1,
          ),
          _itemContent(
              label: "Người thụ hưởng", content: widget.response.receiveName),
          const Divider(
            height: 0.1,
          ),
          _itemContent(
              label: "Ngân hàng", content: widget.response.receiveBank),
          const Divider(
            height: 1,
          ),
          _itemContent(
              label: "Loại giao dịch",
              content: translation(context)!.trans_typeKey(widget.transType)),
          const Divider(
            height: 0.1,
          ),
          _itemContent(label: "Nội dung", content: widget.response.content),
          const Divider(
            height: 0.1,
          ),
          _itemContent(label: "Mã giao dịch", content: widget.response.code),
          const Divider(
            height: 0.1,
          ),
        ],
      ),
    );
  }

  _itemContent({label, content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                  color: colorBlack_727374,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.5),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _onEnterLinkScreent() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GiaoDichChoDuyetPageWidget(),
        ));
  }

  void _onPressSaveContact() {
    TransSaveContactRequest request = TransSaveContactRequest(
        product: TransType.getProductTypeByString(widget.transType),
        bankReceiving: {"bankCode": widget.response.receiveBankCode},
        receiveName: widget.response.receiveName,
        receiveAccount: widget.response.receiveAccount,
        sortname: widget.response.receiveName);
    showDialog(
      context: context,
      builder: (context) {
        return SaveContacts(request: request);
      },
    );
  }
}
