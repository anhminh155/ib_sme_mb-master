// ignore_for_file: unused_local_variable
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_han_muc/cai_dat_han_muc.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_hinh_nen/cai_dat_hinh_nen.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/ma_truy_cap.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_quyen_truy_cap/cai_dat_quyen_truy_cap.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_sinh_trac_hoc.dart/switchRegisterLoginBioMetrics.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_smart_otp/cai_dat_smart_otp/cai_dat_smart_otp.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_smart_otp/quen_ma_pin_smart_otp/enter_password.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../common/divider.dart';
import '../../common/select_menu_button.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../network/services/sharedPreferences_service.dart';
import '../../provider/providers.dart';
import '../../utils/theme.dart';
import 'cai_dat_smart_otp/doi_ma_pin/doi_pin_smart_otp.dart';

class CaiDatPageWidget extends StatefulWidget {
  const CaiDatPageWidget({super.key});

  @override
  State<CaiDatPageWidget> createState() => _CaiDatPageWidgetState();
}

class _CaiDatPageWidgetState extends State<CaiDatPageWidget> {
  bool status = false;
  bool isRegisted = false;
  int custId = 0;
  RolesAcc? rolesAcc;
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics = [];
  @override
  void initState() {
    super.initState();
    _initData();
    rolesAcc =
        Provider.of<CustInfoProvider>(context, listen: false).item!.roles;
    final currentUser =
        LoginResponse.fromJson(localStorage.getItem('currentUser'));
    custId = currentUser.id!;
    var value = sharedpf.getListUserOTP();
      setState(() {
        isRegisted = value.any((element) => element.id == currentUser.id);
      });
  }

  _initData() async {
    List<BiometricType> availableBiometricsTemp =
        await auth.getAvailableBiometrics();
    setState(() {
      availableBiometrics = availableBiometricsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 55,
        centerTitle: true,
        title: Text(translation(context)!.setting_labelKey),
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
          titleListMenu(title: translation(context)!.settingKey('GENERAL')),
          const SizedBox(
            height: 20,
          ),
          CardLayoutWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (PositionEnum.QUANTRI.value == rolesAcc!.position)
                  Column(
                    children: [
                      selectMenuButton(
                        context: context,
                        imagePNG: "assets/icons/accessCode.png",
                        content: translation(context)!.user_management_Key,
                        colors: Colors.white,
                        widget: const MaTruyCapWidget(),
                      ),
                      const DividerWidget(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      selectMenuButton(
                        context: context,
                        imagePNG: "assets/icons/accessRight.png",
                        content: translation(context)!
                            .access_permission_managementKey,
                        colors: Colors.white,
                        widget: const CaiDatQuyenTruyCapScreen(),
                      ),
                      const DividerWidget(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      selectMenuButton(
                        context: context,
                        imagePNG: "assets/icons/moneyLimit.png",
                        content: translation(context)!.settingKey('LIMIT'),
                        colors: Colors.white,
                        widget: const CaiDatHanMucScreen(),
                      ),
                      const DividerWidget(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  ),
                renderButtomBioMetrics()
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          titleListMenu(title: "Smart OTP"),
          const SizedBox(
            height: 20,
          ),
          renderOtpSettings(),
          const SizedBox(
            height: 30,
          ),
          titleListMenu(title: translation(context)!.settingKey('WALLPAPER')),
          const SizedBox(
            height: 20,
          ),
          CardLayoutWidget(
            child: Column(
              children: [
                selectMenuButton(
                  context: context,
                  imagePNG: "assets/icons/replaceBackground.png",
                  content: translation(context)!.change_wallpaperKey,
                  colors: Colors.white,
                  widget: const CaiDatHinhNenScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  renderOtpSettings() {
    return Consumer<OtpProvider>(builder: (context, otpProvider, child) {
      InitUserOTPModel? initUser = otpProvider.inituser;
      return CardLayoutWidget(
        child: Column(
          children: [
            selectMenuButton(
              context: context,
              imagePNG: "assets/icons/otp.png",
              content: translation(context)!.settingKey('SMARTOTP'),
              colors: Colors.white,
              widget: const CaiDatSmartOTPScreen(),
            ),
            if (initUser != null)
              Column(
                children: [
                  const DividerWidget(),
                  selectMenuButton(
                    context: context,
                    imagePNG: "assets/icons/forgotPin.png",
                    content: translation(context)!.pin_smart_otpKey('FORGET'),
                    colors: Colors.white,
                    widget: const RestorePin(),
                  ),
                  const DividerWidget(),
                  selectMenuButton(
                    context: context,
                    imagePNG: "assets/icons/changePin.png",
                    content: translation(context)!.pin_smart_otpKey('CHANGE'),
                    colors: Colors.white,
                    widget: const DoiPinSmartOTPScreen(),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget renderIconBiomatric(iconStatus) {
    Widget icon;

    if (iconStatus == 0) {
      icon = const Icon(
        Icons.fingerprint,
        color: primaryColor,
      );
    } else {
      icon = SizedBox(
          width: 24,
          height: 24,
          child: Image.asset(
            "assets/icons/faceID.png",
          ));
    }
    return Padding(
      padding: const EdgeInsets.only(
        right: 12,
      ),
      child: icon,
    );
  }

  renderButtomBioMetrics() {
    int iconStatus = 0;
    bool isAvailableBiometrics = true;
    if (Platform.operatingSystem == 'ios' &&
        availableBiometrics.contains(BiometricType.face) &&
        !availableBiometrics.contains(BiometricType.fingerprint)) {
      iconStatus = 1;
    }
    if (!availableBiometrics.contains(BiometricType.fingerprint) &&
        !availableBiometrics.contains(BiometricType.face)) {
      isAvailableBiometrics = false;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        renderIconBiomatric(iconStatus),
        Expanded(
          child: Text(
            translation(context)!.login_with_biometricKey,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SwitchRegisterLoginBioMetrics()
      ]),
    );
  }
}
