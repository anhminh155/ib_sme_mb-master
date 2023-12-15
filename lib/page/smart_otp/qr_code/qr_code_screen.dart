// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';

import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/page/smart_otp/qr_code/changed_access_code.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../network/services/sharedPreferences_service.dart';
import '../../../provider/providers.dart';
import 'enter_code_tradding.dart';
import 'enter_pin_screen.dart';

class QrViewScan extends StatefulWidget {
  const QrViewScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrViewScanState();
}

class _QrViewScanState extends State<QrViewScan> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late String accessCode = '';
  List<InitUserOTPModel> userList = [];
  TextEditingController pinController = TextEditingController();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  void initState() {
    super.initState();
    var value = sharedpf.getListUserOTP();
      setState(() {
        userList = value;
        if (userList.isNotEmpty) {
          accessCode = userList[0].username;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        title: const Text("Quét QR"),
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: _renderBody(),
    );
  }

  _renderBody() {
    if (userList.isNotEmpty) {
      return _buildQrView(context);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
            child: Text(
          'Quý khách vui lòng kích hoạt dịch vụ Smart OTP trên thiết bị để thực hiện chức năng này',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width * .80;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              overlayColor: Colors.black.withOpacity(0.85),
              borderColor: coloreWhite_EAEBEC,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 7,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const Text(
                "Quý khách vui lòng quét QR trên kênh đang thực hiện giao dịch",
                style: TextStyle(color: Colors.white, height: 1.5),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Tài khoản đang xác thực : $accessCode',
                  style: const TextStyle(color: Colors.white, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () {
                  controller!.pauseCamera();
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    isDismissible: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ChangedAccessCode(
                          value: accessCode,
                          handelSellected: (String selectedAccessCode) {
                            setState(() {
                              accessCode = selectedAccessCode;
                            });
                          },
                        ),
                      );
                    },
                  ).whenComplete(() {
                    controller!.resumeCamera();
                  });
                },
                child: const Text(
                  "Thay đổi tài khoản xác thực?",
                  style: TextStyle(
                      color: secondaryColor,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Hoặc quý khách nhập mã giao dịch hiển thị trên kênh Internet Banking",
                    style: TextStyle(color: Colors.white, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller!.pauseCamera();
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      isDismissible: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EnterCodeTrans(
                            value: accessCode,
                            initUser: userList.firstWhere(
                                (element) => element.username == accessCode),
                            userList: userList,
                          ),
                        );
                      },
                    ).whenComplete(() {
                      controller!.resumeCamera();
                    });
                  },
                  child: const Text(
                    "Nhập mã giao dịch tại đây",
                    style: TextStyle(
                        color: secondaryColor,
                        decoration: TextDecoration.underline,
                        height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      final otpProvider = Provider.of<OtpProvider>(context, listen: false);
      OtpSettingModel otpSettingModel = sharedpf.getParamSettingOTP();
      if (otpProvider.canRequestOtp(otpSettingModel.betweenOtp)) {
        String errorMassage = OtpService.validParamsOTP(accessCode);
        if(errorMassage.isNotEmpty){
          showDiaLogConfirm(
            context: context,
            content: Text(errorMassage,textAlign: TextAlign.center,));
        }else{
          showModalBottomSheet<void>(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return EnterPinScreen(
                tranCode: scanData.code.toString(),
                initUser: userList
                    .firstWhere((element) => element.username == accessCode),
              );
            },
          ).whenComplete(() {
            controller.resumeCamera();
          });
        }
      } else {
        OtpFunction().showPopUpTimeRemainOtp(
          context: context,
          handleContinute: () {
            controller.resumeCamera();
          },
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
