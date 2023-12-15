// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/provider/otp_provider.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
import '../../../../common/show_important_noti.dart';
import '../../../../enum/enum.dart';
import '../../../../model/model.dart';
import '../../../../network/services/otp_service.dart';
import 'nhap_mat_khau_xac_thuc.dart';

// ignore: must_be_immutable
class CaiDatSmartOTPScreen extends StatefulWidget {
  const CaiDatSmartOTPScreen({
    super.key,
  });

  @override
  State<CaiDatSmartOTPScreen> createState() => _CaiDatSmartOTPScreenState();
}

class _CaiDatSmartOTPScreenState extends State<CaiDatSmartOTPScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 55,
          title: const Text("Cài đặt Smart OTP"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: Stack(
          children: [renderBody(), if (_isLoading) const LoadingCircle()],
        ));
  }

  renderBody() {
    return Consumer<OtpProvider>(
      builder: (context, otpProvider, child) {
        if (otpProvider.inituser != null) {
          return renderActived();
        } else {
          return renderNoActive();
        }
      },
    );
  }

  renderNoActive() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(
                right: 16.0, left: 16.0, top: 30, bottom: 16.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Trạng thái",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Text(
                        "Chưa kích hoạt",
                        style: TextStyle(color: secondaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20.0,
                color: colorBlack_727374.withOpacity(0.5),
                thickness: 0.8,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: const [
                  Icon(
                    Icons.info,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    "Giới thiệu Smart OTP",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CardLayoutWidget(
                  child: Column(
                    children: [
                      // for (int i = 0; i < 10; i++)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                                color: colorBlack_20262C.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Expanded(
                            child: Text(
                              " Smart OTP là phương thức bảo mệt để xác thực giao dịch trực tuyến.",
                              style: TextStyle(
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                                color: colorBlack_20262C.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Expanded(
                            child: Text(
                              " Smart OTP đáp ứng yêu cầu của Ngân hàng nhà nước đối với các giao dịch thông thường và các giao dịch có giá trị lớn.",
                              style: TextStyle(
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: const [
                  Icon(
                    Icons.system_security_update_good,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Text(
                      "Đăng ký chỉ với 2 bước đơn giản",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CardLayoutWidget(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                                color: colorBlack_20262C.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Expanded(
                            child: Text(
                              " Xác nhận đăng ký và nhập mật khẩu đăng nhập để xác thực",
                              style: TextStyle(
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                                color: colorBlack_20262C.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Expanded(
                            child: Text(
                              " Tạo mã mở khóa và hoàn tất",
                              style: TextStyle(
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ButtonWidget(
              backgroundColor: primaryColor,
              onPressed: _onPressButton,
              text: translation(context)!.continueKey,
              colorText: colorWhite,
              haveBorder: false,
              widthButton: double.infinity),
        )
      ],
    );
  }

  renderActived() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            right: 16.0, left: 16.0, top: 30, bottom: 30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Trạng thái",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorGreen_56AB01, width: 0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    child: Text(
                      "Đã kích hoạt",
                      style: TextStyle(color: colorGreen_56AB01),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 20.0,
              color: colorBlack_727374.withOpacity(0.5),
              thickness: 0.8,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const CardLayoutWidget(
                child: Text(
                  "CB - Smart OTP là phương thức xác thực giao dịch đáp ứng yêu cầu của Ngân hàng Nhà nước đối với các giao dịch trên ứng dụng ngân hàng điện tử của CB",
                  style: TextStyle(
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: const [
                Icon(
                  Icons.info_outline,
                  color: secondaryColor,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  "Lưu ý",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: secondaryColor),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CardLayoutWidget(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                              color: colorBlack_20262C.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Expanded(
                          child: Text(
                            " Quý khách tuyệt đối không chia sẻ thông tin Tên truy cập và Mật khẩu CB Digiway và Mật khẩu mở khóa CB - Smart OTP với bất kỳ ai",
                            style: TextStyle(
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                              color: colorBlack_20262C.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Expanded(
                          child: Text(
                            " Thiết bị của quý khách cần cài đặt định vị GPS",
                            style: TextStyle(
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                              color: colorBlack_20262C.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Expanded(
                          child: Text(
                            " Để đảm bảo an toàn, trường hợp đăng ký CB - Smart OTP qua các kênh online, ứng dụng chỉ cho phép sử dụng phương thức xác thực CB-Smart OTP khi Quý khách đã thực hiện thành công 2 giao dịch tài chính bằng SMS OTP sau khi kích hoạt dịch vụ.",
                            style: TextStyle(
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> disableTokenTID() async {
    try {
      BaseResponse disableTokenTIDResponse =
          await OtpService().disableTokenID();

      if (disableTokenTIDResponse.errorCode == FwError.THANHCONG.value) {
        if (disableTokenTIDResponse.data) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NhapMatKhauXacThucScreen()));
        }
      } else {
        _showLog(disableTokenTIDResponse.errorMessage);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onPressButton() async {
    try {
      setState(() {
        _isLoading = true;
      });
      BaseResponse initializationResponse = await OtpService().initialization();
      if (initializationResponse.errorCode == FwError.THANHCONG.value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NhapMatKhauXacThucScreen()));
      } else if (initializationResponse.errorCode == 'OTP_0001') {
        showImportantNoti(context,
            content:
                'Tài khoản của quý khách đã được kích hoạt trên thiết bị khác, Quý khách có muốn đăng ký lại ?',
            func: disableTokenTID);
      } else {
        _showLog(initializationResponse.errorMessage);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _showLog(errorMessage) {
    return showDiaLogConfirm(
        context: context,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ));
  }
}
