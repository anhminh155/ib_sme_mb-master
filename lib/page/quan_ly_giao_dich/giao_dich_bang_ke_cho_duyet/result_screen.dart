import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/statement_trans_service.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_trang_thai_bang_ke/tim_kiem_trang_thai_bang_ke.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
// ignore: depend_on_referenced_packages

import '../../../../../common/button.dart';

import '../../../../utils/formatDatetime.dart';

class TransLotResultScreen extends StatefulWidget {
  final StmTransferResponse tran;
  const TransLotResultScreen({super.key, required this.tran});

  @override
  State<TransLotResultScreen> createState() => _TransLotResultState();
}

class _TransLotResultState extends State<TransLotResultScreen> {
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
        title: const Text('Duyệt bảng kê'),
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

  _goBack() {
    Navigator.pop(context);
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
                text: 'Quản lý giao dịch bảng kê',
                // mouseCursor: MouseCursor.uncontrolled,
                // onEnter: _onEnterQuanLyTrangThaiLenhChoDuyet,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _onEnterQuanLyGiaoDichBangKe,
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

  Widget _ketQuaBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonWidget(
              backgroundColor: primaryColor,
              onPressed: _goBack,
              text: 'Về danh sách',
              colorText: Colors.white,
              haveBorder: true,
              colorBorder: secondaryColor,
              widthButton: MediaQuery.of(context).size.width * .45),
          ButtonWidget(
            text: 'Tải bảng kê',
            colorText: Colors.white,
            haveBorder: true,
            colorBorder: secondaryColor,
            widthButton: MediaQuery.of(context).size.width * .45,
            onPressed: _downloadFile,
            backgroundColor: secondaryColor,
          ),
        ],
      ),
    );
  }

  renderBody() {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset("assets/icons/check_result.svg"),
          const Text(
            "Duyệt lệnh thành công!",
            style: TextStyle(
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.w700,
              color: colorBlack_363E46,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Currency.formatCurrency(int.parse(widget.tran.amount!)),
            style: const TextStyle(
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.w700,
              color: colorBlack_363E46,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            convertDateTimeFormat(widget.tran.createdAt.toString()),
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
              label: "Mục đích thanh toán", content: widget.tran.content),
          const Divider(
            height: 0.1,
          ),
          _itemContent(label: "Mã giao dịch", content: widget.tran.code),
          const Divider(
            height: 0.1,
          ),
          _itemContent(label: "Nội dung", content: widget.tran.content),
          const Divider(
            height: 1,
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
          const SizedBox(
            width: 20,
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

  void _onEnterQuanLyGiaoDichBangKe() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const QuanLyGiaoDichBangKe()),
        (route) => route.isFirst);
  }

  Future<void> _downloadFile() async {
    StatementTransService().downloadTransLotDetail(context, widget.tran.code!);
  }
}

class FavoriteServiceItem extends StatelessWidget {
  final String iconPath;
  final String text;
  const FavoriteServiceItem(
      {super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorBlack_727374,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
