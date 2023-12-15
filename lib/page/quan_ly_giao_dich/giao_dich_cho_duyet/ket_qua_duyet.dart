import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/tranSaveContact/trans_save_contact_request.dart';
import 'package:ib_sme_mb_view/page/chuyen_tien/luu_danh_ba_thu_huong.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_giao_dich_thong_thuong/giao_dich_thong_thuong.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:intl/intl.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../enum/enum.dart';
import '../../../utils/theme.dart';
import '../quan_ly_lenh_tuong_lai_dinh_ky/lenh_tuong_lai_dinh_ky.dart';

class KetQuaDuyetWidget extends StatefulWidget {
  final dynamic transTemp;
  final int value;
  const KetQuaDuyetWidget(
      {super.key, required this.transTemp, required this.value});

  @override
  State<KetQuaDuyetWidget> createState() => _KetQuaDuyetWidgetState();
}

class _KetQuaDuyetWidgetState extends State<KetQuaDuyetWidget> {
  var requestBody = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 55,
          title: const Text("Chi tiết giao dịch"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                formKetQuaCust(),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(
                        backgroundColor: secondaryColor,
                        onPressed: _onPressSaveContact,
                        text: "Lưu danh bạ",
                        colorText: Colors.white,
                        haveBorder: false,
                        widthButton: MediaQuery.of(context).size.width * 0.4),
                    ButtonWidget(
                        backgroundColor: secondaryColor,
                        onPressed: () {},
                        text: "Tải chứng từ",
                        colorText: Colors.white,
                        haveBorder: false,
                        widthButton: MediaQuery.of(context).size.width * 0.4),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ButtonWidget(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      Navigator.pop(context, 'Thành công');
                    },
                    text: "Về danh sách duyệt lệnh",
                    colorText: Colors.white,
                    haveBorder: false,
                    widthButton: double.infinity),
              ],
            ),
          ),
        ));
  }

  Widget formKetQuaCust() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 20,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: headerKetQuaCust(),
          ),
          rowSpaceBW('Loại giao dịch',
              TransType.getNameByStringKey(widget.transTemp.type!)),
          rowSpaceBW('Tài khoản thụ hưởng', widget.transTemp.receiveAccount!),
          rowSpaceBW('Tên người thụ hưởng', widget.transTemp.receiveName!),
          rowSpaceBW('Mã giao dịch', widget.transTemp.code!),
          rowSpaceBW('Nội dung', widget.transTemp.content!),
          Text.rich(
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
                    text: widget.value == 1
                        ? '\nQuản lý giao dịch thông thường'
                        : '\nQuản lý giao dịch tương lai định kỳ',
                    // mouseCursor: MouseCursor.uncontrolled,
                    // onEnter: _onEnterQuanLyTrangThaiLenhChoDuyet,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => widget.value == 1
                          ? _onEnterQuanLyGiaoDichThongThuong()
                          : _onEnterQuanLyGiaoDichTuongLaiDinhKy(),
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: primaryColor,
                        decoration: TextDecoration.underline),
                  )
                ]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget rowSpaceBW(String label, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: colorBlack_727374,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          width: 6.0,
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }

  Widget headerKetQuaCust() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.done,
              size: 40,
              color: coloreWhite_EAEBEC,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Duyệt lệnh thành công!",
              style: TextStyle(
                  color: colorBlack_15334A,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              Currency.formatCurrency(
                  double.tryParse(widget.transTemp.amount.toString())),
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(DateTime.parse(widget.transTemp.approvedDate!))
                .toString(),
            style: const TextStyle(
              color: colorBlack_727374,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _onEnterQuanLyGiaoDichThongThuong() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const ListResltNormalTransaction()),
        (route) => route.isFirst);
  }

  void _onEnterQuanLyGiaoDichTuongLaiDinhKy() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const ListResltRecurringFuture()),
        (route) => route.isFirst);
  }

  void _onPressSaveContact() {
    showDialog(
      context: context,
      builder: (context) {
        TransSaveContactRequest request = TransSaveContactRequest(
            product: TransType.getProductTypeByString(widget.transTemp.type!),
            bankReceiving: {"bankCode": widget.transTemp.receiveBankCode!},
            receiveName: widget.transTemp.receiveName!,
            receiveAccount: widget.transTemp.receiveAccount!,
            sortname: widget.transTemp.receiveName!);
        return SaveContacts(
          request: request,
        );
      },
    );
  }
}
