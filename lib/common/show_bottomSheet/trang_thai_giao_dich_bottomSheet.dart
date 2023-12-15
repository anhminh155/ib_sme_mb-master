// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/theme.dart';
import '../../enum/enum.dart';

class BottomSheetStatusTrans extends StatefulWidget {
  final String? value;
  final List? listRegularTransactionStatus;
  final List? listScheduleTransactionStatus;
  final List? listApproveTranslot;
  final Function? handleSelectAccessCode;
  const BottomSheetStatusTrans(
      {Key? key,
      this.value,
      this.handleSelectAccessCode,
      this.listScheduleTransactionStatus,
      this.listApproveTranslot,
      this.listRegularTransactionStatus})
      : super(key: key);

  @override
  State<BottomSheetStatusTrans> createState() => _BottomSheetStatusTransState();
}

class _BottomSheetStatusTransState extends State<BottomSheetStatusTrans> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSheet();
  }

  buildSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.listRegularTransactionStatus != null)
          for (StatusTrans item in widget.listRegularTransactionStatus!)
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.handleSelectAccessCode!(
                    StatusTrans.getStringByKey(item), item.value);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: (widget.listRegularTransactionStatus!
                            .indexOf(item) !=
                        widget.listRegularTransactionStatus!.length - 1)
                    ? const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: coloreWhite_EAEBEC),
                        ),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StatusTrans.getStringByKey(item),
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (widget.value == StatusTrans.getStringByKey(item))
                                ? primaryColor
                                : primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (widget.value == StatusTrans.getStringByKey(item))
                        ? const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: primaryColor,
                            size: 24,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
        if (widget.listScheduleTransactionStatus != null)
          for (StatusPaymentTrans item in widget.listScheduleTransactionStatus!)
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.handleSelectAccessCode!(
                    StatusPaymentTrans.getStringByKey(item), item.value);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: (widget.listScheduleTransactionStatus!
                            .indexOf(item) !=
                        widget.listScheduleTransactionStatus!.length - 1)
                    ? const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: coloreWhite_EAEBEC),
                        ),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StatusPaymentTrans.getStringByKey(item),
                      style: TextStyle(
                        fontSize: 16,
                        color: (widget.value ==
                                StatusPaymentTrans.getStringByKey(item))
                            ? primaryColor
                            : primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (widget.value == StatusPaymentTrans.getStringByKey(item))
                        ? const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: primaryColor,
                            size: 24,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
        if (widget.listApproveTranslot != null)
          for (StatusApprovetranslot item in widget.listApproveTranslot!)
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.handleSelectAccessCode!(
                    StatusApprovetranslot.getStringByKey(item), item.value);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: (widget.listApproveTranslot!.indexOf(item) !=
                        widget.listApproveTranslot!.length - 1)
                    ? const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: coloreWhite_EAEBEC),
                        ),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StatusApprovetranslot.getStringByKey(item),
                      style: TextStyle(
                        fontSize: 16,
                        color: (widget.value ==
                                StatusApprovetranslot.getStringByKey(item))
                            ? primaryColor
                            : primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (widget.value == StatusApprovetranslot.getStringByKey(item))
                        ? const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: primaryColor,
                            size: 24,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
