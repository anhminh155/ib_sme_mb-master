import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import '../../../common/form_input_and_label/search_input.dart';
import '../../../model/models.dart';
import '../../../utils/theme.dart';

class NganHangThuHuongModal extends StatefulWidget {
  final String? value;
  final List<BankReceivingModel>? listData;
  final Function? handleSelectedBank;
  const NganHangThuHuongModal(
      {Key? key, this.value, this.handleSelectedBank, this.listData})
      : super(key: key);

  @override
  State<NganHangThuHuongModal> createState() => _NganHangThuHuongModalState();
}

class _NganHangThuHuongModalState extends State<NganHangThuHuongModal>
    with BaseComponent {
  late TextEditingController _searchController;
  List<BankReceivingModel> listSearch = [];
  final String title = "Ngân hàng thụ hưởng";

  @override
  void initState() {
    if (widget.listData != null) {
      setState(() {
        listSearch = widget.listData!;
        isLoading = !isLoading;
      });
    }
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSheet();
  }

  buildSheet() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Wrap(
        children: [
          Container(
            height: 3.5,
            width: 30,
            margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: (MediaQuery.of(context).size.width * 0.45)),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchInput(
              searchController: _searchController,
              searchAction: (value) {
                searchAction(value);
              },
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (widget.listData!.length == 1)
                  ? MediaQuery.of(context).size.height * 0.07
                  : MediaQuery.of(context).size.height * 0.45,
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: isLoading
                ? const LoadingCircle()
                : SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (var item in listSearch)
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                widget.handleSelectedBank!(item);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: coloreWhite_EAEBEC))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Container(
                                    //   margin:
                                    //       const EdgeInsets.symmetric(horizontal: 8),
                                    //   height: 50,
                                    //   width: 50,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(8),
                                    //       image: DecorationImage(
                                    //           image: NetworkImage(item.avatar),
                                    //           fit: BoxFit.cover)),
                                    // ),
                                    Expanded(
                                      child: Text(
                                        '${item.name} ${item.sortname != null ? '(${item.sortname})' : ''}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: (widget.value == item.name)
                                              ? primaryColor
                                              : primaryBlackColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void searchAction(String query) {
    List<BankReceivingModel> suggestions =
        widget.listData!.where((nganHangThuHuong) {
      final nganHangThuHuongName = nganHangThuHuong.name.toLowerCase();
      final nganHangThuHuongSortName =
          nganHangThuHuong.sortname?.toLowerCase() ?? '';
      final inputName = query.toLowerCase();
      final inputSortName = query.toLowerCase();
      if (nganHangThuHuongName.contains(inputName) ||
          nganHangThuHuongSortName.contains(inputSortName)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      listSearch = suggestions;
    });
  }
}
