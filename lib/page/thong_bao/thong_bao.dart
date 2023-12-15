import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/notification_service/notification_service.dart';
import 'package:ib_sme_mb_view/page/thong_bao/chi_tiet_thong_bao.dart';
import 'package:ib_sme_mb_view/provider/notification_provider.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import 'dart:developer' as dev;

class ThongBaoPageWidget extends StatefulWidget {
  const ThongBaoPageWidget({super.key});

  @override
  State<ThongBaoPageWidget> createState() => _ThongBaoPageWidgetState();
}

class _ThongBaoPageWidgetState extends State<ThongBaoPageWidget>
    with BaseComponent {
  int checkTab = 0;
  List<NotificationBalanceModel> notificationBalanceList = [];
  List<NotificationSomethingModel> notificationSomethingList = [];

  @override
  void initState() {
    getListNotificationBalances(2);
    getListNotificationSomething(2);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getListNotificationBalances(size) async {
    page.curentPage = 1;
    page.size = size;
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
        if (page.curentPage == 1) {
          await Provider.of<NotificationProvider>(context, listen: false)
              .setBalance(notificationBalanceList);
        } else if (page.curentPage >= 2) {
          await Provider.of<NotificationProvider>(context, listen: false)
              .addBalance(notificationBalanceList);
        }
      }
    }
  }

  getListNotificationSomething(size) async {
    page.curentPage = 1;
    page.size = size;
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
        automaticallyImplyLeading: false,
        title: Text(translation(context)!.notificationKey),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: renderBodyThongBao(),
    );
  }

  renderBodyThongBao() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      checkTab = 0;
                    });
                  },
                  child: renderItemTab(
                      label: translation(context)!.allKey,
                      color: checkTab == 0 ? secondaryColor : primaryColor),
                ),
              ),
              const SizedBox(
                width: 0.2,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      checkTab = 1;
                    });
                    getListNotificationBalances(2000);
                  },
                  child: renderItemTab(
                      label: translation(context)!.balance_alertKey,
                      color: checkTab == 1 ? secondaryColor : primaryColor),
                ),
              ),
              const SizedBox(
                width: 0.2,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      checkTab = 2;
                    });
                    getListNotificationSomething(1000);
                  },
                  child: renderItemTab(
                      label: translation(context)!.otherKey,
                      color: checkTab == 2 ? secondaryColor : primaryColor),
                ),
              ),
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (checkTab == 1) renderBalanceFluctuation(),
                      if (checkTab == 2) renderSomeThing(),
                      if (checkTab == 0)
                        Column(
                          children: [
                            if (notificationBalanceList.isNotEmpty)
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        translation(context)!.balance_alertKey,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkTab = 1;
                                          });
                                          getListNotificationBalances(2000);
                                        },
                                        child: Text(
                                          translation(context)!.allKey,
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  renderBalanceFluctuation(),
                                  const SizedBox(
                                    height: 32.0,
                                  ),
                                ],
                              ),
                            if (notificationSomethingList.isNotEmpty)
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        translation(context)!.otherKey,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            checkTab = 2;
                                          });
                                          getListNotificationSomething(1000);
                                        },
                                        child: Text(
                                          translation(context)!.allKey,
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  renderSomeThing()
                                ],
                              )
                          ],
                        ),
                    ],
                  )))
        ],
      ),
    );
  }

  renderBalanceFluctuation() {
    return Consumer<NotificationProvider>(
        builder: (context, notificationBalanceProvider, child) {
      int lengthBalance = notificationBalanceProvider.itemsBalance.length;
      return (notificationBalanceProvider.itemsBalance.isNotEmpty)
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: checkTab == 1
                  ? lengthBalance
                  : lengthBalance > 2
                      ? 2
                      : lengthBalance,
              itemBuilder: (context, index) {
                NotificationBalanceModel notificationBalanceModel =
                    notificationBalanceProvider.itemsBalance[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChiTietThongBao(
                                    titles:
                                        translation(context)!.balance_alertKey,
                                    notificationBalanceModel:
                                        notificationBalanceModel,
                                  )));
                    },
                    child: CardLayoutWidget(
                      backgroungColor: (notificationBalanceModel.isRead! == '1')
                          ? null
                          : const Color.fromARGB(255, 244, 250, 255),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Currency.formatCurrency(
                                    notificationBalanceModel.amount ?? ''),
                                style: TextStyle(
                                    color: notificationBalanceModel.type == '0'
                                        ? Colors.deepOrangeAccent
                                        : primaryColor),
                              ),
                              Text(
                                convertDateTimeFormat(
                                    notificationBalanceModel.createdAt ?? ""),
                                style: const TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                                '${translation(context)!.codeKey}: ${notificationBalanceModel.txnum}'),
                          ),
                          Text(
                              '${translation(context)!.contentKey}: ${notificationBalanceModel.message}')
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
              'Không có dữ liệu',
              style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            ));
    });
  }

  renderSomeThing() {
    return Consumer<NotificationProvider>(
        builder: (context, notificationSomethingProvider, child) {
      int lengthSomething = notificationSomethingProvider.itemsSomething.length;
      return (notificationSomethingProvider.itemsSomething.isNotEmpty)
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: checkTab == 2
                  ? lengthSomething
                  : lengthSomething > 2
                      ? 2
                      : lengthSomething,
              itemBuilder: (context, index) {
                NotificationSomethingModel notificationSomethingModel =
                    notificationSomethingProvider.itemsSomething[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChiTietThongBao(
                                    notificationSomethingModel:
                                        notificationSomethingModel,
                                    titles: notificationSomethingModel.title
                                        .toString()
                                        .toUpperCase(),
                                    imageUrl: notificationSomethingModel.image,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: (notificationSomethingModel.isRead! == '1')
                                ? Colors.white
                                : const Color.fromARGB(255, 244, 250, 255),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(139, 146, 165, 0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (notificationSomethingModel.type == '0' &&
                                (notificationSomethingModel.image != '' ||
                                    notificationSomethingModel
                                        .image!.isNotEmpty))
                              SizedBox(
                                width: double.infinity,
                                height: 120,
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        notificationSomethingModel.image!),
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) {
                                      // Xử lý khi gặp lỗi
                                      dev.log(
                                          'Error loading image: $exception');
                                    },
                                  ),
                                )),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                              child: Text(
                                notificationSomethingModel.title!.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (notificationSomethingModel.type == '1')
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12.0, bottom: 10.0),
                                child: Text(
                                  notificationSomethingModel.content!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            if (notificationSomethingModel.type == '1')
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, bottom: 12.0),
                                child: Text(
                                  convertDateFormat(notificationSomethingModel
                                      .createdAt
                                      .toString()),
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (notificationSomethingModel.type == '0')
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, bottom: 12.0),
                                child: Text(
                                  '${convertDateFormat(notificationSomethingModel.publishedDate.toString())} ${notificationSomethingModel.publishedDate != null ? '- ${convertDateFormat(notificationSomethingModel.publishedDate.toString())}' : ''}',
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          : const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              ),
            );
    });
  }

  renderItemTab({String? label, Color? color}) {
    return SizedBox(
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color!,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        ),
        child: Center(
          child: Text(
            label!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
