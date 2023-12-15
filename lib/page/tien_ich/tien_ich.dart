import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/divider.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/login/actionButton/location_screen.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/cau_hoi_thuong_gap.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/dieu_khoan_dich_vu.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/lien_he.dart';
import 'package:ib_sme_mb_view/page/tien_ich/quan_ly_danh_ba/quan_ly_danh_ba_hoa_don/quan_ly_danh_ba_hoa_don.dart';
import 'package:ib_sme_mb_view/page/tien_ich/quan_ly_danh_ba/quan_ly_danh_ba_thu_huong/danh_ba_thu_huong.dart';
import 'package:ib_sme_mb_view/page/tien_ich/tien_ich_chung/doi_mat_khau.dart';
import 'package:ib_sme_mb_view/page/tien_ich/tien_ich_chung/tao_ten_goi_nho.dart';
import 'package:ib_sme_mb_view/page/tien_ich/tra_cuu/tra_cuu_lai_suat_tien_gui_co_ky_han.dart';
import 'package:ib_sme_mb_view/page/tien_ich/tra_cuu/tra_cuu_ty_gia_ngoai_te.dart';

import '../../common/select_menu_button.dart';

class TienIchPageWidget extends StatelessWidget {
  const TienIchPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(translation(context)!.utilitiesKey),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: renderBodySetting(context),
      ),
    );
  }

  renderBodySetting(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleListMenu(title: translation(context)!.general_utilitiesKey),
          const SizedBox(
            height: 20,
          ),
          CardLayoutWidget(
            child: Column(
              children: [
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/changePass.png",
                  content: translation(context)!.change_passwordKey,
                  widget: const DoiMatKhauScreen(),
                ),
                const DividerWidget(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/noteName.png",
                  content: translation(context)!.create_a_name_that_remindsKey,
                  widget: const TaoTenGoiNhoScreen(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          titleListMenu(title: translation(context)!.manage_contactKey),
          const SizedBox(
            height: 20,
          ),
          CardLayoutWidget(
            child: Column(
              children: [
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/contactBook.png",
                  content: translation(context)!.manage_beneficiary_listKey,
                  widget: const QuanLyDanhBaThuHuongScreen(),
                ),
                const DividerWidget(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/bill.png",
                  content: translation(context)!.bill_listKey,
                  widget: const QuanLyDanhBaHoaDonScreen(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          titleListMenu(title: translation(context)!.supportKey),
          const SizedBox(
            height: 20,
          ),
          CardLayoutWidget(
            child: Column(
              children: [
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/question.png",
                  content: translation(context)!.frequently_asked_questionsKey,
                  widget: const CauHoiThuongGapScreen(),
                ),
                const DividerWidget(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/termofservice.png",
                  content: translation(context)!.terms_of_serviceKey,
                  widget: const DieuKhoanDichVuScreen(),
                ),
                const DividerWidget(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                selectMenuButton(
                  context: context,
                  imageSVG: "assets/icons/Headset.svg",
                  colors: Colors.white,
                  content: translation(context)!.contactKey,
                  widget: const ContactScreen(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          titleListMenu(title: translation(context)!.searchKey),
          const SizedBox(
            height: 20,
          ),
          CardLayoutWidget(
            child: Column(
              children: [
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/exchangerate.png",
                  content: translation(context)!.search_exchange_rateKey,
                  widget: const TraCuuTyGiaNgoaiTeScreen(),
                ),
                const DividerWidget(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/interestrate.png",
                  content: translation(context)!.search_interest_rateKey,
                  widget: const TraCuuLaiSuatTienGuiCoKyHanScreen(),
                ),
                const DividerWidget(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                selectMenuButton(
                  context: context,
                  colors: Colors.white,
                  imagePNG: "assets/icons/location.png",
                  content: translation(context)!.atm_branchKey,
                  widget: const MyLocationScreen(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
