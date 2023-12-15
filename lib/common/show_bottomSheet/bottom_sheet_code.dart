import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/network/services/trans_limit_cust.dart';
import '../../../../../utils/theme.dart';
import '../../../common/form_input_and_label/search_input.dart';
import '../show_toast.dart';
import '../../enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../network/services/cus_service.dart';

class BottomSheetCode extends StatefulWidget {
  final int position;
  final String? value;
  final TypeCode? func;
  final Function? handleSelectAccessCode;
  const BottomSheetCode(
      {Key? key,
      this.value,
      this.handleSelectAccessCode,
      this.func,
      required this.position})
      : super(key: key);

  @override
  State<BottomSheetCode> createState() => _BottomSheetCodeState();
}

class _BottomSheetCodeState extends State<BottomSheetCode>
    with BaseComponent<Cust> {
  late TextEditingController _searchController;
  List<Cust> list = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getApi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  getApi() async {
    if (widget.func == null) {
      await searchPaging(1);
    }

    if (widget.func == TypeCode.LIMITSETTING) {
      await getListCust();
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  getListCust() async {
    BaseResponseDataList responseDataList =
        await TransLimitByCustService().getListCust(widget.position);
    if (responseDataList.errorCode == FwError.THANHCONG.value) {
      listResponse =
          responseDataList.data!.map((cust) => Cust.fromJson(cust)).toList();

      if (widget.value!.isNotEmpty || widget.value != '') {
        Cust custTemp = Cust();
        custTemp.code = 'Tất cả';
        custTemp.id = 0;
        list.add(custTemp);
      }
      for (Cust items in listResponse) {
        list.add(items);
      }
    } else if (mounted) {
      showToast(
          context: context,
          msg: responseDataList.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  searchPaging(int curentPage) async {
    page.curentPage = curentPage;
    page.size = size;
    Cust cust = Cust();
    cust.position = widget.position;
    BasePagingResponse<Cust> response =
        await CusService().searchPaging(page, cust);
    if (response.errorCode == FwError.THANHCONG.value) {
      listResponse =
          response.data!.content!.map((cust) => Cust.fromJson(cust)).toList();

      if (widget.value!.isNotEmpty || widget.value != '') {
        Cust custTemp = Cust();
        custTemp.code = 'Tất cả';
        custTemp.id = 0;
        list.add(custTemp);
      }
      for (Cust items in listResponse) {
        list.add(items);
      }
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSheet();
  }

  buildSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchInput(
                searchController: _searchController,
                searchAction: searchAction),
          ),
          Expanded(
            child: isLoading
                ? const LoadingCircle()
                : (list.isEmpty)
                    ? const Center(
                        child: Text(
                        'Không có dữ liệu',
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                      ))
                    : ListView(
                        children: [
                          for (var item in list)
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.handleSelectAccessCode!(
                                      item.code, item.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 18),
                                  decoration:
                                      (list.indexOf(item) != list.length - 1)
                                          ? const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: coloreWhite_EAEBEC),
                                              ),
                                            )
                                          : null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.code ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: (widget.value == item.code)
                                              ? primaryColor
                                              : primaryBlackColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      (widget.value == item.code)
                                          ? const Icon(
                                              CupertinoIcons
                                                  .checkmark_alt_circle_fill,
                                              color: primaryColor,
                                              size: 24,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ))
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  void searchAction(String query) {
    final suggestions = listResponse.where((maTruyCap) {
      final accessCode = maTruyCap.code!.toLowerCase();
      final input = query.toLowerCase();
      if (accessCode.contains(input)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      list = suggestions;
    });
  }
}
