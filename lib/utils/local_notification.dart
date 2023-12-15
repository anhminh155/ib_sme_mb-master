import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/utils/actionHandelClickNotification/open_File_Download.dart';
import 'package:ib_sme_mb_view/utils/actionHandelClickNotification/route_notification.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? channelID;
  String? channelName;
  RemoteMessage? message;
  String? urlFile;
  LocalNotificationService(
      {this.channelID, this.channelName, this.urlFile, this.message});
  Future<void> initNotification(BuildContext context, String status) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (Platform.isAndroid) {
        String payloadData = notificationResponse.payload ?? '';
        if (payloadData == ChannelIDNotification.LOADFILE.value) {
          await openFileDownload(urlFile: urlFile);
        } else {
          navigateToNotificationScreen(context, message!, status);
        }
      } else {
        navigateToNotificationScreen(context, message!, status);
      }
    });
  }

  Future<NotificationDetails> notificationDetails() async {
    NotificationDetails notificationDetails = const NotificationDetails();
    if (Platform.isAndroid) {
      if (message != null && message!.notification?.android?.imageUrl != null) {
        BigPictureStyleInformation? bigPictureStyleInformation;
        ByteArrayAndroidBitmap? smallPictureStyleInformation;

        try {
          String url = message!.notification!.android!.imageUrl!;
          final http.Response responseImage = await http.get(Uri.parse(url));
          if (responseImage.bodyBytes.isNotEmpty) {
            smallPictureStyleInformation =
                ByteArrayAndroidBitmap.fromBase64String(
                    base64Encode(responseImage.bodyBytes));
            bigPictureStyleInformation = BigPictureStyleInformation(
                ByteArrayAndroidBitmap.fromBase64String(
                    base64Encode(responseImage.bodyBytes)),
                hideExpandedLargeIcon: true);
          }
        } catch (e) {
          bigPictureStyleInformation = null;
          smallPictureStyleInformation = null;
        }
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          icon: '@mipmap/ic_launcher',
          channelID!,
          channelName!,
          styleInformation: bigPictureStyleInformation,
          largeIcon: smallPictureStyleInformation,
          importance: Importance.high,
        );
        notificationDetails =
            NotificationDetails(android: androidPlatformChannelSpecifics);
      } else {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          icon: '@mipmap/ic_launcher',
          channelID!,
          channelName!,
          importance: Importance.high,
        );
        notificationDetails =
            NotificationDetails(android: androidPlatformChannelSpecifics);
      }
    } else {
      const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
      notificationDetails =
          const NotificationDetails(iOS: iOSPlatformChannelSpecifics);
    }

    return notificationDetails;
  }

  Future<void> showNotification(
      {String? title, String? body, String? payload}) async {
    final notificationDetail = await notificationDetails();
    int id = DateTime.now().microsecond;
    await notificationsPlugin.show(id, title, body, notificationDetail,
        payload: channelID ?? 'IOS');
  }
}
