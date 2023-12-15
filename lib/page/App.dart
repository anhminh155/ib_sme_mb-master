// ignore_for_file: file_names, use_build_context_synchronously
import 'package:animations/animations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/show_exit_dialog.dart';
import 'package:ib_sme_mb_view/network/services/authen_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/page/login/login.dart';
import 'package:ib_sme_mb_view/page/thong_bao/thong_bao.dart';
import 'package:ib_sme_mb_view/page/bao_cao/bao_cao.dart';
import 'package:ib_sme_mb_view/page/tien_ich/tien_ich.dart';
import 'package:ib_sme_mb_view/page/trang_chu/trang_chu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/dialog_confirm.dart';
import '../enum/enum.dart';
import '../model/models.dart';
import '../network/services/notification_service/firebase_messaging_service.dart';
import '../network/services/transaction_service.dart';
import '../provider/providers.dart';
import 'cai_dat/cai_dat.dart';

class App extends StatefulWidget {
  final NotificationSettings? settings;
  final bool? isFirstTime;
  final bool? isFirstRoute;
  const App({super.key, this.settings, this.isFirstTime, this.isFirstRoute});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with BaseComponent, WidgetsBindingObserver {
  int _selectedIndex = 0;
  List<Widget> _pages = [];
  FirebaseMessagingService messagingService = FirebaseMessagingService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getInitData();
      messagingService = FirebaseMessagingService(settings: widget.settings);
      messagingService.initialize(context, widget.isFirstRoute!);
    });

    _pages = [
      TrangChuPageWidget(
        isFirstTime: widget.isFirstTime,
      ),
      const BaoCaoPhiGaoDich(routate: 0),
      const TienIchPageWidget(),
      const ThongBaoPageWidget(),
      const CaiDatPageWidget()
    ];
  }

  _getInitData() async {
    _getAllDDAcount();
    _setParamsOTP();
    getSumPayment();
    getUnReadNotification();
  }

  @override
  void dispose() {
    super.dispose();
    messagingService.disposeListeners();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      await removeUnReadNotification();
    }
  }

  removeUnReadNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('unreadNotifications', 0);
    });
    await getUnReadNotification();
  }

  Future<void> _getAllDDAcount() async {
    List<TDDAcount> accounts;
    BaseResponseDataList response =
        await Transaction_Service().getAllDDAcount();
    if (response.errorCode == FwError.THANHCONG.value) {
      accounts = response.data!
          .map<TDDAcount>((json) => TDDAcount.fromJson(json))
          .toList();
      if (accounts.isNotEmpty) {
        await Provider.of<SourceAcctnoProvider>(context, listen: false)
            .set(accounts);
      }
    } else if (mounted) {
      showDiaLogConfirm(
          content: Text(response.errorMessage ?? ""), context: context);
    }
  }

  getUnReadNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counts = prefs.getInt('unreadNotifications') ?? 0;
    var counter = Provider.of<CountUnreadProvider>(context, listen: false);
    counter.saveCountUnread(counts);
  }

  Future<void> getSumPayment() async {
    BaseResponse response = await Transaction_Service().getSumPayment();
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        if (response.data != null) {
          var sumPayments = response.data;
          Provider.of<TddAccountProvider>(context, listen: false)
              .setSumPayment(sumPayments);
        }
      });
    }
  }

  // Future<void> getCountTrans() async {
  //   BaseResponse<CountTrans> response =
  //       await CountTransSeervice().getCountTrans(context);
  //   if (response.errorCode == FwError.THANHCONG.value && mounted) {
  //     setState(() {
  //       if (response.data != null) {
  //         Provider.of<CountTransProvider>(context, listen: false)
  //             .saveCountTrans(CountTrans.fromJson(response.data));
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    int? counts = Provider.of<CountUnreadProvider>(context, listen: true).item;
    return WillPopScope(
        onWillPop: () async {
          if (_selectedIndex == 0) {
            bool shouldExit = await showExitConfirmationDialog(context);
            if (shouldExit) {
              await AuthenService.logOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
                  ((route) => false));
            }
          } else {
            setState(() {
              _selectedIndex = 0;
            });
          }
          return false;
        },
        child: Scaffold(
          body: Center(
            child: PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _pages.elementAt(_selectedIndex),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_filled),
                label: translation(context)!.homeKey,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                label: translation(context)!.reportKey,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.grid_view),
                label: translation(context)!.utilitiesKey,
              ),
              BottomNavigationBarItem(
                icon: Consumer<CountUnreadProvider>(
                    builder: (context, counter, child) {
                  return badges.Badge(
                    showBadge: counts == 0 ? false : true,
                    badgeContent: Text(
                      '$counts',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    badgeAnimation: const badges.BadgeAnimation.scale(),
                    position: badges.BadgePosition.topEnd(end: -6, top: -6),
                    child: const Icon(Icons.notifications),
                  );
                }),
                label: translation(context)!.notificationKey,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: translation(context)!.setting_labelKey,
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color.fromRGBO(1, 90, 171, 1),
            selectedFontSize: 13,
            unselectedItemColor: const Color.fromRGBO(114, 115, 116, 1),
            elevation: 1,
            showUnselectedLabels: true,
          ),
        ));
  }
  
  _setParamsOTP() async {
    try{
      BaseResponse response = await OtpService().getParamsOTP();
      if(response.errorCode == FwError.THANHCONG.value){
        print("log${response.data}");
        OtpSettingModel otpSettingModel = OtpSettingModel.fromJson(response.data);
        sharedpf.setParamSettingOTP(otpSettingModel);
      }
    }catch(_){}
  }
}
