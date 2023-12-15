import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/cau_hoi_thuong_gap.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/dieu_khoan_dich_vu.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/huong_dan_su_dung.dart';
import '../../../../../utils/theme.dart';

class TienIchWidget extends StatefulWidget {
  const TienIchWidget({Key? key}) : super(key: key);

  @override
  State<TienIchWidget> createState() => _TienIchWidgetState();
}

class _TienIchWidgetState extends State<TienIchWidget> {
  late int currentSelect = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSheet();
  }

  buildSheet() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 3.5,
            width: 30,
            margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: (MediaQuery.of(context).size.width * 0.45)),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                translation(context)!.utilitiesKey,
                style: const TextStyle(
                    fontSize: 18,
                    color: colorBlack_15334A,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    renderIconAction(
                        title: translation(context)!.instructionKey,
                        icons: SvgPicture.asset("assets/icons/Book.svg"),
                        onClicked: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HuongDanSuDungScreen()));
                        }),
                    renderIconAction(
                        title:
                            translation(context)!.frequently_asked_questionsKey,
                        icons: SvgPicture.asset(
                          "assets/icons/Question.svg",
                          // ignore: deprecated_member_use
                          color: Colors.white,
                        ),
                        onClicked: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CauHoiThuongGapScreen()));
                        }),
                    renderIconAction(
                        title: translation(context)!.terms_of_serviceKey,
                        icons:
                            SvgPicture.asset("assets/icons/BookBookmark.svg"),
                        onClicked: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const DieuKhoanDichVuScreen())));
                        }),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    renderIconAction(
                        title: translation(context)!.search_interest_rateKey,
                        icons: SvgPicture.asset("assets/icons/TrendUp.svg"),
                        onClicked: () {
                          showToast(
                            context: context,
                            msg: 'Chức năng này đang được cập nhật',
                            color: Colors.orange,
                          );
                        }),
                    renderIconAction(
                        title: translation(context)!.search_exchange_rateKey,
                        icons: SvgPicture.asset("assets/icons/Money.svg"),
                        onClicked: () {
                          showToast(
                            context: context,
                            msg: 'Chức năng này đang được cập nhật',
                            color: Colors.orange,
                          );
                        }),
                    renderIconAction(
                        title: translation(context)!.service_fee_scheduleKey,
                        icons: SvgPicture.asset("assets/icons/Table.svg"),
                        onClicked: () {
                          showToast(
                            context: context,
                            msg: 'Chức năng này đang được cập nhật',
                            color: Colors.orange,
                          );
                        }),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  renderIconAction({title, icons, onClicked}) {
    return SizedBox(
      width: 100,
      height: 100,
      child: InkWell(
        onTap: onClicked,
        child: Column(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: icons,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                    color: colorBlack_363E46, fontSize: 12, height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
