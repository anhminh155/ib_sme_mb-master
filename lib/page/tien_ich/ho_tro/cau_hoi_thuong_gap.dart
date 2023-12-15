import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/issue_services.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:ib_sme_mb_view/utils/theme.dart';

class CauHoiThuongGapScreen extends StatefulWidget {
  const CauHoiThuongGapScreen({super.key});

  @override
  State<CauHoiThuongGapScreen> createState() => _CauHoiThuongGapScreenState();
}

class _CauHoiThuongGapScreenState extends State<CauHoiThuongGapScreen>
    with BaseComponent {
  List<IssueModel> listIssue = [];
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> getListIssue(context) async {
    try {
      BaseResponseDataList response =
          await IssueServices().getListIssueServices();
      if (response.errorCode == FwError.THANHCONG.value) {
        listIssue = response.data!
            .map((issueModel) => IssueModel.fromJson(issueModel))
            .toList();
      } else {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  _initData() async {
    await getListIssue(context);
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context)!.frequently_asked_questionsKey),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: (isLoading)
          ? const LoadingCircle()
          : (listIssue.isNotEmpty)
              ? SingleChildScrollView(
                  child: renderBodyCauHoiThuongGap(),
                )
              : const Text(
                  "Không có dữ liệu",
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
    );
  }

  renderBodyCauHoiThuongGap() {
    return Column(
      children: [
        for (IssueModel issueModel in listIssue)
          renderContent(
              context: context,
              colors: colorBlue_D9E6F2.withOpacity(0.7),
              content: issueModel.answer,
              title: issueModel.question)
      ],
    );
  }

  renderContent({context, colors, content, title}) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ScrollOnExpand(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: false,
                  ),
                  header: Container(
                    color: colors,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.black,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  collapsed: Container(),
                  expanded: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      content,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(height: 1.5, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
