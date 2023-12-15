// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/authen_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/count_tran_service.dart';
import 'package:ib_sme_mb_view/page/bao_cao/bao_cao.dart';
import 'package:ib_sme_mb_view/page/danh_sach_tai_khoan/danh_sach_tai_khoan.dart';
import 'package:ib_sme_mb_view/page/login/login.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/tim_kiem_bang_ke_cho_duyet.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_cho_duyet/tim_kiem_giao_dich_cho_duyet.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_lenh_tuong_lai_dinh_ky/tim_kiem_giao_dich_tuong_lai_dinh_ky.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_trang_thai_bang_ke/tim_kiem_trang_thai_bang_ke.dart';
import 'package:ib_sme_mb_view/page/trang_chu/account_balance_widget.dart';
import 'package:ib_sme_mb_view/page/trang_chu/account_widget.dart';
import 'package:ib_sme_mb_view/page/trang_chu/cac_lenh_cho_duyet.dart';
import 'package:ib_sme_mb_view/page/trang_chu/dialod_noti_widget.dart';
import 'package:ib_sme_mb_view/page/trang_chu/favorite_service_widget.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/checkRolesAcc.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
import '../../common/show_exit_dialog.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../chuyen_tien/Transactions/transaction_create/transaction_create.dart';
import '../quan_ly_giao_dich/quan_ly_danh_sach_lenh_tu_choi/tim_kiem_lenh_tu_choi.dart';
import '../quan_ly_giao_dich/quan_ly_giao_dich_thong_thuong/quan_ly_giao_dich_thong_thuong.dart';
import 'banner_widget.dart';

class TrangChuPageWidget extends StatefulWidget {
  late bool? isFirstTime;
  TrangChuPageWidget({super.key, this.isFirstTime});

  @override
  State<TrangChuPageWidget> createState() => _TrangChuPageWidgetState();
}

class _TrangChuPageWidgetState extends State<TrangChuPageWidget> {
  List<Widget> chuyenTienList = [];
  List<Widget> thanhToanList = [];
  List<Widget> quanLyGiaoDichList = [];
  List<TDDAcount> accounts = [];
  RolesAcc? rolesAcc;
  Cust? custInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chuyenTienList = [
      if (checkRoles(SERVICE.CHUYENKHOANNOIBOCB.value, rolesAcc))
        _cardItem(
          icon: Icons.autorenew,
          title: translation(context)!.trans_typeKey(TransType.CORE.name),
          onTapWidget: TransactionsCreate(
            tranType: TransType.CORE.name,
          ),
        ),
      if (checkRoles(SERVICE.CHUYENKHOANLIENNGANHANG.value, rolesAcc))
        _cardItem(
          icon: Icons.account_balance,
          title: translation(context)!.trans_typeKey(TransType.CITAD.name),
          onTapWidget: TransactionsCreate(
            tranType: TransType.CITAD.name,
          ),
        ),
      if (checkRoles(SERVICE.CHUYENKHOAN247DENSOTAIKHOAN.value, rolesAcc))
        _cardItem(
          icon: Icons.send,
          title: translation(context)!.trans_typeKey(TransType.NAPAS.name),
          onTapWidget: TransactionsCreate(
            tranType: TransType.NAPAS.name,
          ),
        ),
    ];
    thanhToanList = [
      if (checkRoles(SERVICE.THANHTOANHOADONDIEN.value, rolesAcc))
        _cardItem(
          icon: Icons.bolt,
          title: FUNCDESCRIPTION.TTHDTIENDIEN.value,
          onTapWidget: const DanhSachTaiKhoanPageWidget(),
        ),
      if (checkRoles(SERVICE.THANHTOANHOADONNUOC.value, rolesAcc))
        _cardItem(
          icon: Icons.water_drop,
          title: FUNCDESCRIPTION.TTHDTIENNUOC.value,
          onTapWidget: const DanhSachTaiKhoanPageWidget(),
        ),
      if (checkRoles(SERVICE.THANHTOANCUOCDIENTHOAICODINH.value, rolesAcc))
        _cardItem(
          icon: Icons.call_end,
          title: FUNCDESCRIPTION.TTCDTCODINH.value,
          onTapWidget: const DanhSachTaiKhoanPageWidget(),
        ),
      if (checkRoles(SERVICE.THANHTOANCUOCDIDONGTRASAU.value, rolesAcc))
        _cardItem(
          icon: Icons.smartphone,
          title: FUNCDESCRIPTION.TTCDTTRASAU.value,
          onTapWidget: const DanhSachTaiKhoanPageWidget(),
        ),
      if (checkRoles(SERVICE.THANHTOANCUOCINTERNETADSL.value, rolesAcc))
        _cardItem(
          icon: Icons.wifi,
          title: FUNCDESCRIPTION.TTCINTERNET.value,
          onTapWidget: const DanhSachTaiKhoanPageWidget(),
        ),
    ];
  }

  @override
  void initState() {
    rolesAcc =
        Provider.of<CustInfoProvider>(context, listen: false).item?.roles;
    custInfo = Provider.of<CustInfoProvider>(context, listen: false).item;
    getCountTrans();
    SchedulerBinding.instance.addPostFrameCallback((_)  {
      var register =
          Provider.of<OtpProvider>(context, listen: false).isRegister;
      var smartOTP =
          Provider.of<CustInfoProvider>(context, listen: false).item?.smartOtp;
      if (widget.isFirstTime!) {
        if (smartOTP.toString() != '1') {
          renderDialog(context,
              'Tài khoản của quý khách chưa kích hoạt Smart-OTP. Vui lòng kích hoạt Smart-OTP để thực hiện các giao dịch.');
        }
        if (smartOTP.toString() == '1' && !register) {
          renderDialog(context,
              'Qúy khách đang đăng nhập tài khoản trên thiết bị mới. Vui lòng kích hoạt lại Smart-OTP để thực hiện các giao dịch.');
        }
      }
      widget.isFirstTime = false;
    });

    super.initState();
  }

  createListQuanLyGiaoDich() {
    var countTrans =
        Provider.of<CountTransProvider>(context, listen: true).item;
    quanLyGiaoDichList = [
      _cardItem(
        icon: Icons.compare_arrows,
        title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLDSLGDTT, context),
        onTapWidget: const QuanLyGiaoDichThongThuong(),
      ),
      _cardItem(
        icon: Icons.update,
        title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLDSLTLDK, context),
        onTapWidget: const QuanLyLenhTuongLaiDinhKy(),
      ),
      if (rolesAcc?.type == CompanyTypeEnum.MOHINHCAP2.value)
        _cardItem(
          icon: Icons.done_all,
          title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
              FUNCDESCRIPTION.QLGDCHODUYET, context),
          countTrans: countTrans?.pending,
          onTapWidget: QuanLyGiaoDichChoDuyet(
            rolesAcc: rolesAcc,
          ),
        ),
      _cardItem(
        icon: Icons.view_comfy,
        title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLTTBANGKE, context),
        onTapWidget: const QuanLyGiaoDichBangKe(),
      ),
      if (rolesAcc?.type == CompanyTypeEnum.MOHINHCAP2.value)
        _cardItem(
          icon: Icons.plagiarism,
          countTrans: countTrans?.lotPending,
          title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
              FUNCDESCRIPTION.QLBANGKECHODUYET, context),
          onTapWidget: const GiaoDichBangKeChoDuyet(),
        ),
      if (rolesAcc?.type == CompanyTypeEnum.MOHINHCAP2.value)
        _cardItem(
          icon: Icons.playlist_remove,
          title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
              FUNCDESCRIPTION.QLDSLENHTUCHOIHUY, context),
          onTapWidget: const SearchDanhSachLenhTuChoi(),
        ),
      _cardItem(
        icon: Icons.monetization_on,
        title: FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLPHIGD, context),
        onTapWidget: const BaoCaoPhiGaoDich(
          routate: 1,
        ),
      ),
    ];
    return quanLyGiaoDichList;
  }

  Future<void> getCountTrans() async {
    BaseResponse<CountTrans> response =
        await CountTransSeervice().getCountTrans();
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      setState(() {
        if (response.data != null) {
          Provider.of<CountTransProvider>(context, listen: false)
              .saveCountTrans(CountTrans.fromJson(response.data));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(
            "assets/images/logo.svg",
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                size: 18,
              ),
              splashRadius: 1,
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                    bool shouldExit = await showExitConfirmationDialog(context);
                    if (shouldExit) {
                      await AuthenService.logOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginWidget()),
                          ((route) => false));
                    }
                  },
                );
              }),
        ],
      ),
      body: renderBody(),
    );
  }

  renderBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const AccountWidget(),
              const SizedBox(
                height: 12,
              ),
              AccountBalanceWidget(
                cust: custInfo,
              ),
              const SizedBox(
                height: 8,
              ),
              FavoriteServiceWidget(rolesAcc: rolesAcc),
              const SizedBox(
                height: 12,
              ),
              const BannerWidget(),
              const SizedBox(
                height: 16,
              ),
              if (rolesAcc?.type == CompanyTypeEnum.MOHINHCAP2.value &&
                  rolesAcc?.position != PositionEnum.LAPLENH.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CacLenhChoDuyetWidget(
                    rolesAcc: rolesAcc!,
                  ),
                ),
              if (checkTran(rolesAcc) &&
                  custInfo!.roletrans != null &&
                  custInfo!.roletrans == 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _chuyenTienCard(),
                ),
              if (checkPay(rolesAcc))
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _thanhToanCard(),
                ),
              _quanLyGiaoDichCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chuyenTienCard() {
    return Row(
      children: [
        Expanded(
          child: CardLayoutWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    translation(context)!.transferKey,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorBlack_15334A,
                    ),
                  ),
                ),
                for (Widget item in chuyenTienList)
                  Column(
                    children: [
                      item,
                      if (chuyenTienList.last != item)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: colorBlack_EAEBEC,
                          ),
                        ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _thanhToanCard() {
    return Row(
      children: [
        Expanded(
          child: CardLayoutWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    translation(context)!.bill_paymentKey,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorBlack_15334A,
                    ),
                  ),
                ),
                for (Widget item in thanhToanList)
                  Column(
                    children: [
                      item,
                      if (thanhToanList.last != item)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: colorBlack_EAEBEC,
                          ),
                        ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quanLyGiaoDichCard() {
    List listQuanLyGiaoDichTemp = createListQuanLyGiaoDich();
    return Row(
      children: [
        Expanded(
          child: CardLayoutWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    translation(context)!.transaction_managementKey,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorBlack_15334A,
                    ),
                  ),
                ),
                for (Widget item in listQuanLyGiaoDichTemp)
                  Column(
                    children: [
                      item,
                      if (listQuanLyGiaoDichTemp.last != item)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: colorBlack_EAEBEC,
                          ),
                        ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardItem(
      {required IconData icon,
      required String title,
      required Widget onTapWidget,
      int? countTrans}) {
    return InkWell(
      onTap: () {
        _handleCardItemClick(onTapWidget);
      },
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: colorBlue_D9E6F2,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: primaryColor,
                ),
              ),
              if (countTrans != null && countTrans != 0)
                Positioned(
                  top: 0,
                  right: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 4.0),
                      child: Text(
                        '$countTrans',
                        style:
                            const TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                )
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: colorBlack_20262C,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _handleCardItemClick(Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
