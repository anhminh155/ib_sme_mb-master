import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/network/services/cust_acc_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/truy_van_tai_khoan/danh_sach_tai_khoan.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../base/base_component.dart';
import '../../enum/enum.dart';
import '../../model/model.dart';
import '../../utils/theme.dart';

class TruyVanTaiKhoan extends StatefulWidget {
  const TruyVanTaiKhoan({super.key});

  @override
  State<TruyVanTaiKhoan> createState() => _TruyVanTaiKhoanState();
}

class _TruyVanTaiKhoanState extends State<TruyVanTaiKhoan> with BaseComponent {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  int sumMoney = 0;
  GlobalKey chartKey = GlobalKey();
  SumMoneyResponse sumMoneyResponse = const SumMoneyResponse();
  @override
  void initState() {
    _chartData = [];
    getInitData();
    super.initState();
  }

  getInitData() async {
    await getAllMoneys();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final GDPData chartData = _chartData[seriesIndex];
        final formattedY = convert(chartData.gdp);
        return Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Text(
            '${chartData.continent}: $formattedY',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  getAllMoneys() async {
    SumMoneyResponse response = await CustAccService().getAllMoneys();
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        sumMoneyResponse = response;
        sumMoney += response.sumSDD + response.sumSFD + response.sumSLN;
        if (sumMoney == 0) {
          _chartData = getChartData(sumMoneyResponse, 1);
        } else {
          _chartData = getChartData(sumMoneyResponse, sumMoney);
        }
        isLoading = !isLoading;
      });
    } else {
      setState(() {
        sumMoneyResponse = response;
        sumMoney += response.sumSDD + response.sumSFD + response.sumSLN;
        _chartData = getChartData(sumMoneyResponse, 1);

        isLoading = !isLoading;
      });
    }
  }

  List<GDPData> getChartData(SumMoneyResponse sumMoneyResponse, int sumMoney) {
    final List<GDPData> chartData = [
      GDPData(translation(context)!.payment_accountKey, sumMoneyResponse.sumSDD,
          "${(sumMoneyResponse.sumSDD / sumMoney * 100).toStringAsFixed(2)}%"),
      GDPData(translation(context)!.deposit_accountKey, sumMoneyResponse.sumSFD,
          "${(sumMoneyResponse.sumSFD / sumMoney * 100).toStringAsFixed(2)}%"),
      GDPData(translation(context)!.loan_accountKey, sumMoneyResponse.sumSLN,
          "${(sumMoneyResponse.sumSLN / sumMoney * 100).toStringAsFixed(2)}%"),
    ];
    return chartData;
  }

  convert(value) {
    String formattedNumber = NumberFormat('#,##0 VND').format(value);
    return formattedNumber;
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
        title: Text(translation(context)!.account_queryKey),
        backgroundColor: primaryColor,
      ),
      body: !isLoading ? renderBody() : const LoadingCircle(),
    );
  }

  renderBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          renderChart(),
          renderHeading(),
          const SizedBox(
            height: 16.0,
          ),
          for (GDPData item in _chartData)
            renderBoxLegend(
                label: item.continent,
                value: item.gdp,
                type: item.continent == translation(context)!.payment_accountKey
                    ? 0
                    : item.continent == translation(context)!.deposit_accountKey
                        ? 1
                        : 2),
        ],
      ),
    );
  }

  renderChart() {
    return SfCircularChart(
      key: chartKey,
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<GDPData, String>(
          dataSource: _chartData,
          xValueMapper: (GDPData data, _) => data.continent,
          yValueMapper: (GDPData data, _) => data.gdp,
          dataLabelMapper: (GDPData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            showZeroValue: false,
          ),
          enableTooltip: true,
          pointColorMapper: (GDPData data, _) {
            if (data.continent == translation(context)!.payment_accountKey) {
              return secondaryColor;
            } else if (data.continent ==
                translation(context)!.deposit_accountKey) {
              return primaryColor;
            } else {
              return colorGreen_56AB01;
            }
          },
        ),
      ],
    );
  }

  renderHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                translation(context)!.total_balanceKey,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            Text(
              convert(sumMoney),
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                translation(context)!.total_owed_balanceKey,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            Text(convert(sumMoneyResponse.sumSLN),
                style: TextStyle(
                    color: Colors.red.shade500,
                    fontSize: 18,
                    fontWeight: FontWeight.w600))
          ],
        )
      ],
    );
  }

  renderBoxLegend({label, value, type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DanhSachTaiKhoan(
                        label: label,
                        type: type,
                      )));
        },
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromRGBO(247, 148, 29, 0.09803921568627451),
            ),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  width: 5,
                  height: 45,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: label ==
                                  translation(context)!.payment_accountKey
                              ? secondaryColor
                              : label ==
                                      translation(context)!.deposit_accountKey
                                  ? primaryColor
                                  : colorGreen_56AB01)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        convert(value),
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.text);
  final String continent;
  final int gdp;
  final String text;
}
