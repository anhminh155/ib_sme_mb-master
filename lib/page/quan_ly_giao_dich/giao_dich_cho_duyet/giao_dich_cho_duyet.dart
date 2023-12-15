import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/download_file_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';

import '../../../common/card_layout.dart';
import '../../../common/index_widget.dart';
import '../../../network/services/transmanagement_service/search_transaction.dart';
import 'thong_tin_giao_dich_cho_duyet.dart';

class GiaoDichChoDuyetPageWidget extends StatefulWidget {
  final TranSearch? tranSearch;
  final RolesAcc? rolesAcc;
  const GiaoDichChoDuyetPageWidget({super.key, this.tranSearch, this.rolesAcc});

  @override
  State<GiaoDichChoDuyetPageWidget> createState() =>
      _GiaoDichChoDuyetPageWidgetState();
}

class _GiaoDichChoDuyetPageWidgetState extends State<GiaoDichChoDuyetPageWidget>
    with BaseComponent, SingleTickerProviderStateMixin {
  int pageTransDuyet = 1;
  int pageTransSchedule = 1;
  int sumTrans = 0;
  bool hasMore = true;
  int totalElementsTransDuyet = 0;
  int totalElementsTransSchedule = 0;
  int indexTab = 0;
  List<dynamic> listTrans = [];
  List<dynamic> listTransSchedules = [];
  late TabController tabController;
  final convert = NumberFormat("#,### VND", "en_US");

  getTranDuyet({int? curentPageTranDuyet, int? pageSize}) async {
    page.size = pageSize;
    page.curentPage = curentPageTranDuyet!;
    BasePagingResponse response = await SearchTransactionService()
        .searchPaging('/api/tran/tranduyet', page, widget.tranSearch);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        pageTransDuyet++;
        listResponse = response.data!.content!
            .map((regularTransaction) => Tran.fromJson(regularTransaction))
            .toList();
        totalElementsTransDuyet = response.data!.totalElements!;
        listTrans.addAll(listResponse);
      });
    } else if (response.errorMessage != null && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getTranScheduleDuyet({int? curentPageTranschedule, int? pageSize}) async {
    page.size = pageSize;
    BasePagingResponse response = await SearchTransactionService().searchPaging(
        '/api/transschedule/tranduyetmb', page, widget.tranSearch);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        pageTransSchedule++;
        listResponse = response.data!.content!
            .map((regularTransaction) =>
                TransScheduleModel.fromJson(regularTransaction))
            .toList();
        totalElementsTransSchedule = response.data!.totalElements!;
        listTransSchedules.addAll(listResponse);
      });
    } else if (response.errorMessage != null && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(
      () => setState(() {
        indexTab = tabController.index;
      }),
    );
    super.initState();
    getAllApi();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  getAllApi() async {
    if (mounted) {
      final futures = <Future>[
        getTranDuyet(curentPageTranDuyet: pageTransDuyet, pageSize: 2),
        getTranScheduleDuyet(
            curentPageTranschedule: pageTransSchedule, pageSize: 2),
      ];
      final result = await Future.wait<dynamic>(futures);
      if (result.isNotEmpty) {
        setState(() {
          sumTrans = totalElementsTransDuyet + totalElementsTransSchedule;
          isLoading = !isLoading;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        title: const Text("Giao dịch chờ duyệt"),
        backgroundColor: primaryColor,
      ),
      body: DefaultTabController(
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
                                sumTrans.toString(),
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 3.0),
                              child: Text(
                                0.toString(),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CardLayoutWidget(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tài khoản nguồn"),
                    Text(widget.tranSearch?.taiKhoanNguon ?? 'Tất cả')
                  ],
                ),
              ),
            ),
            Expanded(
              child: (!isLoading)
                  ? TabBarView(
                      controller: tabController,
                      children: [
                        _renderTransactions('Chuyển tiền'),
                        // _renderPays("Thanh toán"), Giai đoạn 2
                        const Center(
                          child: Text(
                            'Tính năng đang được cập nhật',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    )
                  : const LoadingCircle(),
            )
          ],
        ),
      ),
    );
  }

  _renderTransactions(lable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                renderTypeTrans('Chuyển tiền thông thường',
                    totalElementsTransDuyet, listTrans, 1),
                const SizedBox(
                  height: 16.0,
                ),
                renderTypeTrans('Chuyển tiền tương lai định kỳ',
                    totalElementsTransSchedule, listTransSchedules, 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // _renderPays(lable) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: SingleChildScrollView(
  //           padding:
  //               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  //           child: Column(
  //             children: [
  //               renderTypeTrans(
  //                   'Thanh toán', totalElementsTransDuyet, listTrans, 3),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  renderTypeTrans(String lable, int totalElement, List listTemmp, int value) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              lable,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(
              width: 10.0,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
                child: Text(
                  totalElement.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            if (value == 1 && totalElementsTransDuyet >= 1)
              InkWell(
                onTap: () async {
                  await saveFileFromAPI(context,
                      fileName: 'GDTTCD',
                      requestBody: widget.tranSearch,
                      url: '/api/tran/downloadgiaodich');
                },
                child: const Row(children: [
                  Icon(
                    Icons.download,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    'Tải file',
                    style: TextStyle(color: primaryColor),
                  )
                ]),
              ),
            if (value == 2 && totalElementsTransSchedule >= 1)
              InkWell(
                onTap: () async {
                  await saveFileFromAPI(context,
                      fileName: 'GDTLDKCD',
                      requestBody: widget.tranSearch,
                      url: '/api/transschedule/downloadgiaodich');
                },
                child: const Row(children: [
                  Icon(
                    Icons.download,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    'Tải file',
                    style: TextStyle(color: primaryColor),
                  )
                ]),
              )
          ],
        ),

        if (value == 1)
          totalElementsTransDuyet >= 1
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listTemmp.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _renderItem(listTemmp[index], value,
                        index); // Trả về widget tại vị trí index
                  },
                )
              : const SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      'Không có dữ liệu',
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),

        if (value == 2)
          totalElementsTransSchedule >= 1
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listTemmp.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _renderItem(listTemmp[index], value,
                        index); // Trả về widget tại vị trí index
                  },
                )
              : const SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      'Không có dữ liệu',
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
        if (value == 1 && listTemmp.length < totalElementsTransDuyet)
          renderButtonViewMore(onTap: () async {
            await getTranDuyet(
                curentPageTranDuyet: pageTransDuyet, pageSize: 2);
          }),
        if (value == 2 && listTemmp.length < totalElementsTransSchedule)
          renderButtonViewMore(onTap: () async {
            await getTranScheduleDuyet(
                curentPageTranschedule: pageTransSchedule, pageSize: 2);
          }),
        // if (value == 3 && listTemmp.length < totalElementsTransSchedule)
        //   renderButtonViewMore(onTap: () async {
        //     await getTranScheduleDuyet(
        //         curentPageTranschedule: pageTransSchedule, pageSize: 2);
        //   }),
      ],
    );
  }

  renderButtonViewMore({Function? onTap}) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () {
            onTap!();
          },
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

  _renderItem(data, value, index) {
    //value = 1: Chuyển thiền thông thường
    //value = 2: Chuyển tiền tương lai định kỳ
    //value = 3: Thanh toán
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThongTinGiaoDichChoDuyet(
                    code: data.code,
                    value: value,
                    sendAccount: data.sendAccount,
                    rolesAcc: widget.rolesAcc,
                  ),
                ),
              );
              if (result.toString().compareTo('Thành công') == 0) {
                setState(() {
                  listTrans.clear();
                  listTransSchedules.clear();
                  pageTransDuyet = 1;
                  pageTransSchedule = 1;
                  isLoading = !isLoading;
                  getAllApi();
                });
              }
            },
            child: CardLayoutWidget(
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
                          convert.format(int.tryParse(data.amount.toString())),
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                        Text(
                          data.code,
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
                              text: TransType.getNameByStringKey(data.type),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text.rich(
                      TextSpan(
                          text: value == 1
                              ? "Người nhận:  "
                              : value == 2
                                  ? "Nhà cung cấp:  "
                                  : '',
                          style: const TextStyle(color: Colors.black45),
                          children: [
                            TextSpan(
                              text: data.receiveName,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IndexWidget(
            index: index + 1,
          ),
        ],
      ),
    );
  }
}
