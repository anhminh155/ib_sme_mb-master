import 'package:flutter/material.dart';

// import 'package:expandable/expandable.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
// import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/network/services/terms_of_use.dart';

import '../../../base/base_component.dart';
import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../network/services/transmanagement_service/download_file_service.dart';

class DieuKhoanDichVuScreen extends StatefulWidget {
  final int? id;
  const DieuKhoanDichVuScreen({super.key, this.id});

  @override
  State<DieuKhoanDichVuScreen> createState() => _DieuKhoanDichVuScreenState();
}

class _DieuKhoanDichVuScreenState extends State<DieuKhoanDichVuScreen>
    with BaseComponent<TermsOfUse> {
  late Future futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = getTermsOfUse();
  }

  getTermsOfUse() async {
    BaseResponseDataList response = await TermOfUseService().getTermsOfUse();
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listResponse = response.data!
            .map((termsOfUse) => TermsOfUse.formJson(termsOfUse))
            .toList();
      });
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
        title: Text(translation(context)!.terms_of_serviceKey),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: isLoading
          ? const LoadingCircle()
          : renderBodyDieuKhoanDichVu(context),
    );
  }

  renderBodyDieuKhoanDichVu(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          for (var items in listResponse)
            renderContent(
                context: context,
                title: items.name,
                content: items.content,
                colors: Colors.white,
                code: items.id)
        ],
      ),
    );
  }

  renderContent({context, colors, content, title, code}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: InkWell(
        onTap: () async {
          await saveFileFromAPI(context,
              fileName: "DKDV",
              requestBody: {},
              url: '/api/auth/dieu-khoan?id=$code');
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
