import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ib_sme_mb_view/common/badge_rounded_corner.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/page/trang_chu/infomation_account._widget.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  bool check = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<CustInfoProvider>(
      builder: (context, custInfoProvider, child) {
        var custInfo = custInfoProvider.cust;
        return Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InfomationAccount(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8),
                        child: SvgPicture.asset("assets/images/avt-user.svg"),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgPicture.asset("assets/images/diamond.svg"),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        custInfo?.fullname ?? "",
                        style: const TextStyle(
                          color: primaryBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: (width > 350) ? 12.0 : 6.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BadgeRoundedCornersWidget(
                            borderColor: colorGreen_56AB01,
                            child: Text(
                              PositionEnum.getName(
                                  custInfo?.position ?? 0, context),
                              style: const TextStyle(
                                  color: colorGreen_56AB01,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            custInfo?.code ?? "",
                            style: const TextStyle(
                              color: colorBlack_727374,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
