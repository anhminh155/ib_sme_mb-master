import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/download_file_service.dart';
import 'package:ib_sme_mb_view/network/services/transmanagement_service/manage_manifest_transactions.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:intl/intl.dart';
import '../../../utils/theme.dart';
import '../getcolor_status.dart';

class ThongTinGiaoDichBangKe extends StatefulWidget {
  final String transLotCode;
  const ThongTinGiaoDichBangKe({super.key, required this.transLotCode});

  @override
  State<ThongTinGiaoDichBangKe> createState() => _ThongTinGiaoDichBangKeState();
}

class _ThongTinGiaoDichBangKeState extends State<ThongTinGiaoDichBangKe>
    with SingleTickerProviderStateMixin, BaseComponent {
  late AnimationController _controller;
  bool _isRotated = false;
  int pages = 1;
  List listApproveEmelent = [];
  int totalApproveEmelent = 0;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    getAllAPI();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isRotated = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    setState(() {
      _isRotated = !_isRotated;
      if (_isRotated) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  getAllAPI() async {
    if (mounted) {
      final futures = <Future>[
        getApproveTransLotDetail(),
        getAllTransLotDetail(curentPage: pages),
      ];
      final result = await Future.wait<dynamic>(futures);
      if (result.isNotEmpty) {
        setState(() {
          isLoading = !isLoading;
        });
      }
    }
  }

  getApproveTransLotDetail() async {
    BaseResponse response = await ManageManifesTransactionsService()
        .getApproveTransLotDetail(widget.transLotCode);
    if (response.errorCode == FwError.THANHCONG.value) {
      dataResponse = StmTransferResponse.fromJson(response.data);
    } else if (response.errorCode != null && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getAllTransLotDetail({int? curentPage}) async {
    page.curentPage = curentPage!;
    page.size = 10;
    BasePagingResponse response = await ManageManifesTransactionsService()
        .getAllTransLotDetail(page, widget.transLotCode);
    if (response.errorCode == FwError.THANHCONG.value) {
      listResponse = response.data!.content!
          .map((transLot) => TransLotDetailDto.fromJson(transLot))
          .toList();
      setState(() {
        pages++;
        totalApproveEmelent = response.data!.totalElements!;
        listApproveEmelent.addAll(listResponse);
      });
    } else if (response.errorCode != null && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
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
        title: const Text('Chi tiết giao dịch bảng kê'),
        backgroundColor: primaryColor,
      ),
      body: (isLoading)
          ? const Center(
              child: LoadingCircle(),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        renderBody(
                          contentZone1(),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        renderBody(
                          contentZone2(),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        renderBody(
                          contentZone3(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              await saveFileFromAPI(context,
                                  url:
                                      '/api/translotdetail/exportTransLotDetail',
                                  fileName: 'bangke_${widget.transLotCode}',
                                  requestBody: {
                                    'transLot': widget.transLotCode
                                  });
                            },
                            text: 'Tải danh sách',
                            colorText: primaryColor,
                            haveBorder: true,
                            colorBorder: primaryColor,
                            widthButton:
                                MediaQuery.of(context).size.width * 0.4),
                        ButtonWidget(
                            backgroundColor: secondaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'Về danh sách',
                            colorText: Colors.white,
                            haveBorder: false,
                            widthButton:
                                MediaQuery.of(context).size.width * 0.4)
                      ]),
                ),
              ],
            ),
    );
  }

  renderBody(renderContent) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(width: 2, color: secondaryColor),
        ),
        child: renderContent);
  }

  contentZone1() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản nguồn", value: dataResponse.sendAccount),
        renderLineInfo(
            label: "Loại giao dịch", value: "Chuyển tiền theo bảng kê"),
        renderLineInfo(
            label: "Trạng thái giao dịch",
            value: StatusApprovetranslot.getStringByValue(dataResponse.status),
            line: false),
      ],
    );
  }

  contentZone2() {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài bảng kê", value: dataResponse.fileName ?? '_'),
        renderLineInfo(label: "Tổng số giao dịch", value: dataResponse.total),
        renderLineInfo(
            label: "Tổng số tiền",
            value:
                Currency.formatCurrency(int.parse(dataResponse.amount ?? '0'))),
        renderLineInfo(
            label: "Tổng số tiền phí",
            value: Currency.formatCurrency(int.parse(dataResponse.fee ?? '0') +
                int.parse(dataResponse.vat ?? '0'))),
        renderLineInfo(
            label: "Phí giao dịch",
            value: TransactionFeeType.getNameFeeType(dataResponse.feeType)),
        renderLineInfo(
            label: "User lập lệnh", value: dataResponse.createdByCust.code),
        renderLineInfo(
            label: "Thời gian lập",
            value: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(
                dataResponse.createdAt!
                    .substring(0, dataResponse.createdAt!.length - 6)))),
        renderLineInfo(
            label: "User duyệt lệnh", value: dataResponse.updatedByCust.code),
        renderLineInfo(
            label: "Thời gian duyệt",
            value: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(
                dataResponse.updatedAt!
                    .substring(0, dataResponse.updatedAt!.length - 6)))),
        renderLineInfo(
            label: "Nội dung giao dịch", value: dataResponse.content),
        renderLineInfo(
            label: "Mã giao dịch",
            value: dataResponse.transLotCode,
            line: false),
      ],
    );
  }

  contentZone3() {
    return Column(
      children: [
        InkWell(
          onTap: _toggleRotation,
          child: Row(
            children: [
              const Icon(
                Icons.format_list_bulleted,
                color: primaryColor,
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Expanded(
                child: Text(
                  "Danh sách giao dịch bảng kê",
                  style: TextStyle(color: primaryColor),
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _animation.value * 2.0 * 3.141592653589793,
                    child: child!,
                  );
                },
                child: const Icon(
                  Icons.arrow_drop_down_sharp,
                ),
              ),
            ],
          ),
        ),
        if (_isRotated == true)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500, minHeight: 200),
            child: renderListTrans(),
          )
      ],
    );
  }

  renderListTrans() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: listApproveEmelent.length,
            itemBuilder: (context, index) {
              var item = listApproveEmelent[index];
              Color color = getColorByValue(
                  ApproveTransLotElementEnum.getStringByValue(
                      item.paymentStatus ?? 0));
              String status = ApproveTransLotElementEnum.getStringByValue(
                  item.paymentStatus ?? '');
              String amount =
                  Currency.formatCurrency(int.parse(item.amount ?? '0'));
              String fee = Currency.formatCurrency(
                  int.parse(item.fee ?? '0') + int.parse(item.vat ?? '0'));
              return InkWell(
                  onTap: () {
                    renderDialogInfoApproveElement(
                        item: item,
                        amount: amount,
                        fee: fee,
                        status: status,
                        color: color);
                  },
                  child: renderApproveTransLotElementInfo(
                      item: item,
                      amount: amount,
                      fee: fee,
                      status: status,
                      color: color));
            },
          ),
          if (listApproveEmelent.length < totalApproveEmelent)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () async {
                    await getAllTransLotDetail(curentPage: pages);
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
    );
  }

  renderDialogInfoApproveElement(
      {dynamic item,
      String? amount,
      String? fee,
      String? status,
      Color? color}) {
    showDialog(
        context: context,
        builder: (contextDialog) => Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        status != ''
                            ? DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: color!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 4.0),
                                  child: Text(
                                    status!,
                                    style: TextStyle(color: color),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        IconButton(
                            splashRadius: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Navigator.pop(contextDialog);
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    renderLineInfo(
                        label: "Mã giao dịch", value: item.code ?? ''),
                    renderLineInfo(
                        label: "Số tài khoản",
                        value: item.receiveAccount ?? ''),
                    renderLineInfo(
                        label: "Tên người hưởng",
                        value: item.receiveName ?? ''),
                    renderLineInfo(
                        label: "Ngân hàng thụ hưởng",
                        value: item.receiveBank ?? ''),
                    renderLineInfo(label: 'Số tiền', value: amount),
                    renderLineInfo(label: "Số tiền phí", value: fee),
                    renderLineInfo(
                        label: "Nội dung",
                        value: item.content ?? '',
                        line: false),
                    const SizedBox(
                      height: 16.0,
                    ),
                    renderButtomListApproveElement(contextDialog)
                  ],
                ),
              ),
            ));
  }

  renderButtomListApproveElement(contextDialog) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonWidget(
            backgroundColor: primaryColor,
            onPressed: () {},
            text: "Tải phiếu hoạch toán",
            colorText: Colors.white,
            haveBorder: false,
            widthButton: MediaQuery.of(contextDialog).size.width * 0.4),
        ButtonWidget(
            backgroundColor: primaryColor,
            onPressed: () {},
            text: "Tải ủy nhiệm chi",
            colorText: Colors.white,
            haveBorder: false,
            widthButton: MediaQuery.of(contextDialog).size.width * 0.4)
      ],
    );
  }

  renderApproveTransLotElementInfo(
      {dynamic item,
      String? amount,
      String? fee,
      String? status,
      Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(item.receiveAccount), Text(amount!)],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status!,
                style: TextStyle(color: color),
              ),
              Text(
                fee!,
                style: const TextStyle(color: secondaryColor),
              ),
            ],
          ),
          if (listApproveEmelent.indexOf(item) != listApproveEmelent.length - 1)
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Divider(
                height: 1.0,
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  renderLineInfo({label, value, bool line = true}) {
    return Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: TextStyle(color: getColorByValue(value)),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        if (line == true)
          const Divider(
            thickness: 1,
          ),
      ],
    );
  }
}
