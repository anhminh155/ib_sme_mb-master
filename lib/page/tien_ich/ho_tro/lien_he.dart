import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/contact_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:open_mail_app/open_mail_app.dart';
import '../../../base/base_component.dart';
import '../../../common/loading_circle.dart';
import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with BaseComponent<ContactInfo> {
  late Future futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = getContactInfo();
  }

  // Sử dụng biến isLoading và setState đợi response api
  getContactInfo() async {
    BaseResponse<ContactInfo> response =
        await ContactInfoService().getContactInfo();
    if (response.errorCode == FwError.THANHCONG.value) {
      dataResponse = ContactInfo.fromJson(response.data);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        title: const Text("Liên hệ"),
        centerTitle: true,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: isLoading ? const LoadingCircle() : renderContactBody(context),
    );
  }

  renderContactBody(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo2.svg',
                    width: 90,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 15),
                    child: const Text(
                      "Ngân hàng Xây Dựng",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontSize: 10),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "CBway Biz",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30.0),
              child: const Text(
                "Là dịch vụ ngân hàng trực tuyến cho phép Khách hàng thực hiện các giao dịch ngân hàng trên các thiết bị có kết nối Internet",
                style: TextStyle(height: 1.4),
                textAlign: TextAlign.justify,
              ),
            ),
            renderInfo(
                icons: Icons.phone,
                titles: 'Hotline 24/7',
                contents: dataResponse!.hotline ?? '',
                onClicked: () async {
                  await FlutterPhoneDirectCaller.callNumber('1900545413');
                }),
            const Divider(
              color: primaryColor,
              thickness: 0.5,
            ),
            renderInfo(
                icons: Icons.location_on_sharp,
                titles: 'Trụ sở chính',
                contents: dataResponse!.address ?? '',
                onClicked: () {}),
            const Divider(
              color: primaryColor,
              thickness: 0.5,
            ),
            renderInfo(
                icons: Icons.email_outlined,
                titles: 'Email',
                contents: dataResponse!.email ?? '',
                onClicked: () async {
                  EmailContent email = EmailContent(
                    to: [
                      dataResponse!.email.toString(),
                    ],
                  );
                  OpenMailAppResult result =
                      await OpenMailApp.composeNewEmailInMailApp(
                          emailContent: email,
                          nativePickerTitle: 'Select email app to compose');
                  if (!result.didOpen && !result.canOpen) {
                    showNoMailAppsDialog(context);
                  } else if (!result.didOpen && result.canOpen) {
                    showDialog(
                        context: context,
                        builder: (_) => MailAppPickerDialog(
                              mailApps: result.options,
                              emailContent: email,
                            ));
                  }
                }),
            const Divider(
              color: primaryColor,
              thickness: 0.5,
            ),
            renderInfo(
                icons: Icons.phone_in_talk_rounded,
                titles: 'Số điện thoại',
                contents: dataResponse!.tel ?? '',
                onClicked: () async {
                  await FlutterPhoneDirectCaller.callNumber('03884352329');
                }),
            const Divider(
              color: primaryColor,
              thickness: 0.5,
            ),
            renderInfo(
                icons: Icons.fax_rounded,
                titles: "FAX",
                contents: dataResponse!.fax ?? '')
          ],
        ),
      ),
    );
  }

  renderInfo({icons, titles, contents, onClicked}) {
    return InkWell(
      onTap: onClicked,
      overlayColor: MaterialStateProperty.all(colorWhite),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 30),
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: primaryColor),
              child: Icon(
                icons,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles ?? ""),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    contents ?? "",
                    style: const TextStyle(color: primaryColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
