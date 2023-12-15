// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

import '../truy_van_tai_khoan/truy_van_tai_khoan.dart';

class AccountBalanceWidget extends StatefulWidget {
  Cust? cust;
  // final List<TDDAcount> ddAccounts;
  // const AccountBalanceWidget({super.key, required this.ddAccounts});

  AccountBalanceWidget({super.key, this.cust});
  @override
  State<AccountBalanceWidget> createState() => _AccountBalanceWidgetState();
}

class _AccountBalanceWidgetState extends State<AccountBalanceWidget> {
  bool showBalance = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          stops: [0.1, 0.9],
          colors: [Color(0xFFF3CC45), Color(0xFFFDA601)],
        ),
      ),
      child: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: IgnorePointer(
              ignoring: true,
              child:
                  SvgPicture.asset("assets/images/account_balance_stack.svg")),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translation(context)!.total_balanceKey} VND",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorBlack_363E46,
                    ),
                  ),
                  if (widget.cust!.rolesearch != null &&
                      widget.cust?.rolesearch == 1)
                    (width <= 290)
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TruyVanTaiKhoan()));
                            },
                            child: Text(
                              translation(context)!.detailKey,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: primaryBlackColor,
                              ),
                            ),
                          ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                translation(context)!.payment_accountKey,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colorBlack_727374,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<TddAccountProvider>(
                      builder: (context, tddAccountProvider, child) {
                    return Text(
                      showBalance
                          ? Currency.formatCurrency(double.parse(
                              tddAccountProvider.sumPayment.toString()))
                          : "*** *** *** ***",
                    );
                  }),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showBalance = !showBalance;
                      });
                    },
                    splashRadius: 1,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: showBalance
                        ? const Icon(
                            Icons.visibility,
                            color: Colors.black45,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Colors.black45,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
