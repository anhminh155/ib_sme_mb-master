// ignore_for_file: use_build_context_synchronously

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/utils/navigator_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:localstorage/localstorage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'provider/providers.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  sharedpf.countNotificationUnRead("onBackground");
}

late List<AndroidNotificationChannel> channel;
late FlutterLocalNotificationsPlugin notificationsPlugin;

//Tạo danh sách kênh thông báo cho ứng dụng

Future<void> setupFlutterNotifications() async {
  channel = [
    AndroidNotificationChannel(ChannelIDNotification.BALANCE.value,
        ChannelNameNotification.BALANCE.value,
        importance: Importance.high, playSound: true),
    AndroidNotificationChannel(ChannelIDNotification.SOMETHING.value,
        ChannelNameNotification.SOMETHING.value,
        importance: Importance.high, playSound: true),
    AndroidNotificationChannel(ChannelIDNotification.LOADFILE.value,
        ChannelNameNotification.LOADFILE.value,
        importance: Importance.high, playSound: true),
  ];

  notificationsPlugin = FlutterLocalNotificationsPlugin();

//Thêm kênh cho android
  for (var item in channel) {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(item);
  }
}

LocalStorage localStorage = LocalStorage("localStorage");
bool isFirstTimeOpen = true;
Future<void> main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFlutterNotifications();

  await Firebase.initializeApp(
    name: 'CBwayBiz',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await SharedPreferencesManager.instance.init();
  // Kiểm tra xem đã đặt limitaccount chưa
  sharedpf.checkLimitAccount();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: providers,
      child: GestureDetector(child: const IBSMEMBApp()),
    ),
  );
}

class IBSMEMBApp extends StatefulWidget {
  const IBSMEMBApp({super.key});

  @override
  State<IBSMEMBApp> createState() => _IBSMEMBAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _IBSMEMBAppState? state =
        context.findAncestorStateOfType<_IBSMEMBAppState>();
    state?.setLocale(newLocale);
  }
}

class _IBSMEMBAppState extends State<IBSMEMBApp> with WidgetsBindingObserver {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      localStorage.setItem("language_code", locale.languageCode);
    });
  }

  @override
  void didChangeDependencies() async {
    await getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    Provider.of<LastUserProvider>(context, listen: false).load();
    Provider.of<OtpProvider>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return OverlaySupport(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi'),
          Locale('en'),
        ],
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        title: "IB SME MB App",
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: StatefulBuilder(
          builder: (context, setState) {
            return AnimatedSplashScreen(
                duration: 1500,
                splash: Column(
                  children: [
                    SizedBox(
                      height: 85,
                      width: 130,
                      child: SvgPicture.asset(
                        "assets/images/logo2.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      translation(context)!.bank_nameKey,
                      style: const TextStyle(color: primaryColor, fontSize: 14),
                    )
                  ],
                ),
                splashIconSize: 200,
                nextScreen: const LoginWidget(
                  isFirstRoute: true,
                ),
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.fade,
                backgroundColor: Colors.white);
          },
        ),
      ),
      // ),
    );
  }
}
