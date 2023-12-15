// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/index_widget.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_danh_sach_lenh_tu_choi/thong_tin_lenh_tu_choi.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:provider/provider.dart';

import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/dialog_confirm.dart';
import '../../../network/services/transmanagement_service/reject_trans_service.dart';
import '../../../provider/providers.dart';
import '../../../utils/theme.dart';
import '../quan_ly_giao_dich_thong_thuong/note_widget.dart';

class DanhSachLenhTuChoi extends StatefulWidget {
  const DanhSachLenhTuChoi({super.key});

  @override
  State<DanhSachLenhTuChoi> createState() => _DanhSachLenhTuChoiState();
}

class _DanhSachLenhTuChoiState extends State<DanhSachLenhTuChoi>
    with SingleTickerProviderStateMixin {
  int pageTT = 0;
  int pageTL = 0;
  int size = 5;
  bool _isLoading = false;
  int indexTab = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(
      () => setState(() {
        indexTab = tabController.index;
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 55,
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
          title: const Text('Danh sách lệnh từ chối'),
          backgroundColor: primaryColor,
        ),
        body: Stack(
          children: [renderBody(), if (_isLoading) const LoadingCircle()],
        ));
  }

  renderBody() {
    return Consumer<RejectTransProvider>(
        builder: (context, rejectTransProvider, child) {
      var listTransTT = rejectTransProvider.listTransTT;
      var listTransTL = rejectTransProvider.listTransTL;
      var totalTransTT = rejectTransProvider.totalTransTT;
      var totalTransTL = rejectTransProvider.totalTransTL;
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              indicatorColor: secondaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 1,
              labelColor: colorBlack_17191B,
              unselectedLabelColor: colorBlack_727374,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Chuyển tiền'),
                        SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: indexTab == 1
                                    ? Colors.red.shade300
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 3.0),
                              child: Text(
                                '${totalTransTL! + totalTransTT!}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Thanh toán'),
                        SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: indexTab == 0
                                    ? Colors.red.shade300
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 3.0),
                              child: Text(
                                // totalElements.toString(),
                                '0',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: NoteWidget(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  renderTransTab(
                      listTransTT, listTransTL, totalTransTT, totalTransTL),
                  renderPaysTab(),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  renderTransTab(listTransTT, listTransTL, totalTransTT, totalTransTL) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: TabBar(
              indicatorColor: primaryColor,
              indicator: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: secondaryColor, // Màu sắc của toàn bộ TabBar
              ),
              labelColor: colorBlack_17191B,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Thông thường',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 3.0),
                              child: Text(
                                '$totalTransTT',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tương lai định kỳ',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 3.0),
                              child: Text(
                                '${totalTransTL!}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SizedBox(
                  height: 30,
                  child: renderBodyTransTT(listTransTT, totalTransTT),
                ),
                SizedBox(
                  height: 30,
                  child: renderBodyTransTLDK(listTransTL, totalTransTL),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  renderBodyTransTT(List<RejectTransResponse> listTransTT, int totalTransTT) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: [
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listTransTT.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _renderItem(listTransTT[index], index,
                          true); // Trả về widget tại vị trí index
                    },
                  ),
                ),
                if (listTransTT.length < totalTransTT)
                  renderShowMore(_ontapShowMoreTT)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ButtonWidget(
              backgroundColor: Colors.white,
              onPressed: totalTransTT > 0 ? _onPressDownloadFileTransTT : null,
              text: 'Tải danh sách',
              colorText: secondaryColor,
              colorBorder: secondaryColor,
              haveBorder: true,
              widthButton: MediaQuery.of(context).size.width),
        ),
      ],
    );
  }

  _onPressDownloadFileTransTT() {
    try {
      var request =
          Provider.of<RejectTransProvider>(context, listen: false).requestTT;
      RejectTransactionService().downloadFileTT(request!, context);
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _onPressDownloadFileTransTLDK() {
    try {
      var request =
          Provider.of<RejectTransProvider>(context, listen: false).requestTL;
      RejectTransactionService().downloadFileTT(request!, context);
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  renderBodyTransTLDK(
      List<RejectTransResponse> listTransTLDK, int totalTransTLDK) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: [
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listTransTLDK.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _renderItem(listTransTLDK[index], index,
                          false); // Trả về widget tại vị trí index
                    },
                  ),
                ),
                if (listTransTLDK.length < totalTransTLDK)
                  renderShowMore(_ontapShowMoreTLDK)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ButtonWidget(
              backgroundColor: Colors.white,
              onPressed:
                  totalTransTLDK > 0 ? _onPressDownloadFileTransTLDK : null,
              text: 'Tải danh sách',
              colorText: secondaryColor,
              colorBorder: secondaryColor,
              haveBorder: true,
              widthButton: MediaQuery.of(context).size.width),
        ),
      ],
    );
  }

  renderShowMore(function) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: function,
          child: const Text(
            "Xem thêm",
            style: TextStyle(
                color: Colors.black45,
                fontStyle: FontStyle.italic,
                fontSize: 13,
                decoration: TextDecoration.underline),
          )),
    );
  }

  Future<void> _ontapShowMoreTT() async {
    var request =
        Provider.of<RejectTransProvider>(context, listen: false).requestTT;
    if (request != null) {
      request.page = pageTT + 1;
      setState(() => _isLoading == true);
      BasePagingResponse response =
          await RejectTransactionService().getTTTransaction(request);
      setState(() => _isLoading == false);
      if (response.errorCode == FwError.THANHCONG.value) {
        var items = response.data!.content!
            .map((e) => RejectTransResponse.fromJson(e))
            .toList();
        Provider.of<RejectTransProvider>(context, listen: false)
            .addTransTT(items);
        setState(() {
          pageTT++;
        });
      }
    }
  }

  Future<void> _ontapShowMoreTLDK() async {
    var request =
        Provider.of<RejectTransProvider>(context, listen: false).requestTL;
    if (request != null) {
      request.page = pageTL + 1;
      setState(() => _isLoading == true);
      BasePagingResponse response =
          await RejectTransactionService().getTLTransaction(request);
      setState(() => _isLoading == false);
      if (response.errorCode == FwError.THANHCONG.value) {
        var items = response.data!.content!
            .map((e) => RejectTransResponse.fromJson(e))
            .toList();
        Provider.of<RejectTransProvider>(context, listen: false)
            .addTransTL(items);
        setState(() {
          pageTL++;
        });
      }
    }
  }

  renderPaysTab() {
    return const Center(
      child: Text(
        'Tính năng đang được cập nhật',
        style: TextStyle(
            color: Colors.black26,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  _onPressItem(String code, bool isTT) {
    if (isTT) {
      _onPressItemTT(code);
    } else {
      _onPressItemTLDK(code);
    }
  }

  _onPressItemTT(String code) async {
    setState(() {
      _isLoading = true;
    });
    BaseResponse response =
        await RejectTransactionService().getTTTransactionDetail(code);
    setState(() {
      _isLoading = false;
    });
    if (response.errorCode == FwError.THANHCONG.value) {
      RejectTransDetailTTResponse transInfo =
          RejectTransDetailTTResponse.fromJson(response.data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThongTinLenhTuChoi(
            transInfo: transInfo,
          ),
        ),
      );
    } else {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  _onPressItemTLDK(String code) async {
    setState(() {
      _isLoading = true;
    });
    BaseResponse response =
        await RejectTransactionService().getTLTransactionDetail(code);
    setState(() {
      _isLoading = false;
    });
    if (response.errorCode == FwError.THANHCONG.value) {
      RejectTransDetailTTResponse transInfo =
          RejectTransDetailTTResponse.fromJson(response.data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThongTinLenhTuChoi(
            transInfo: transInfo,
          ),
        ),
      );
    } else {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  _renderItem(RejectTransResponse item, int index, bool isTT) {
    //isTT = true: TT
    //isTT = false: TLDK
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _onPressItem(item.code ?? '', isTT),
        child: Stack(
          children: [
            CardLayoutWidget(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Currency.formatCurrency(
                              int.parse(item.amount ?? '0')),
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                        Text(
                          item.code ?? "",
                          style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text.rich(
                      TextSpan(
                          text: "Loại giao dịch:  ",
                          style: const TextStyle(color: Colors.black45),
                          children: [
                            TextSpan(
                              text: TransType.getNameByStringKey(
                                  item.type ?? '',
                                  schedules: item.schedules),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text.rich(
                      TextSpan(
                          text: "Người nhận:  ",
                          style: const TextStyle(color: Colors.black45),
                          children: [
                            TextSpan(
                              text: item.receiveName,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            IndexWidget(index: index + 1)
          ],
        ),
      ),
    );
  }
}
