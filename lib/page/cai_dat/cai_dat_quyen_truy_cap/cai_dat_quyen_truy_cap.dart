import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_quyen_truy_cap/cai_dat_quyen_truy_cap_chi_tiet.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/checkRolesAcc.dart';
import 'package:provider/provider.dart';
import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../network/services/cus_service.dart';
import '../../../utils/theme.dart';

class CaiDatQuyenTruyCapScreen extends StatefulWidget {
  const CaiDatQuyenTruyCapScreen({super.key});

  @override
  State<CaiDatQuyenTruyCapScreen> createState() =>
      _CaiDatQuyenTruyCapScreenState();
}

class _CaiDatQuyenTruyCapScreenState extends State<CaiDatQuyenTruyCapScreen>
    with SingleTickerProviderStateMixin, BaseComponent<Cust> {
  late TabController _tabController;
  List<Cust> listLL = [];
  List<Cust> listDL = [];
  int companyType = 0;

  Future<List<Cust>> searchPaging(int curentPage, int value) async {
    page.curentPage = curentPage;
    page.size = 100;
    Cust cust = Cust(position: value);
    BasePagingResponse<Cust> response =
        await CusService().searchPaging(page, cust, urls: '/api/cust/cust-acc');
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        listResponse =
            response.data!.content!.map((cust) => Cust.fromJson(cust)).toList();
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
    return listResponse;
  }

  @override
  void initState() {
    RolesAcc rolesAcc =
        Provider.of<CustInfoProvider>(context, listen: false).item!.roles!;
    companyType = checkCompanyType(rolesAcc);
    initializeList(companyType);
    _tabController = TabController(
        length: (companyType.toString() == CompanyTypeEnum.MOHINHCAP2.value)
            ? 2
            : 1,
        vsync: this);
    super.initState();
  }

  void initializeList(companyType) async {
    listLL = await searchPaging(1, PositionEnum.LAPLENH.value);
    if (companyType.toString() == CompanyTypeEnum.MOHINHCAP2.value) {
      listDL = await searchPaging(1, PositionEnum.DUYETLENH.value);
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        title: const Text("Quyền truy cập"),
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: !isLoading
          ? Column(
              children: [
                // give the tab bar a height [can change hheight to preferred height]
                Container(
                  margin:
                      const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                      color: (companyType == 2) ? secondaryColor : primaryColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      const Tab(
                        text: 'Mã lập lệnh',
                      ),
                      if (companyType == 2)
                        const Tab(
                          text: 'Mã duyệt lệnh',
                        ),
                    ],
                  ),
                ),
                // tab bar view here
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      tabBodyView(listLL),
                      if (companyType == 2) tabBodyView(listDL),
                    ],
                  ),
                ),
              ],
            )
          : const LoadingCircle(),
    );
  }

  Widget tabBodyView(List<Cust> listCust) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Wrap(
          runSpacing: 16,
          children: [
            for (Cust cust in listCust)
              custView(
                cust,
              ),
          ],
        ),
      ),
    );
  }

  Widget custView(Cust cust) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: const RouteSettings(name: '/page2'),
                builder: (context) => CaiDatQuyenTruyCapChiTietScreen(
                      custId: cust.id!,
                      companyType: companyType.toString(),
                    )));
      },
      child: CardLayoutWidget(
        child: Wrap(
          runSpacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mã truy cập",
                  // style: TextStyle(
                  //     color: primaryBlackColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  cust.code ?? "",
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       "Vai trò",
            //     ),
            //     Text(
            //         cust.position == PositionEnum.LAPLENH.value
            //             ? "Mã lập lệnh"
            //             : "Mã duyệt lệnh",
            //         style: const TextStyle(color: primaryBlackColor))
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Họ và tên",
                ),
                Text(cust.fullname ?? "",
                    style: const TextStyle(color: primaryBlackColor))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Số điện thoại",
                ),
                Text(cust.tel ?? "",
                    style: const TextStyle(color: primaryBlackColor))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
