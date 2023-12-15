// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import '../../../../../utils/theme.dart';
import '../../enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';

class BottomSheetTypeTrans extends StatefulWidget {
  final String? value;
  final Function? handleSelectAccessCode;
  const BottomSheetTypeTrans({
    Key? key,
    this.value,
    this.handleSelectAccessCode,
  }) : super(key: key);

  @override
  State<BottomSheetTypeTrans> createState() => _BottomSheetTypeTransState();
}

class _BottomSheetTypeTransState extends State<BottomSheetTypeTrans>
    with BaseComponent<Cust> {
  // final List<String> loaiGiaoDich = [
  //   'Tất cả',
  //   TransType.getName(TransType.CORE),
  //   TransType.getName(TransType.CITAD),
  //   TransType.getName(TransType.NAPAS),
  // ];

  final List<TransType> loaiGiaoDich = [
    TransType.ALL,
    TransType.CORE,
    TransType.CITAD,
    TransType.NAPAS
  ];
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
        for (TransType item in loaiGiaoDich)
          InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.handleSelectAccessCode!(
                    TransType.getName(item), item.value, item);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: (loaiGiaoDich.indexOf(item) !=
                        loaiGiaoDich.length - 1)
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
                      TransType.getName(item),
                      style: TextStyle(
                        fontSize: 16,
                        color: (widget.value == TransType.getName(item))
                            ? primaryColor
                            : primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (widget.value == TransType.getName(item))
                        ? const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: primaryColor,
                            size: 24,
                          )
                        : const SizedBox(),
                  ],
                ),
              )),
      ],
    );
  }
}
