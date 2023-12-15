import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/index_widget.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_giao_dich_thong_thuong/thong_tin_giao_dich_thong_thuong.dart';
import 'package:intl/intl.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../network/services/transmanagement_service/download_file_service.dart';
import '../../../network/services/transmanagement_service/search_transaction.dart';
import '../../../utils/theme.dart';
import '../getcolor_status.dart';
import 'note_widget.dart';

class ListResltNormalTransaction extends StatefulWidget {
  final TranSearch? regularTransaction;
  final String? acoountCode;
  const ListResltNormalTransaction(
      {super.key, this.regularTransaction, this.acoountCode});

  @override
  State<ListResltNormalTransaction> createState() =>
      _ListResltNormalTransactionState();
}

class _ListResltNormalTransactionState extends State<ListResltNormalTransaction>
    with BaseComponent, SingleTickerProviderStateMixin {
  late TabController tabController;
  int pages = 1;
  List<dynamic> listRegulaTransactions = [];

  int totalElements = 0;
  int indexTab = 0;
  final convert = NumberFormat("#,### VND", "en_US");

  searchRegularTransaction({int? curentPage}) async {
    page.curentPage = curentPage!;
    page.size = 10;
    BasePagingResponse response = await SearchTransactionService()
        .searchPaging('/api/tran', page, widget.regularTransaction);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        pages++;
        listResponse = response.data!.content!
            .map((regularTransaction) => Tran.fromJson(regularTransaction))
            .toList();
        totalElements = response.data!.totalElements!;
        listRegulaTransactions.addAll(listResponse);
        isLoading = false;
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
    searchRegularTransaction(curentPage: pages);
    super.initState();
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
        title: const Text('Giao dịch thông thường'),
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
              indicatorWeight: 1.5,
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
                                totalElements.toString(),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: NoteWidget(
                taiKhoanNguon: widget.acoountCode,
              ),
            ),
            Expanded(
              child: TabBarView(
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
              ),
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
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: [
                SizedBox(
                  // height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listRegulaTransactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _renderItem(listRegulaTransactions[index], 1,
                          index); // Trả về widget tại vị trí index
                    },
                  ),
                ),
                if (listRegulaTransactions.length != totalElements)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          searchRegularTransaction(curentPage: pages);
                        },
                        child: const Text(
                          "Xem thêm",
                          style: TextStyle(
                              color: Colors.black45,
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                              decoration: TextDecoration.underline),
                        )),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ButtonWidget(
              backgroundColor: Colors.white,
              onPressed: () async {
                await saveFileFromAPI(context,
                    fileName: 'GDTT',
                    requestBody: widget.regularTransaction,
                    url: '/api/tran/export');
              },
              text: 'Tải danh sách',
              colorText: secondaryColor,
              colorBorder: secondaryColor,
              haveBorder: true,
              widthButton: MediaQuery.of(context).size.width),
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
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     lable,
  //                     style: const TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w600,
  //                         color: secondaryColor),
  //                   ),
  //                   Text(
  //                     "Tổng giao dịch: $totalElements",
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemCount: listRegulaTransactions.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return _renderItem(listRegulaTransactions[index], 2,
  //                         index); // Trả về widget tại vị trí index
  //                   },
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: TextButton(
  //                     onPressed: () {
  //                       searchRegularTransaction(curentPage: pages);
  //                     },
  //                     child: const Text(
  //                       "Xem thêm",
  //                       style: TextStyle(
  //                           color: Colors.black45,
  //                           fontStyle: FontStyle.italic,
  //                           fontSize: 13,
  //                           decoration: TextDecoration.underline),
  //                     )),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  //         child: ButtonWidget(
  //             backgroundColor: Colors.white,
  //             onPressed: () {},
  //             text: 'Tải danh sách',
  //             colorText: secondaryColor,
  //             colorBorder: secondaryColor,
  //             haveBorder: true,
  //             widthButton: MediaQuery.of(context).size.width),
  //       ),
  //     ],
  //   );
  // }

  _renderItem(data, value, index) {
    //value = 1: Chuyển thiền
    //value = 2: Thanh toán
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThongTinGiaoDich(
                    code: data.code!,
                  ),
                ),
              );
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
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text.rich(
                      TextSpan(
                          text: "Trạng thái:  ",
                          style: const TextStyle(color: Colors.black45),
                          children: [
                            TextSpan(
                              text: StatusTrans.getStringByValue(data.status),
                              style: TextStyle(
                                color: getColorByValue(
                                    StatusTrans.getStringByValue(data.status)),
                              ),
                            ),
                          ]),
                    )
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
