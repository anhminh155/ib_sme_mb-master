import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import '../../../model/models.dart';
import '../network/services/transaction_service.dart';
import '../utils/theme.dart';
import 'form/form_control.dart';
import 'form/input_show_bottom_sheet.dart';

class SourceAccount extends StatefulWidget {
  final Function function;
  final String value;
  final bool selectAll;
  const SourceAccount(
      {super.key,
      required this.function,
      required this.value,
      required this.selectAll});

  @override
  State<SourceAccount> createState() => _SourceAccountState();
}

class _SourceAccountState extends State<SourceAccount> {
  List<TDDAcount> accounts = [];
  final accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectAll) {
      accountController.text = 'Tất cả';
    }
    _getAllDDAcount();
  }

  @override
  void dispose() {
    super.dispose();
    accountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return FormControlWidget(
        label: "Tài khoản nguồn",
        child: InputShowBottomSheet(
          controller: accountController,
          hintText: "Chọn tài khoản nguồn",
          bodyWidget: (accounts.isNotEmpty)
              ? renderBody()
              : Container(
                  alignment: Alignment.center,
                  child: const Text("No data"),
                ),
        ),
      );
    });
  }

  Future<void> _getAllDDAcount() async {
    BaseResponseDataList response =
        await Transaction_Service().getAllDDAcount();
    if (response.errorCode == FwError.THANHCONG.value) {
      if (response.data!.isNotEmpty) {
        accounts = response.data!
            .map<TDDAcount>((json) => TDDAcount.fromJson(json))
            .toList();
        if (widget.selectAll == false) {
          widget.function(accounts[0]);
          if (mounted) {
            setState(() {
              accountController.text = accounts[0].acctno!;
            });
          }
        }
        if (widget.selectAll == true) {
          TDDAcount ddAcount = TDDAcount(acctno: 'Tất cả');
          accounts.insert(0, ddAcount);
          widget.function(accounts[0]);
          if (mounted) {
            setState(() {
              accountController.text = accounts[0].acctno!;
            });
          }
        }
      }
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  renderBody() {
    return ListView.builder(
      itemCount: accounts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = accounts[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).pop();
            setState(() => accountController.text = item.acctno ?? '');
            widget.function(item);
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
