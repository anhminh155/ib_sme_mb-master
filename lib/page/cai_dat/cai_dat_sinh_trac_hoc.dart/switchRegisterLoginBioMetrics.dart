// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/page/login/login.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'dart:developer' as dev;
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../../network/services/get_code_gen_otp_service.dart';

class SwitchRegisterLoginBioMetrics extends StatefulWidget {
  const SwitchRegisterLoginBioMetrics({Key? key}) : super(key: key);

  @override
  State<SwitchRegisterLoginBioMetrics> createState() =>
      _SwitchRegisterLoginBioMetricsState();
}

class _SwitchRegisterLoginBioMetricsState
    extends State<SwitchRegisterLoginBioMetrics> {
  final storage = const FlutterSecureStorage();

  final LocalAuthentication auth = LocalAuthentication();
  bool _switchValue = false;
  bool _isSupportBiometrics = false;
  String? _usernameBiometric;
  String? _passwordBiometric;
  String userNameInfo = '';

  @override
  void initState() {
    super.initState();
    _initBiometricData();
  }

  _getUserInFor() async {
    LocalStorage? user = LocalStorage("localStorage");
    if (user.getItem('currentUser') != null) {
      return await user.getItem('currentUser')['username'];
    }
  }

  _initBiometricData() async {
    _usernameBiometric = await storage.read(key: bioUserNameKey);
    _passwordBiometric = await storage.read(key: bioPasswordKey);
    userNameInfo = await _getUserInFor();
    setState(() {
      _switchValue = _usernameBiometric != null && _passwordBiometric != null;
    });
    _isSupportBiometrics = await auth.isDeviceSupported();
  }

  getCodeGenOTPBiometric(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGentOTPBiometric(code, context);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    }
  }

  verifyOTPBiometric(requestBody, context) async {
    BaseResponse response =
        await GetCodeGenOTP().verifyOTPBiometrics(requestBody);
    if (response.errorCode == FwError.THANHCONG.value) {
      await _saveLoginBioMetrics();
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.centerRight,
      scale: 0.7,
      child: CupertinoSwitch(
        value: _switchValue,
        onChanged: (bool newValue) {
          if (_switchValue != newValue) {
            onPressButton(newValue);
          }
        },
      ),
    );
  }

  void onPressButton(value) async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (!_isSupportBiometrics) {
      showToast(
        context: context,
        msg: 'Thiết bị không hỗ trợ tính năng này',
        color: Colors.orange,
      );
      return;
    }

    if (availableBiometrics.isEmpty) {
      showToast(
        context: context,
        msg: 'Vui lòng cài đặt sinh trắc học cho thiết bị',
        color: Colors.orange,
      );
      return;
    }

    if (value == false) {
      showDiaLogConfirm(
          context: context,
          close: true,
          horizontal: 16.0,
          titleButton: "Đồng ý",
          content: const Text(
            'Quý khách có muốn tắt đăng nhập sinh trắc học trên thiết bị này',
            style: TextStyle(height: 1.5),
            textAlign: TextAlign.center,
          ),
          handleContinute: _deleteBioMetricsData);
    } else {
      var register =
          Provider.of<OtpProvider>(context, listen: false).isRegister;
      if (register) {
        var codeGenOTP = await getCodeGenOTPBiometric(userNameInfo, context);
        OtpFunction().showDialogEnterPinOTP(
            context: context,
            transCode: codeGenOTP,
            callBack: (String otp, String code) async {
              var requestBody = {
                'code': code,
                'otp': otp,
                'data': {
                  "code": userNameInfo,
                }
              };
              await verifyOTPBiometric(requestBody, context);
            });
      } else {
        showToast(
          context: context,
          msg: 'Vui lòng đăng ký Smart-OTP để thực hiện chức năng này',
          color: Colors.orange,
        );
      }
    }
  }

  _saveLoginBioMetrics() async {
    try {
      await storage.write(key: bioUserNameKey, value: userNameInfo);
       await storage.write(key: bioPasswordKey, value: _passwordBiometric);
      setState(() {
        _switchValue = true;
      });
    } catch (e) {
      await storage.write(key: bioUserNameKey, value: userNameInfo);
      dev.log(e.toString());
    }
  }

  _deleteBioMetricsData() {
    setState(() {
      storage.delete(key: bioUserNameKey);
      storage.delete(key: bioPasswordKey);
      _switchValue = false;
    });
  }
}
