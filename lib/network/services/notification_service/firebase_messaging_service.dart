// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/utils/actionHandelClickNotification/route_notification.dart';
import 'package:ib_sme_mb_view/utils/local_notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/providers.dart';

class FirebaseMessagingService {
  NotificationSettings? settings;
  FirebaseMessagingService({this.settings});
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<RemoteMessage>? _onMessage;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  void initialize(BuildContext context, bool isFirstRoute) async {
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      if (isFirstRoute) {
        await _firebaseMessaging
            .getInitialMessage()
            .then((RemoteMessage? message) async {
          if (message != null) {
            navigateToNotificationScreen(context, message, "getInitialMessage");
          }
        });
      }
      isFirstRoute = false;

      _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        updateUnreadNotification(context, 'onMessageOpenedApp');
        navigateToNotificationScreen(context, message, 'onMessageOpenedApp');
      });
      _onMessage =
          FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        updateUnreadNotification(context, 'onMessageListen');
        showNotificationOnForegroundRouteScreen(
            message, context, 'onMessageListen');
      });
    }
  }

  void disposeListeners() async {
    if (_onMessageOpenedAppSubscription != null && _onMessage != null) {
      await _onMessageOpenedAppSubscription!.cancel();
      await _onMessage!.cancel();
      dev.log('Người nghe đã bị hủy.');
    } else {
      dev.log('Người nghe không tồn tại.');
    }
  }

  void updateUnreadNotification(context, titleAction) async {
    sharedpf.countNotificationUnRead(titleAction);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counts = prefs.getInt('unreadNotifications') ?? 0;
    var counter = Provider.of<CountUnreadProvider>(context, listen: false);
    counter.saveCountUnread(counts);
  }

  void showNotificationOnForegroundRouteScreen(
      RemoteMessage message, context, status) async {
    String? channelId;
    if (message.notification?.android != null) {
      channelId = message.notification!.android!.channelId;
    }
    LocalNotificationService localNotificationService =
        LocalNotificationService(
            message: message,
            channelID: channelId,
            channelName: channelId != null
                ? channelId == ChannelIDNotification.BALANCE.value
                    ? ChannelNameNotification.BALANCE.value
                    : ChannelNameNotification.SOMETHING.value
                : null);
    await localNotificationService.initNotification(context, status);
    localNotificationService.showNotification(
        title: message.notification?.title, body: message.notification?.body);
  }
}
