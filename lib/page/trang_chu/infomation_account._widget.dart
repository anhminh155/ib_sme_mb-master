import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import '../../enum/enum.dart';
import '../../model/model.dart';
import '../../provider/custInfo_provider.dart';

class InfomationAccount extends StatefulWidget {
  const InfomationAccount({super.key});

  @override
  State<InfomationAccount> createState() => _InfomationAccountState();
}

class _InfomationAccountState extends State<InfomationAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          toolbarHeight: 55,
          title: const Text("Thông tin truy cập"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: renderBody(context),
          ),
        ));
  }

  renderBody(context) {
    return Consumer<CustInfoProvider>(
        builder: (context, custInfoProvider, child) {
      Cust? custInfo = custInfoProvider.cust;
      String originalDateString = custInfo!.birthday.toString();
      DateTime originalDate = DateTime.parse(originalDateString);
      String formattedDate = DateFormat('dd/MM/yyyy').format(originalDate);
      return Column(
        children: [
          SizedBox(
            height: 550,
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(width: 2, color: secondaryColor),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 48.0,
                        ),
                        renderLineInfo(
                            label: "Mã truy cập", value: custInfo.code),
                        renderLineInfo(
                            label: "Vai trò",
                            value: PositionEnum.getName(
                                custInfo.position!, context)),
                        renderLineInfo(
                            label: "Tên gợi nhớ",
                            value: custInfo.nmemonicName ?? ''),
                        renderLineInfo(
                            label: "Họ và tên", value: custInfo.fullname ?? ''),
                        renderLineInfo(
                            label: "Ngày sinh", value: formattedDate),
                        renderLineInfo(
                            label: "Loại giấy tờ",
                            value: custInfo.indentitypapers ?? ''),
                        renderLineInfo(
                            label: "Số giấy tờ", value: custInfo.idno ?? ''),
                        renderLineInfo(
                            label: "Số điện thoại", value: custInfo.tel ?? ''),
                        renderLineInfo(
                            label: "Email", value: custInfo.email ?? ''),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      onTap: () {
                        // toast("Thay đổi ảnh đại diện");
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 5, color: coloreWhite_EAEBEC),
                                borderRadius: BorderRadius.circular(35)),
                            child:
                                SvgPicture.asset("assets/images/avt-user.svg"),
                          ),
                          const Positioned(
                            top: 45,
                            left: 40,
                            right: 0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black38,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(width: 2, color: secondaryColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "THÔNG TIN DOANH NGHIỆP",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
                  child: Center(
                    child: Text(
                      custInfo.company!.fullname!.toUpperCase(),
                      style: const TextStyle(color: primaryColor),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: primaryColor.withOpacity(0.3),
                ),
                renderLineInfo(
                    label: "Địa chỉ:",
                    value: custInfo.company!.address,
                    line: false),
                renderLineInfo(
                    label: "Số CIF:",
                    value: custInfo.company!.cif,
                    line: false),
                renderLineInfo(
                    label: "Số ĐKKD:",
                    value: custInfo.company!.businessCode,
                    line: false)
              ],
            ),
          ),
        ],
      );
    });
  }

  renderLineInfo({label, value, bool line = true}) {
    return Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                value ?? '',
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        if (label.toString().compareTo("Email") != 0 && line == true)
          const Divider(
            thickness: 1,
          ),
      ],
    );
  }
}
