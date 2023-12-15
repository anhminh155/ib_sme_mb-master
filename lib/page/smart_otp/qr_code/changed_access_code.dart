// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/model/models.dart';
import '../../../utils/theme.dart';
import '../../../network/services/sharedPreferences_service.dart';

class ChangedAccessCode extends StatefulWidget {
  final Function? handelSellected;
  final String? value;
  const ChangedAccessCode({super.key, this.value, this.handelSellected});

  @override
  State<ChangedAccessCode> createState() => _ChangedAccessCodeState();
}

class _ChangedAccessCodeState extends State<ChangedAccessCode> {
  List<InitUserOTPModel> userList = [];
  @override
  void initState() {
    _getInitUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showChangedAccessCode();
  }

  _getInitUser() async {
    var data = sharedpf.getListUserOTP();
    setState(() {
      userList = data;
    });
  }

  showChangedAccessCode() {
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
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              "Lựa chọn mã truy cập",
              style: TextStyle(
                  color: colorBlack_727374,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250,
                minHeight: 150,
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (InitUserOTPModel items in userList)
                      InkWell(
                        onTap: () async {
                          if (widget.handelSellected != null) {
                            widget.handelSellected!(items.username);
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: coloreWhite_EAEBEC,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                items.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: (widget.value == items.username)
                                      ? primaryColor
                                      : primaryBlackColor,
                                ),
                              ),
                              (widget.value == items)
                                  ? const Icon(
                                      Icons.check_circle_sharp,
                                      color: primaryColor,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
