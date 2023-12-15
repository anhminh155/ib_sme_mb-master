// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/page/thong_bao/chi_tiet_thong_bao.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/providers.dart';

void navigateToNotificationScreen(
    BuildContext context, RemoteMessage message, String status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sharedpf.removeNotificationUnreadClicked(status);
  int counts = prefs.getInt('unreadNotifications') ?? 0;
  var counter = Provider.of<CountUnreadProvider>(context, listen: false);
  await counter.saveCountUnread(counts);
  if (counts >= 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiTietThongBao(
            titles: message.notification?.title?.toUpperCase() ?? '',
            imageUrl: message.data['image'],
            message: message),
      ),
    );
  }
}
