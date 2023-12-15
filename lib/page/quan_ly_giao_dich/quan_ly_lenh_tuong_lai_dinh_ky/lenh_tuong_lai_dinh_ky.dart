import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/checkbox.dart';
import 'package:ib_sme_mb_view/common/index_widget.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/getcolor_status.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_lenh_tuong_lai_dinh_ky/thong_tin_lenh_tuong_lai_dinh_ky.dart';
import 'package:intl/intl.dart';
import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/dialog_confirm.dart';
import '../../../network/services/transmanagement_service/download_file_service.dart';
import '../../../network/services/transmanagement_service/search_transaction.dart';
import '../../../network/services/transmanagement_service/update_trans_service.dart';
import '../../../utils/theme.dart';

class ListResltRecurringFuture extends StatefulWidget {
  final TranSearch? tranSearch;
  const ListResltRecurringFuture({super.key, this.tranSearch});

  @override
  State<ListResltRecurringFuture> createState() =>
      ListResltRecurringFutureState();
}

class ListResltRecurringFutureState extends State<ListResltRecurringFuture>
    with BaseComponent {
  List<TransSchedulesDetailsModel> listTrans = [];
  bool selectAll = false;
  bool statusDelete = false;
  List listCount = [];
  final convert = NumberFormat("#,### VND", "en_US");
  bool hasMore = true;
  int totalElements = 0;
  int pages = 1;
  bool checkStatus = false;

  List<dynamic> listScheduleTransactions = [];

  late TextEditingController controllerReason;

  updateSelectAll(List<TransSchedulesDetailsModel> listTranss) {
    for (TransSchedulesDetailsModel item in listScheduleTransactions) {
      if (item.paymentStatus!
                  .compareTo(StatusPaymentTrans.CHOXULY.value.toString()) ==
              0 &&
          !listCount.contains(item)) {
        listCount.add(item);
      }
    }
    setState(() {
      if (listTranss.length == listCount.length) {
        selectAll = true;
      } else {
        selectAll = false;
      }
    });
  }

  searchShceduTransactions({int? curentPage, int? size}) async {
    page.curentPage = curentPage!;
    size != null ? page.size = size : page.size = 10;
    BasePagingResponse response = await SearchTransactionService().searchPaging(
        '/api/transschedulesdetail', page, widget.tranSearch, true);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        pages++;
        listResponse = response.data!.content!
            .map((scheduleTransaction) =>
                TransSchedulesDetailsModel.fromJson(scheduleTransaction))
            .toList();
        for (TransSchedulesDetailsModel item in listResponse) {
          if (item.paymentStatus!
                  .compareTo(StatusPaymentTrans.CHOXULY.value.toString()) ==
              0) {
            checkStatus = true;

            break;
          }
        }
        totalElements = response.data!.totalElements!;
        listScheduleTransactions.addAll(listResponse);
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

  cancelMultiTrans(List<TransSchedulesDetailsModel> listTrans) async {
    BaseResponse response =
        await UpdateTransactionService().cancelTransScheduleMuti(listTrans);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listScheduleTransactions.clear();
        searchShceduTransactions(curentPage: 1, size: (pages - 1) * 10);
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  @override
  void initState() {
    super.initState();
    controllerReason = TextEditingController();
    searchShceduTransactions(curentPage: pages);
  }

  @override
  void dispose() {
    super.dispose();
    controllerReason.dispose();
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
        title: const Text('Quản lý lệnh tương lại/định kỳ'),
        backgroundColor: primaryColor,
      ),
      body: (!isLoading)
          ? (totalElements == 0)
              ? const Center(
                  child: Text(
                    "Không có dữ liệu",
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                )
              : _renderTransactions('Chuyển tiền')
          : const LoadingCircle(),
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
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lable,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: secondaryColor),
                  ),
                  Text(
                    "Tổng giao dịch: $totalElements",
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (checkStatus)
                Row(
                  children: [
                    Expanded(
                      child: CheckBoxWidget(
                        content: const Text('Tất cả'),
                        value: selectAll,
                        handleSelected: (value) {
                          setState(
                            () {
                              selectAll = value!;
                              if (value) {
                                for (TransSchedulesDetailsModel item
                                    in listScheduleTransactions) {
                                  if (item.paymentStatus!.compareTo(
                                          StatusPaymentTrans.CHOXULY.value
                                              .toString()) ==
                                      0) {
                                    listTrans.add(item);
                                  }
                                }
                              } else {
                                listTrans.clear();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    if (listTrans.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          await showDiaLogConfirm(
                            context: context,
                            close: true,
                            content: const Text(
                              "Quý khách có muốn hủy các lệnh chuyển tiền trong tương lai này không?",
                              textAlign: TextAlign.center,
                            ),
                            note: "Vui lòng nhập lý do",
                            handleContinute: (String? reason) async {
                              for (var trnas in listTrans) {
                                trnas.reason = reason;
                              }
                              await cancelMultiTrans(listTrans);
                              setState(() {
                                pages = 2;
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: primaryColor),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: const Text(
                            "Hủy",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      )
                  ],
                ),
              SizedBox(
                // height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listScheduleTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _renderItem(listScheduleTransactions[index], 1,
                        index); // Trả về widget tại vị trí index
                  },
                ),
              ),
              if (listScheduleTransactions.length < totalElements)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () async {
                        await searchShceduTransactions(curentPage: pages);
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
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: ButtonWidget(
              backgroundColor: Colors.white,
              onPressed: () async {
                await saveFileFromAPI(context,
                    url: '/api/transschedulesdetail/export',
                    fileName: 'LTLDK',
                    requestBody: widget.tranSearch);
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

  _renderItem(TransSchedulesDetailsModel data, value, index) {
    //value = 1: Chuyển thiền
    //value = 2: Thanh toán
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ThongTinLenhTuongLaiDinhKy(maGiaoDich: data.code!),
                ),
              );
              if (result == 'Thành công') {
                setState(() {
                  listScheduleTransactions.clear();
                  searchShceduTransactions(
                      curentPage: 1, size: (pages - 1) * 10);
                  pages = 2;
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
                          convert.format(int.tryParse(
                              data.transSchedule!.amount.toString())),
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                        Text(
                          StatusPaymentTrans.getStringByValue(
                              data.paymentStatus),
                          style: TextStyle(
                              color: getColorByValue(
                                  StatusPaymentTrans.getStringByValue(
                                      data.paymentStatus!)),
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
                                  data.transSchedule!.type!),
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
                              text: data.transSchedule!.receiveName,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mã tham chiếu:  ',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Expanded(
                          child: Text(
                            data.transSchedule!.code!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mã giao dịch:  ',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Expanded(
                          child: Text(
                            data.code!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        if (data.paymentStatus.toString().compareTo(
                                StatusPaymentTrans.CHOXULY.value.toString()) ==
                            0)
                          const SizedBox(
                            width: 8.0,
                          ),
                        if (data.paymentStatus.toString().compareTo(
                                StatusPaymentTrans.CHOXULY.value.toString()) ==
                            0)
                          CheckBoxWidget(
                            value: listTrans.contains(data),
                            handleSelected: (value) {
                              setState(() {
                                if (value) {
                                  listTrans.add(data);
                                  statusDelete = true;
                                } else {
                                  listTrans.remove(data);
                                }
                                updateSelectAll(listTrans);
                              });
                            },
                          )
                      ],
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
