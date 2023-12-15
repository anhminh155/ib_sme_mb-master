import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';

import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../network/services/trans_limit_cust.dart';

// ignore: must_be_immutable
class ViewDateHanMuc extends StatefulWidget {
  final int position;
  final int id;
  const ViewDateHanMuc({super.key, required this.position, required this.id});

  @override
  State<ViewDateHanMuc> createState() => _ViewDateHanMucState();
}

class _ViewDateHanMucState extends State<ViewDateHanMuc>
    with BaseComponent<TransLimitCust> {
  final convert = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    super.initState();
    getTrainLimitByCust();
  }

  getTrainLimitByCust() async {
    Cust cust = Cust(id: widget.id
        // widget.position == 3 ? widget.idDL : widget.idLL
        );
    BaseResponseDataList response =
        await TransLimitByCustService().getTransLimitByCust(cust);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listResponse = response.data!
            .map((translimitcust) => TransLimitCust.fromJson(translimitcust))
            .toList();
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? const LoadingCircle()
          : listResponse.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(139, 146, 165, 0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (TransLimitCust item in listResponse)
                            Column(
                              children: [
                                if (listResponse.indexOf(item) < 5)
                                  renderViewData(
                                      title: item.productName,
                                      valueHanMucGiaoDich: item.maxtrans,
                                      valueHanMucNgay: item.maxdaily,
                                      index: listResponse.indexOf(item)),
                                if (listResponse.indexOf(item) < 4 &&
                                    listResponse.indexOf(item) > 0)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Divider(
                                      height: 1.0,
                                      thickness: 1,
                                    ),
                                  )
                              ],
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(139, 146, 165, 0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (TransLimitCust item in listResponse)
                            Column(
                              children: [
                                if (listResponse.indexOf(item) >= 5)
                                  renderViewData(
                                      title: item.productName,
                                      valueHanMucGiaoDich: item.maxtrans,
                                      valueHanMucNgay: item.maxdaily,
                                      index: listResponse.indexOf(item)),
                                if (listResponse.indexOf(item) > 5 &&
                                    listResponse.indexOf(item) <
                                        listResponse.length - 1)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Divider(
                                      height: 1.0,
                                      thickness: 1,
                                    ),
                                  )
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    "Mã truy cập này chưa thiết lập hạn mức",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: colorBlack_727374.withOpacity(0.6)),
                  ),
                ),
    );
  }

  renderViewData({title, valueHanMucGiaoDich, valueHanMucNgay, index}) {
    return Container(
      decoration: (index == 0 || index == 5)
          ? BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
              color: colorBlue_80ACD5.withOpacity(0.3),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 8.0, bottom: (widget.position == 3 ? 8.0 : 0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hạn mức tối đa/giao dịch:'),
                Text(
                  valueHanMucGiaoDich != null
                      ? "${convert.format(valueHanMucGiaoDich)} VND"
                      : "_",
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
          if (widget.position == 2)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tổng hạn mức giao dịch/ngày:'),
                  Text(
                    valueHanMucNgay != null
                        ? "${convert.format(valueHanMucNgay)} VND"
                        : "_",
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
