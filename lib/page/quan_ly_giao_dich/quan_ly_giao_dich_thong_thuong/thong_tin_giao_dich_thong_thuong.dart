import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/getcolor_status.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../network/services/transmanagement_service/download_file_service.dart';
import '../../../network/services/transmanagement_service/get_trans_schedule_detail.dart';
import '../../../utils/theme.dart';

class ThongTinGiaoDich extends StatefulWidget {
  final String code;
  const ThongTinGiaoDich({super.key, required this.code});

  @override
  State<ThongTinGiaoDich> createState() => _ThongTinGiaoDichState();
}

class _ThongTinGiaoDichState extends State<ThongTinGiaoDich>
    with BaseComponent {
  Tran trans = Tran();
  String? rolesCompany;
  final convert = NumberFormat("#,### VND", "en_US");

  @override
  void initState() {
    getTransRegularByCode();
    rolesCompany =
        Provider.of<CustInfoProvider>(context, listen: false).item?.roles?.type;
    super.initState();
  }

  getTransRegularByCode() async {
    BaseResponse response = await GetTransactionScheduleService()
        .getTransDetail('/api/tran/${widget.code}', null);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        isLoading = !isLoading;
        dataResponse = Tran.fromJson(response.data);
        trans = dataResponse;
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
        title: const Text('Chi tiết giao dịch'),
        backgroundColor: primaryColor,
      ),
      body: (!isLoading)
          ? SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  renderBody(
                    contentZone1(),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  renderBody(
                    contentZone2(rolesCompany, convert),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                      mainAxisAlignment: (trans.status!.compareTo(
                                  StatusTrans.THANHCONG.value.toString()) ==
                              0)
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        if (trans.status!.compareTo(
                                StatusTrans.THANHCONG.value.toString()) ==
                            0)
                          ButtonWidget(
                              backgroundColor: Colors.white,
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext contextBottom) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                            color: Colors.white,
                                          ),
                                          child: Wrap(
                                            children: [
                                              Container(
                                                height: 3.5,
                                                width: 30,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45)),
                                                decoration: const BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.1,
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.45,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await saveFileFromAPI(
                                                            context,
                                                            url:
                                                                '/api/tran/chung-tu',
                                                            fileName:
                                                                'Phieu_hoach_toan_${trans.code}.pdf',
                                                            requestBody:
                                                                trans.code);
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.pop(
                                                            contextBottom);
                                                      },
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 18),
                                                          decoration: const BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          coloreWhite_EAEBEC))),
                                                          child: const Text(
                                                              "Phiếu hoạch toán")),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        // handleStatusAccessCode!(item);
                                                      },
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 18),
                                                          decoration: const BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          coloreWhite_EAEBEC))),
                                                          child: const Text(
                                                              "Ủy nhiệm chi")),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              text: 'Tải chứng từ',
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
                ],
              ),
            )
          : const Center(
              child: LoadingCircle(),
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
        renderLineInfo(label: "Tài khoản nguồn", value: trans.sendAccount),
        renderLineInfo(
            label: "Loại giao dịch",
            value: TransType.getNameByStringKey(trans.type!)),
        renderLineInfo(
            label: "Trạng thái giao dịch",
            value: StatusTrans.getStringByValue(trans.status),
            line: false),
      ],
    );
  }

  contentZone2(String? rolesCompany, convert) {
    return Column(
      children: [
        renderLineInfo(
            label: "Tài khoản thụ hưởng", value: trans.receiveAccount),
        renderLineInfo(label: "Tên người thụ hưởng", value: trans.receiveName),
        renderLineInfo(label: "Ngân hàng thụ hưởng", value: trans.receiveBank),
        renderLineInfo(
            label: "Số tiền giao dịch",
            value: convert.format(int.tryParse(trans.amount.toString()))),
        if (trans.status != '5')
          renderLineInfo(
              label: "Số tiền phí",
              value: convert.format(
                  int.parse(trans.fee ?? '0') + int.parse(trans.vat ?? '0'))),
        renderLineInfo(
            label: "Phí giao dịch",
            value: TransactionFeeType.getNameFeeType(trans.feeType)),
        renderLineInfo(label: "User lập lệnh", value: trans.username),
        renderLineInfo(
            label: "Thời gian lập",
            value: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(
                trans.createdAt!.substring(0, trans.createdAt!.length - 6)))),
        if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
          renderLineInfo(
              label: "User duyệt lệnh",
              value: trans.approvedBy?.code ?? '_ _ _ _ _'),
        if (rolesCompany == CompanyTypeEnum.MOHINHCAP2.value)
          renderLineInfo(
              label: "Thời gian duyệt",
              value: trans.approvedDate != null
                  ? DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(
                      trans.approvedDate!
                          .substring(0, trans.approvedDate!.length - 6)))
                  : '_ _ _ _ _'),
        renderLineInfo(label: "Nội dung giao dịch", value: trans.content),
        renderLineInfo(
            label: "Mã giao dịch",
            value: trans.code,
            line: trans.status == '5' ||
                    trans.status == '1' ||
                    trans.status == '3'
                ? true
                : false),
        if (trans.status == '5')
          renderLineInfo(label: "Mô tả lỗi", value: trans.reason, line: false),
        if (trans.status == '3')
          renderLineInfo(label: "Lý do hủy", value: trans.reason, line: false),
        if (trans.status == '1')
          renderLineInfo(
              label: "Lý do từ chối", value: trans.reason, line: false),
      ],
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
            SizedBox(
              width: 135,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                value ?? '_ _ _ _ _',
                style: TextStyle(color: getColorByValue(value ?? '')),
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
