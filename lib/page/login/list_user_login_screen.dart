// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import '../../../utils/theme.dart';
import '../../../network/services/sharedPreferences_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListUserLoginScreen extends StatefulWidget {
  final Function handelSellected;
  final Function handelChangeAccount;
  final Function handelClose;
  final String? value;
  const ListUserLoginScreen(
      {super.key,
      this.value,
      required this.handelSellected,
      required this.handelChangeAccount,
      required this.handelClose});

  @override
  State<ListUserLoginScreen> createState() => _ListUserLoginScreenState();
}

class _ListUserLoginScreenState extends State<ListUserLoginScreen> {
  List<String> userList = [];
  int userListLengthMax = 1;
  bool isRemveLastLogin = false;
  @override
  void initState() {
    _getInitUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [renderBody(), renderCloseButton()],
    );
  }

  _getInitUsers() async {
    var data = sharedpf.getListUserLogin();
    var limitAccount = sharedpf.getLimitAccount();
    setState(() {
      userList = data;
      userListLengthMax = limitAccount;
    });
  }

  renderBody() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              translation(context)!.select_accountKey,
              style: const TextStyle(
                  color: colorBlack_727374,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .30,
              child: renderListUserName(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          renderChangeAccount(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  renderListUserName() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userList.length,
      itemBuilder: (context, index) {
        var item = userList[index];
        return Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            extentRatio: 0.15,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    userList.remove(item);
                    sharedpf.removeToListUserLogin(item);
                    sharedpf.deteleCustfromListByUserName(item);
                    if (item == sharedpf.getLastUserLogin()) {
                      sharedpf.removeLastLogin();
                      isRemveLastLogin = true;
                    }
                  });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
              ),
            ],
          ),
          child: InkWell(
            onTap: () async {
              widget.handelSellected(item);
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: (widget.value == item)
                          ? primaryColor
                          : primaryBlackColor,
                    ),
                  ),
                  (widget.value == item)
                      ? const Icon(
                          Icons.check_circle_sharp,
                          color: primaryColor,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  renderChangeAccount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: (userList.length < userListLengthMax)
              ? () {
                  Navigator.pop(context);
                  widget.handelChangeAccount();
                }
              : () {
                  showToast(
                      context: context,
                      msg: 'Tối đa $userListLengthMax tài khoản',
                      color: Colors.orange);
                },
          child: Text(
            "${translation(context)!.login_with_another_accountKey}?",
            style: const TextStyle(
                color: secondaryColor, decoration: TextDecoration.underline),
            textAlign: TextAlign.center,
          )),
    );
  }

  renderCloseButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (isRemveLastLogin) {
            widget.handelClose();
          }
        },
        child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: const Icon(Icons.close)),
      ),
    );
  }
}
