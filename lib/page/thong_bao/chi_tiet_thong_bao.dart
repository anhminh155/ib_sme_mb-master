import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/notification_service/notification_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:provider/provider.dart';

class ChiTietThongBao extends StatefulWidget {
  final String? titles;
  final RemoteMessage? message;
  final String? imageUrl;
  final NotificationBalanceModel? notificationBalanceModel;
  final NotificationSomethingModel? notificationSomethingModel;
  const ChiTietThongBao(
      {super.key,
      this.titles,
      this.imageUrl,
      this.message,
      this.notificationBalanceModel,
      this.notificationSomethingModel});

  @override
  State<ChiTietThongBao> createState() => _ChiTietThongBaoState();
}

class _ChiTietThongBaoState extends State<ChiTietThongBao> with BaseComponent {
  String content = '';
  String? code;
  String? status;
  String? title;
  String? type;

  List<NotificationBalanceModel> notificationBalanceList = [];
  List<NotificationSomethingModel> notificationSomethingList = [];
  @override
  void initState() {
    setState(() {
      if (widget.notificationBalanceModel != null) {
        content = widget.notificationBalanceModel!.message ?? '';
        code = widget.notificationBalanceModel!.id ?? '';
        title = widget.notificationBalanceModel!.title ?? '';
      }

      if (widget.notificationSomethingModel != null) {
        content = widget.notificationSomethingModel!.content ?? '';
        code = widget.notificationSomethingModel!.id ?? '';
        title = widget.notificationSomethingModel!.title ?? '';
        type = widget.notificationSomethingModel!.type ?? '';
      }

      if (widget.message != null) {
        content = widget.message!.data['content'];
        code = widget.message!.data['id'];
        title = widget.message!.notification!.title ?? '';
        type = widget.message!.data['type'];
      }
    });
    readNotification();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  readNotification() async {
    if (title!.compareTo('Thông báo biến động số dư') == 0) {
      BaseResponse response =
          await NotificationServices().readNotification(code);
      if (response.errorCode == FwError.THANHCONG.value) {
        if (mounted) {
          getListNotificationBalances();
        }
      }
    } else {
      BaseResponse response =
          await NotificationServices().readNotificationSomething(code, type);
      if (response.errorCode == FwError.THANHCONG.value) {
        if (mounted) {
          getListNotificationSomething();
        }
      }
    }
  }

  getListNotificationBalances() async {
    page.curentPage = 1;
    page.size = 20;
    BaseResponseDataList response =
        await NotificationServices().getListNotificationBlances(page);
    if (response.errorCode == FwError.THANHCONG.value) {
      dataResponse = response.data!
          .map((notificationBalances) =>
              NotificationBalanceModel.fromJson(notificationBalances))
          .toList();
      if (mounted) {
        setState(() {
          notificationBalanceList = dataResponse;
        });
        await Provider.of<NotificationProvider>(context, listen: false)
            .setBalance(notificationBalanceList);
      }
    }
  }

  getListNotificationSomething() async {
    page.curentPage = 1;
    page.size = 20;
    BaseResponseDataList response =
        await NotificationServices().getListNotificationSomething(page);
    if (response.errorCode == FwError.THANHCONG.value) {
      dataResponse = response.data!
          .map((notificationSomethingList) =>
              NotificationSomethingModel.fromJson(notificationSomethingList))
          .toList();
      if (mounted) {
        setState(() {
          notificationSomethingList = dataResponse;
        });
        if (page.curentPage == 1) {
          await Provider.of<NotificationProvider>(context, listen: false)
              .setSomething(notificationSomethingList);
        } else if (page.curentPage >= 2) {
          await Provider.of<NotificationProvider>(context, listen: false)
              .addSomething(notificationSomethingList);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết thông báo"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: (widget.titles!.compareTo(translation(context)!.balance_alertKey) ==
                  0 ||
              widget.message?.notification!.title!
                      .compareTo(translation(context)!.balance_alertKey) ==
                  0)
          ? renderBodyBalanceFluctuation(widget.titles)
          : renderBodySomeThingNotice(widget.titles),
    );
  }

  renderBodyBalanceFluctuation(title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }

  renderBodySomeThingNotice(title) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
          ),
          if ((widget.imageUrl != null || widget.imageUrl != '') && type != '1')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Image(
                fit: BoxFit.fitWidth,
                image: NetworkImage(
                  '${widget.imageUrl}',
                ),
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
          if (widget.message != null ||
              widget.notificationSomethingModel?.content != null)
            Text(
              content,
              style: const TextStyle(fontSize: 15, height: 1.4),
              textAlign: TextAlign.justify,
            ),
        ],
      ),
    );
  }
}
