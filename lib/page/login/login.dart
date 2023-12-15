// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/common/validate_form.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/favorite_product/favorites_product.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/network/services/authen_service.dart';
import 'package:ib_sme_mb_view/network/services/favorite_products.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/limit_account_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/network/services/special_characters_service.dart';
import 'package:ib_sme_mb_view/page/login/actionButton/location_screen.dart';
import 'package:ib_sme_mb_view/page/login/actionButton/quen_mat_khau.dart';
import 'package:ib_sme_mb_view/page/login/actionButton/tien_ich.dart';
import 'package:ib_sme_mb_view/page/login/enter_sms_otp_screen.dart';
import 'package:ib_sme_mb_view/page/smart_otp/qr_code/qr_code_screen.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../common/form_input_and_label/text_field.dart';
import '../../enum/enum.dart';
import '../../network/services/cus_service.dart';
import '../app.dart';
import '../tien_ich/ho_tro/lien_he.dart';
import 'list_user_login_screen.dart';

const String bioUserNameKey = 'usernameBiomatric';
const String bioPasswordKey = 'passwordBiomatric';

class LoginWidget extends StatefulWidget {
  final bool? isFirstRoute;
  const LoginWidget({super.key, this.isFirstRoute});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with BaseComponent {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = const FlutterSecureStorage();
  final _loginForm = GlobalKey<FormState>();
  FocusNode focusUserName = FocusNode();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  bool obscureText = true;
  String _initUsername = "";
  bool _isLoading = false;
  List<BiometricType> _availableBiometrics = [];
  String? _usernameBiometric;
  String? _passwordBiometric;
  NotificationSettings? settings;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Locale locale = Locale(localStorage.getItem("language_code") ?? "vi");
  bool _isSubmited = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    focusUserName.dispose();
    userNameController.dispose();
    passWordController.dispose();
  }

  _initData() async {
    super.didChangeDependencies();
    _checkSafeDevices();
    getLimitAccount();
    _initUsername =
        Provider.of<LastUserProvider>(context, listen: false).username ?? "";
    userNameController.text = _initUsername;
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    var usernameBiometric = await storage.read(key: bioUserNameKey);
    var passwordBiometric = await storage.read(key: bioPasswordKey);

    NotificationSettings setting = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    setState(() {
      _usernameBiometric = usernameBiometric;
      _passwordBiometric = passwordBiometric;
      _availableBiometrics = availableBiometrics;
      settings = setting;
    });
  }

  Future getLimitAccount() async {
    try {
      BaseResponse response = await LimitAccountService().getLimitAccount();
      if (response.errorCode == FwError.THANHCONG.value) {
        sharedpf.setLimitAccount(response.data);
      }
    } catch (_) {}
  }

  _checkSafeDevices() async {
    if (!(await AuthenService.checkSafeDevice())) {
      showDiaLogConfirm(
          context: context,
          content: const Text(
            "Thiết bị của bạn không vượt qua được bước kiểm tra bảo mật của chúng tôi. Hãy chắc rằng thiết bị của bạn sử dụng phiên bản hệ điều hành đáng tin cậy, chưa bị root hoặc có phần mềm độc hại trên máy. Thông thường các máy hàng xách tay (không được phân phối chính hãng tại Việt Nam) sẽ không sử dụng được ứng dụng.",
            textAlign: TextAlign.center,
          ),
          handleContinute: () => exit(0));
    }
  }

  onHandleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  getAllInfoCust(id, LoginRequest loginRequest, String phone) async {
    final futures = <Future>[
      getSpecialCharacters(),
      getFavoriteProducts(),
    ];

    try {
      final result = await Future.wait<dynamic>(futures);
      if (result.length == futures.length) {
        getCustInfo(id, loginRequest, phone);
      }
    } catch (_) {
      getCustInfo(id, loginRequest, phone);
    }
  }

  getSpecialCharacters() async {
    BaseResponse response =
        await SpecialCharactersService().getSpecialSharacters();
    if (response.errorCode == FwError.THANHCONG.value) {
      await Provider.of<SpecialCharactersProvider>(context, listen: false)
          .saveSpecialCharacters(response.data);
    }
  }

  Future<void> onHandleLogin(
      {String? usernameTemp, String? passWordTemp}) async {
    try {
      setState(() {
        _isLoading = true;
        _isSubmited = true;
      });
      LoginRequest loginRequest = LoginRequest();
      if (usernameTemp == null && passWordTemp == null) {
        loginRequest.username = userNameController.text;
        loginRequest.password = passWordController.text;
      } else {
        loginRequest.username = usernameTemp;
        loginRequest.password = passWordTemp;
      }
      LoginResponse? response = await Api.login(loginRequest);
      if (response != null && mounted) {
        if (response.errorCode == "OK" ||
            response.errorCode == FwError.DOIMATKHAU.value) {
          if ((_usernameBiometric != null &&
                  userNameController.text.isNotEmpty &&
                  userNameController.text != _usernameBiometric) ||
              (_passwordBiometric != null &&
                  passWordController.text.isNotEmpty &&
                  passWordController.text != _passwordBiometric)) {
            storage.delete(key: bioUserNameKey);storage.write(key: bioPasswordKey, value: loginRequest.password);
            setState(() {
              _usernameBiometric = null;
              _passwordBiometric = null;
            });
            
          }
          storage.write(key: bioPasswordKey, value: loginRequest.password);
          await getAllInfoCust(
              response.id, loginRequest, response.phone ?? "0");
        } else {
          showDiaLogConfirm(
              content: Text(response.errorMessage!), context: context);
        }
      } else {
        showDiaLogConfirm(
            content:  const Text('Có lỗi xảy ra !'), context: context);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkTokenOTP(id) async {
    try {
      var initUser =
          Provider.of<OtpProvider>(context, listen: false).getInitUser(id);
      if (initUser != null) {
        BaseResponse response =
            await OtpService().checkTokenOtp(initUser.tokenID);
        if (response.errorCode == FwError.THANHCONG.value) {
          if (!response.data) {
            await Provider.of<OtpProvider>(context, listen: false)
                .deleteToken(id);
          } else {
            await Provider.of<OtpProvider>(context, listen: false)
                .checkRegister(id);
          }
        }
      } else {
        Provider.of<OtpProvider>(context, listen: false).clearCust();
      }
    } catch (_) {}
  }

  Future getFavoriteProducts() async {
    page.curentPage = 1;
    page.size = 10;
    BasePagingResponse response =
        await FavoriteProductsService().getFavoriteProducts(page);
    if (response.errorCode == FwError.THANHCONG.value) {
      var favoriteProductList = response.data!.content!
          .map(
              (favoriteProducts) => FavoriteProducts.fromJson(favoriteProducts))
          .toList();
      if (response.data?.content != null) {
        await Provider.of<FavoriteProductProvider>(context, listen: false)
            .setFavoriteProducts(favoriteProductList);
      }
    }
  }

  Future<void> getCustInfo(id, LoginRequest loginRequest, String phone) async {
    try {
      bool doLogin = true;
      setState(() {
        _isLoading = true;
      });
      BaseResponse? response;
      response = await CusService().getCustInfo();
      if (mounted) {
        if (response.errorCode == FwError.THANHCONG.value) {
          bool isFirtLoginOnDevice =
              sharedpf.checkFirstTimeLogin(loginRequest.username ?? "");
          if (isFirtLoginOnDevice) {
            doLogin = (await _goToSMSOTP(false, phone)) ?? false;
          }
        } else if (response.errorCode == FwError.XACTHUCOTP.value) {
          doLogin = (await _goToSMSOTP(true, phone)) ?? false;
          if (doLogin) {
            response = await CusService().getCustInfo();
          }
        } else if (response.errorCode == FwError.DOIMATKHAU.value) {
          doLogin = (await _goToSMSOTP(true, phone)) ?? false;
          if (doLogin) {
            response = await CusService().getCustInfo();
          }
        } else {
          showToast(
              context: context,
              msg: response.errorMessage ?? "",
              color: Colors.red,
              icon: const Icon(Icons.error));
        }
        if (doLogin) {
          await Provider.of<CustInfoProvider>(context, listen: false)
              .saveCust(Cust.fromJson(response.data));
          // await addToListUserLogin(loginRequest.username);
          await Provider.of<LastUserProvider>(context, listen: false)
              .set(loginRequest.username);
          await _checkTokenOTP(id);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => App(
                  settings: settings,
                  isFirstTime: true,
                  //Điều hướng tới màn chi tiết thông báo từ trạng thái đóng 1 lần duy nhất
                  isFirstRoute: widget.isFirstRoute ?? false,
                ),
                maintainState: true,
                fullscreenDialog: true,
              ));
        }
      } else {
        await AuthenService.logOut();
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _goToSMSOTP(bool isFirstLogin, String phoneNumber) async {
    bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterSMSOTPScreen(
            isFirstLogin: isFirstLogin,
            phoneNumber: phoneNumber,
          ),
        ));
    return result;
  }

  renderFlag() {
    if (locale.languageCode.compareTo('vi') == 0) {
      return InkWell(
        onTap: _changeToEN,
        child: Row(
          children: [
            Image.asset('assets/images/united-kingdom.png'),
            const SizedBox(
              width: 5,
            ),
            const Text('EN')
          ],
        ),
      );
    }
    return InkWell(
      onTap: _changeToVN,
      child: Row(
        children: [
          SvgPicture.asset('assets/images/VN.svg'),
          const SizedBox(
            width: 5,
          ),
          const Text('VN')
        ],
      ),
    );
  }

  _changeToVN() async {
    IBSMEMBApp.setLocale(context, const Locale('vi', ''));
    await setLocale(const Locale('vi', ''));
    setState(() {
      locale = const Locale('vi', '');
    });
  }

  _changeToEN() async {
    IBSMEMBApp.setLocale(context, const Locale('en', ''));
    await setLocale(const Locale('en', ''));
    setState(() {
      locale = const Locale('en', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [renderBodyLogin(), if (_isLoading) const LoadingCircle()],
    ));
  }

  renderBodyLogin() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.62,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: FractionalOffset.centerRight,
                  image: AssetImage("assets/images/background_login.jpg"),
                  fit: BoxFit.fill),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: topPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/logo2.svg',
              ),
              renderFlag(),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 16),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.white),
            child: Form(
              key: _loginForm,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  renderUsername(),
                  const SizedBox(
                    height: 20,
                  ),
                  renderPassword(),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (sharedpf.getLastUserLogin() == "" &&
                            sharedpf.getListUserLogin().isNotEmpty)
                          InkWell(
                              onTap: _showListUserLogin,
                              child: Text(
                                'Danh sách tài khoản',
                                style: TextStyle(
                                    color: primaryColor.withOpacity(0.8),
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              )),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        renderForgotPass(),
                      ],
                    ),
                  ),
                  renderButtons(),
                  const SizedBox(
                    height: 20,
                  ),
                  renderListAccesses(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  renderListAccesses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        renderActionButton(
          content: const Text(
            "SMART OTP",
            style: TextStyle(
                color: primaryColor, fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          onTap: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QrViewScan()));
          },
        ),
        renderActionButton(
          content: SvgPicture.asset("assets/icons/Headset.svg"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ContactScreen()));
          },
        ),
        renderActionButton(
          content: SvgPicture.asset(
            "assets/icons/MapPin.svg",
            // ignore: deprecated_member_use
            color: primaryColor,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyLocationScreen(),
                ));
          },
        ),
        renderActionButton(
          content: SvgPicture.asset('assets/icons/list_product.svg'),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             const ThongBaoPageWidget()));
            showToast(
              context: context,
              msg: 'Chức năng này đang được cập nhật',
              color: Colors.orange,
            );
          },
        ),
        renderActionButton(
          content: SvgPicture.asset("assets/icons/SquaresFour.svg"),
          onTap: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                isDismissible: true,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return const TienIchWidget();
                });
          },
        )
      ],
    );
  }

  renderButtons() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              if (_loginForm.currentState!.validate()) {
                onHandleLogin();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  color: secondaryColor),
              child: Text(
                translation(context)!.loginKey,
                style: const TextStyle(
                    color: colorWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Align(
          alignment: Alignment.center,
          child: _renderButtonBiometric(),
        )
      ],
    );
  }

  renderForgotPass() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
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
                  child: const QuenMatKhauScreen(),
                );
              });
        },
        child: Text(
          "${translation(context)!.forgot_passwordKey} ?",
          style: const TextStyle(
            color: colorBlack_727374,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  renderUsername() {
    if (_initUsername.isNotEmpty) {
      return renderUser2();
    }
    return renderUser1();
  }

  renderPassword() {
    return FormControlWidget(
      label: translation(context)!.passwordKey,
      child: TextFieldWidget(
        onSubmitted: (value) async {
          if (_loginForm.currentState!.validate()) {
            onHandleLogin();
          }
        },
        obscureText: obscureText,
        validator: (value) {
          if (_isSubmited && (value == null || value.isEmpty)) {
            return translation(context)!
                .could_not_be_empty(translation(context)!.passwordKey);
          }
          return null;
        },
        controller: passWordController,
        hintText: translation(context)!
            .enterKey(translation(context)!.passwordKey.toLowerCase()),
        prefixIcon: Container(
          padding:
              const EdgeInsets.only(left: 14, top: 12, bottom: 12, right: 8),
          child: const Icon(Icons.lock_outline),
        ),
        suffixIcon: InkWell(
          onTap: () {
            onHandleObscureText();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            child: obscureText
                ? Icon(
                    Icons.visibility_outlined,
                    color: colorBlack_727374.withOpacity(0.5),
                  )
                : Icon(
                    Icons.visibility_off,
                    color: colorBlack_727374.withOpacity(0.5),
                  ),
          ),
        ),
      ),
    );
  }

  renderUser1() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FormControlWidget(
        label: translation(context)!.usernameKey,
        child: TextFieldWidget(
          onSubmitted: (value) async {
            if (_loginForm.currentState!.validate()) {
              onHandleLogin();
            }
          },
          validator: _isSubmited
              ? ValidateForm(context: context).validateUserName
              : null,
          controller: userNameController,
          hintText: translation(context)!
              .enterKey(translation(context)!.usernameKey.toLowerCase()),
        ),
      ),
    );
  }

  renderUser2() {
    return ListTile(
        leading: SvgPicture.asset(
          "assets/images/avt-user.svg",
          fit: BoxFit.contain,
          height: 50,
        ),
        title: Text(translation(context)!
            .welcomeKey(translation(context)!.loginKey.toLowerCase())),
        subtitle: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SvgPicture.asset("assets/images/diamond_orange.svg"),
          ),
          Text(
            userNameController.text,
            style: const TextStyle(color: secondaryColor),
          ),
          const SizedBox(
            width: 15,
          ),
        ]),
        trailing: InkWell(
            onTap: _showListUserLogin,
            child: SvgPicture.asset("assets/icons/ArrowsLeftRight.svg")));
  }

  renderActionButton({Color? color, content, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? colorBlue_D9E6F2,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: content,
      ),
    );
  }

  Widget wrongAccountWidget() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      title: const Text(
        'Thông báo',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryBlackColor,
            fontSize: 16,
            letterSpacing: 2),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(216, 218, 229, 1),
            ),
          ),
        ),
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: const Text(
          "Tài khoản hoặc mật khẩu không chính xác. Bạn vui lòng thử lại",
          style: TextStyle(
            color: colorBlack_727374,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Column(
          children: [
            ButtonWidget(
                height: 40,
                backgroundColor: primaryColor,
                onPressed: () {
                  Navigator.pop(context);
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
                          child: const QuenMatKhauScreen(),
                        );
                      });
                },
                text: "Quên mật khẩu",
                colorText: Colors.white,
                haveBorder: false,
                widthButton: double.infinity),
            const SizedBox(
              height: 10,
            ),
            ButtonWidget(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Thử lại",
                colorText: colorBlack_727374,
                haveBorder: true,
                colorBorder: colorBlack_727374.withOpacity(0.5),
                widthButton: double.infinity),
          ],
        ),
      ],
    );
  }

  Widget wrongLockAccountWidget() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      title: const Text(
        'Thông báo',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryBlackColor,
            fontSize: 16,
            letterSpacing: 2),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(216, 218, 229, 1),
            ),
          ),
        ),
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: const Text(
          "Tài khoản đã bị khóa. Vui lòng liên hệ CSKH hoặc mã quản trị để mở khóa.",
          style: TextStyle(
            color: colorBlack_727374,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        ButtonWidget(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Đóng",
            colorText: colorBlack_727374,
            haveBorder: true,
            colorBorder: colorBlack_727374.withOpacity(0.5),
            widthButton: double.infinity),
      ],
    );
  }

  _renderButtonBiometric() {
    Widget? interfaceBtn;
    if (_availableBiometrics.contains(BiometricType.fingerprint) ||
        (_availableBiometrics.contains(BiometricType.strong) &&
            (_availableBiometrics.contains(BiometricType.weak)))) {
      interfaceBtn =
          const Icon(Icons.fingerprint, size: 45, color: primaryColor);
    }
    if (_availableBiometrics.contains(BiometricType.face) &&
        !_availableBiometrics.contains(BiometricType.fingerprint)) {
      interfaceBtn = Image.asset(
        "assets/icons/faceID.png",
        height: 45,
        width: 45,
      );
    }
    if (!_availableBiometrics.contains(BiometricType.fingerprint) &&
        !_availableBiometrics.contains(BiometricType.face) &&
        !_availableBiometrics.contains(BiometricType.weak) &&
        !_availableBiometrics.contains(BiometricType.strong)) {
      interfaceBtn = Container();
    }

    return InkWell(
      onTap: _onPressLoginBiometric,
      child: Container(
        child: interfaceBtn,
      ),
    );
  }

  _onPressLoginBiometric() async {
    if (_usernameBiometric == null ||
        _usernameBiometric != userNameController.text) {
      showToast(
        context: context,
        msg: 'Vui lòng đăng nhập và kích hoạt tính năng trong phần cài đặt',
        color: Colors.orange,
      );
      return;
    }

    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      showToast(
          context: context,
          msg: 'Vui lòng cài đặt sinh trắc học cho thiết bị',
          color: Colors.orange,
          icon: const Icon(Icons.error));
      return;
    }

    bool authenticated = await auth.authenticate(
      localizedReason: 'Đăng nhập bằng sinh trắc học.',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (authenticated && _usernameBiometric == userNameController.text) {
      onHandleLogin(
          usernameTemp: _usernameBiometric, passWordTemp: _passwordBiometric);
    } else {
      showToast(
        context: context,
        msg: 'Vui lòng thử lại',
        color: Colors.orange,
      );
    }
  }

  _showListUserLogin() {
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListUserLoginScreen(
            value: userNameController.text,
            handelChangeAccount: () {
              setState(() {
                userNameController.clear();
                _initUsername = "";
              });
            },
            handelSellected: (String selectValue) {
              setState(() {
                userNameController.text = selectValue;
                passWordController.clear();
              });
            },
            handelClose: () {
              setState(() {
                _initUsername = '';
                userNameController.text = _initUsername;
              });
            },
          ),
        );
      },
    );
  }
}
