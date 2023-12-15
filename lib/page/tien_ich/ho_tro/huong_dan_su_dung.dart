import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/user_manual_services.dart';
import '../../../base/base_component.dart';
import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../network/services/transmanagement_service/download_file_service.dart';
import 'dart:developer' as dev;

class HuongDanSuDungScreen extends StatefulWidget {
  const HuongDanSuDungScreen({super.key});

  @override
  State<HuongDanSuDungScreen> createState() => _HuongDanSuDungScreenState();
}

class _HuongDanSuDungScreenState extends State<HuongDanSuDungScreen>
    with BaseComponent {
  List<UserManualModel> listUserManual = [];
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> getListUserManaul() async {
    try {
      BaseResponseDataList response =
          await UserManualServices().getListUserManualServices();
      if (response.errorCode == FwError.THANHCONG.value) {
        listUserManual = response.data!
            .map((userManual) => UserManualModel.fromJson(userManual))
            .toList();
      } else if (mounted) {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  _initData() async {
    await getListUserManaul();
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translation(context)!.instructionKey),
          centerTitle: true,
          toolbarHeight: 55,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: isLoading
            ? const LoadingCircle()
            : (listUserManual.isNotEmpty)
                ? renderBodyHuongDanSuDung(context)
                : const Center(
                    child: Text(
                      "Không có dữ liệu",
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    ),
                  ));
  }

  renderBodyHuongDanSuDung(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          for (UserManualModel items in listUserManual)
            renderContent(
                context: context,
                title: items.filename?.split('.').first,
                filename: items.filename,
                colors: Colors.white,
                code: items.id)
        ],
      ),
    );
  }

  renderContent({context, colors, filename, title, code}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: InkWell(
        onTap: () async {
          await saveFileFromAPI(context,
              fileName: title,
              requestBody: {},
              url: '/api/auth/download-hdsd?id=$code');
        },
        child: CardLayoutWidget(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.download)
          ],
        )),
      ),
    );
  }
}
