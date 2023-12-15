import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../../model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/tim_kiem_bang_ke_cho_duyet.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_cho_duyet/tim_kiem_giao_dich_cho_duyet.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

import '../../provider/providers.dart';

class CacLenhChoDuyetWidget extends StatefulWidget {
  final RolesAcc rolesAcc;
  const CacLenhChoDuyetWidget({super.key, required this.rolesAcc});

  @override
  State<CacLenhChoDuyetWidget> createState() => _CacLenhChoDuyetWidgetState();
}

class _CacLenhChoDuyetWidgetState extends State<CacLenhChoDuyetWidget> {
  @override
  Widget build(BuildContext context) {
    return renderContent();
  }

  renderContent() {
    return Consumer<CountTransProvider>(
        builder: (context, countTransProvider, child) {
      CountTrans? countTrans = countTransProvider.item;
      return ExpandableNotifier(
        child: ScrollOnExpand(
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(139, 146, 165, 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            translation(context)!.order_awaiting_approvalKey,
                            style: const TextStyle(
                                fontSize: 18, color: colorBlack_15334A),
                          ),
                        ),
                        if (countTrans != null &&
                            countTrans.pending! + countTrans.lotPending! != 0)
                          SizedBox(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.5, vertical: 3.0),
                                child: Text(
                                  '${countTrans.pending! + countTrans.lotPending!}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  collapsed: Container(),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                          color: Colors.black45, thickness: 0.5, height: 3),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            renderBtn(
                                icon: Icons.done_all,
                                title: translation(context)!
                                    .pending_approval_transationsKey,
                                countTrans:
                                    countTrans != null ? countTrans.pending : 0,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuanLyGiaoDichChoDuyet(
                                                rolesAcc: widget.rolesAcc,
                                              )));
                                }),
                            const Divider(
                                color: Colors.black,
                                thickness: 0.1,
                                height: 0.5),
                            renderBtn(
                                icon: Icons.plagiarism,
                                title: translation(context)!
                                    .bulk_transfer_pending_approvalKey,
                                countTrans: countTrans != null
                                    ? countTrans.lotPending
                                    : 0,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const GiaoDichBangKeChoDuyet()));
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  renderBtn({String? title, dynamic onTap, int? countTrans, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 70,
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colorBlue_D9E6F2,
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: primaryColor,
                    ),
                  ),
                  if (countTrans != null && countTrans != 0)
                    Positioned(
                      top: 0,
                      right: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Text(
                            '$countTrans',
                            style: const TextStyle(
                                fontSize: 8, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: colorBlack_20262C,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
