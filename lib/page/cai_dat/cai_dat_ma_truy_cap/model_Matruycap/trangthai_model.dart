import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/theme.dart';

class StatusAccessCodeBottom extends StatefulWidget {
  final String? value;
  final Function? handleStatusAccessCode;
  const StatusAccessCodeBottom({
    super.key,
    this.value,
    this.handleStatusAccessCode,
  });

  @override
  State<StatusAccessCodeBottom> createState() => _StatusAccessCodeBottomState();
}

class _StatusAccessCodeBottomState extends State<StatusAccessCodeBottom> {
  List<String> list = ["Hoạt động", "Khóa", "Hủy", "Chờ kích hoạt"];
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
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Wrap(
        children: [
          Container(
            height: 3.5,
            width: 30,
            margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: (MediaQuery.of(context).size.width * 0.45)),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              "Trạng thái mã truy cập",
              style: TextStyle(color: colorBlack_727374),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  for (var item in list)
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.handleStatusAccessCode!(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: coloreWhite_EAEBEC))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: (widget.value == item)
                                      ? primaryColor
                                      : primaryBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              (widget.value == item)
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      color: primaryColor,
                                      size: 24,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
