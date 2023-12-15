// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/common/show_bottomSheet/bottom_sheet_code.dart';
import 'package:ib_sme_mb_view/model/roles_acc_model.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_han_muc/cap_nhat_han_muc.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_han_muc/danh_sach_han_muc.dart';
import 'package:ib_sme_mb_view/utils/checkRolesAcc.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
import '../../../common/form/input_show_bottom_sheet.dart';
import '../../../provider/providers.dart';

class CaiDatHanMucScreen extends StatefulWidget {
  const CaiDatHanMucScreen({super.key});

  @override
  _CaiDatHanMucScreenState createState() => _CaiDatHanMucScreenState();
}

class _CaiDatHanMucScreenState extends State<CaiDatHanMucScreen>
    with SingleTickerProviderStateMixin, BaseComponent<TransLimitCust> {
  late TabController _tabController;
  late TextEditingController controllerHanMucLapLenh;
  late TextEditingController controllerHanMucDuyetLenh;
  late int idLL = 0;
  late int idDL = 0;
  int companyType = 0;

  @override
  void initState() {
    RolesAcc rolesAcc =
        Provider.of<CustInfoProvider>(context, listen: false).item!.roles!;
    companyType = checkCompanyType(rolesAcc);
    _tabController =
        TabController(length: (companyType == 2) ? 2 : 1, vsync: this);
    super.initState();
    controllerHanMucLapLenh = TextEditingController();
    controllerHanMucDuyetLenh = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    controllerHanMucDuyetLenh.dispose();
    controllerHanMucLapLenh.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        centerTitle: true,
        title: const Text("Cài đặt hạn mức"),
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Column(
        children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            margin: const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
            height: 45,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(
                5.0,
              ),
            ),
            child: TabBar(
              labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
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
                  child: Text(
                    "Hạn mức lập lệnh",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                if (companyType == 2)
                  const Tab(
                    child: Text(
                      "Hạn mức duyệt lệnh",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                renderBody(
                  label: "Mã lập lệnh",
                  controller: controllerHanMucLapLenh,
                  showPage: BottomSheetCode(
                    func: TypeCode.LIMITSETTING,
                    position: PositionEnum.LAPLENH.value,
                    value: controllerHanMucLapLenh.text,
                    handleSelectAccessCode: (String? valueCode, int valueId) {
                      setState(() {
                        controllerHanMucLapLenh.text = valueCode!;
                        idLL = valueId;
                      });
                    },
                  ),
                  ViewDateHanMuc(
                    key: UniqueKey(),
                    position: PositionEnum.LAPLENH.value,
                    id: idLL,
                  ),
                  handleClickUpdateButton: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CapNhatHanMucScreen(
                          title: "Cập nhật hạn mức lập lệnh",
                          id: idLL,
                          accessCode: controllerHanMucLapLenh.text.toString(),
                        ),
                      ),
                    );
                    if (result.toString().compareTo('Thành công') == 0) {
                      setState(() {
                        controllerHanMucLapLenh.text =
                            controllerHanMucLapLenh.text;
                        idLL = idLL;
                      });
                    }
                  },
                ),
                if (companyType == 2)
                  renderBody(
                    label: "Mã duyệt lệnh",
                    controller: controllerHanMucDuyetLenh,
                    showPage: BottomSheetCode(
                      func: TypeCode.LIMITSETTING,
                      position: PositionEnum.DUYETLENH.value,
                      value: controllerHanMucDuyetLenh.text,
                      handleSelectAccessCode: (String? valueCode, int valueId) {
                        setState(() {
                          controllerHanMucDuyetLenh.text = valueCode!;
                          idDL = valueId;
                        });
                      },
                    ),
                    ViewDateHanMuc(
                      key: UniqueKey(),
                      position: PositionEnum.DUYETLENH.value,
                      id: idDL,
                    ),
                    handleClickUpdateButton: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CapNhatHanMucScreen(
                            title: "Cập nhật hạn mức duyệt lệnh",
                            id: idDL,
                            accessCode:
                                controllerHanMucDuyetLenh.text.toString(),
                          ),
                        ),
                      );
                      if (result.toString().compareTo('Thành công') == 0) {
                        setState(() {
                          controllerHanMucDuyetLenh.text =
                              controllerHanMucDuyetLenh.text;
                          idDL = idDL;
                        });
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  renderBody(Widget dataTable,
      {required String label,
      required TextEditingController? controller,
      required Widget showPage,
      Function? handleClickUpdateButton}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16.0),
          child: CardLayoutWidget(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: FormControlWidget(
                    label: label,
                    child: InputShowBottomSheet(
                        controller: controller,
                        hintText: "Chọn user lập lệnh",
                        bodyWidget: showPage),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ButtonWidget(
                      height: 47,
                      backgroundColor: primaryColor,
                      onPressed: controller!.text != ''
                          ? () {
                              handleClickUpdateButton!();
                            }
                          : null,
                      text: "Cập nhật",
                      colorText: Colors.white,
                      haveBorder: false,
                      widthButton: 100.0),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                "Lưu ý: ",
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                " Đơn vị tiền tệ : Việt Nam đồng - VND",
                style:
                    TextStyle(color: primaryColor, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        if (controller.text != '') dataTable,
      ],
    );
  }
}
