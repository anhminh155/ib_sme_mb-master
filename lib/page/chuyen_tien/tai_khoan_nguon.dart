import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/form/input_show_bottom_sheet.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

import '../../model/JsonSerializable_model/ddAcount/TddAccount_model.dart';
import '../../network/services/transaction_service.dart';

class SendAcctnoWidget extends StatefulWidget {
  final TextEditingController accountController;
  final String value;
  const SendAcctnoWidget(
      {super.key, required this.accountController, required this.value});
  @override
  State<SendAcctnoWidget> createState() => _SendAcctnoWidgetState();
}

class _SendAcctnoWidgetState extends State<SendAcctnoWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllDDAcount();
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.accountController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<SourceAcctnoProvider>(
        builder: (context, sourceAcctnoProvider, chils) {
      var items = sourceAcctnoProvider.items;
      return Column(
        children: [
          FormControlWidget(
            label: "Tài khoản nguồn",
            child: InputShowBottomSheet(
              controller: widget.accountController,
              hintText: "Chọn tài khoản nguồn",
              bodyWidget: (items.isNotEmpty)
                  ? renderBody(items)
                  : Container(
                      alignment: Alignment.center,
                      child: const Text("No data"),
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: const Text(
                  "Số dư khả dụng",
                  style: TextStyle(color: colorBlack_727374),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: renderBalance(items))
            ],
          ),
        ],
      );
    });
  }

  Future<void> _getAllDDAcount() async {
    List<TDDAcount> accounts;
    BaseResponseDataList response =
        await Transaction_Service().getAllDDAcount();
    if (response.errorCode == FwError.THANHCONG.value) {
      accounts = response.data!
          .map<TDDAcount>((json) => TDDAcount.fromJson(json))
          .toList();
      // setState(() {
      if (accounts.isNotEmpty) {
        widget.accountController.text = accounts[0].acctno ?? '';
      }
      // });
      // ignore: use_build_context_synchronously
      if (mounted) {
        await Provider.of<SourceAcctnoProvider>(context, listen: false)
            .set(accounts);
      }
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  renderBalance(List<TDDAcount> items) {
    if (items.isNotEmpty) {
      return Text(
        Currency.formatCurrency(
            double.tryParse(items[currentIndex].balance ?? '0') ?? 0),
        style: const TextStyle(color: primaryColor),
        textAlign: TextAlign.right,
      );
    }
  }

  renderBody(items) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = items[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              widget.accountController.text = item.acctno ?? '';
              currentIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: coloreWhite_EAEBEC))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.acctno ?? '',
                  style: TextStyle(
                    color: (widget.value.compareTo(item.acctno ?? '') == 0)
                        ? primaryColor
                        : primaryBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                (widget.value == item.acctno)
                    ? const Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: primaryColor,
                        size: 24,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
