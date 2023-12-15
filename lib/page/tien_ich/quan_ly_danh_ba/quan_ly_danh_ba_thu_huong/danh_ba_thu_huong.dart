import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/checkbox.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/search_input.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/tien_ich/quan_ly_danh_ba/quan_ly_danh_ba_thu_huong/sua_them_danh_ba_thu_huong.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import '../../../../common/show_toast.dart';
import '../../../../enum/enum.dart';
import '../../../../network/services/cust_contact_service.dart';

class QuanLyDanhBaThuHuongScreen extends StatefulWidget {
  const QuanLyDanhBaThuHuongScreen({super.key});

  @override
  State<QuanLyDanhBaThuHuongScreen> createState() =>
      _QuanLyDanhBaThuHuongScreenState();
}

class _QuanLyDanhBaThuHuongScreenState extends State<QuanLyDanhBaThuHuongScreen>
    with BaseComponent {
  TextEditingController searchController = TextEditingController(text: '');
  Timer? debounceTimer;
  String search = '';
  int pages = 1;
  List<int> listId = [];
  bool hasMore = true;
  List<dynamic> listDanhBaThuHuong = [];
  final _controller = ScrollController();

  @override
  void initState() {
    searchPaging(curentPage: pages);
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        var count = listDanhBaThuHuong.length % 10;
        if (!isTop && count == 0) {
          searchPaging(curentPage: pages);
        }
      }
    });
  }

  searchPaging({int? curentPage, String? value}) async {
    if (value.toString().isNotEmpty) {
      hasMore = true;
    }
    page.curentPage = curentPage!;
    page.size = 10;
    CustContact contact = CustContact(sortname: value);
    BasePagingResponse<CustContact> response =
        await CusContactService().searchPaging(page, contact);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        pages++;
        listResponse = response.data!.content!
            .map((custContact) => CustContact.fromJson(custContact))
            .toList();
        listDanhBaThuHuong.addAll(listResponse);
        isLoading = false;
        if (listResponse.length < page.size!) {
          hasMore = false;
        }
      });
    } else if (response.errorMessage != null && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  deleteCustContact(List<int> listId, context) async {
    BaseResponse response = await CusContactService().deleteCustContact(listId);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      setState(() {
        listId.clear();
        isLoading = true;
        pages = 1;
        listDanhBaThuHuong.clear();
        searchPaging(curentPage: pages);
      });
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 55,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
          title: const Text("Quản lý danh bạ thụ hưởng"),
          actions: [
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuaThemDanhBaThuHuong(),
                  ),
                );
                if (result.toString().compareTo("Thành công") == 0) {
                  setState(() {
                    isLoading = true;
                    pages = 1;
                    listDanhBaThuHuong = [];
                    searchPaging(curentPage: pages);
                  });
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: renderBodyDanhBaThuHuong());
  }

  renderBodyDanhBaThuHuong() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SearchInput(
            searchController: searchController,
            searchAction: (value) async {
              if (debounceTimer != null && debounceTimer!.isActive) {
                debounceTimer!.cancel();
              }
              search = value;

              debounceTimer =
                  Timer(const Duration(milliseconds: 500), () async {
                // Gọi API tại đây với giá trị hiện tại
                setState(() {
                  isLoading = true;
                  listDanhBaThuHuong.clear();
                });
                await searchPaging(curentPage: 1, value: search);
              });
            },
          ),
        ),
        isLoading == false
            ? (listResponse.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text("Chưa có danh bạ thụ hưởng"),
                    ),
                  )
                : renderContent())
            : const Expanded(
                child: Center(
                  child: LoadingCircle(),
                ),
              ),
      ],
    );
  }

  renderContent() {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            height: 40,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Có (${listId.length}) bản ghi được chọn"),
                if (listId.isNotEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      await deleteCustContact(listId, context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorWhite,
                        elevation: 0,
                        side:
                            const BorderSide(width: 0.5, color: primaryColor)),
                    child: const Text(
                      "Xóa",
                      style: TextStyle(color: primaryColor),
                    ),
                  )
              ],
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.8,
            color: colorBlack_727374,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                controller: _controller,
                itemCount: listDanhBaThuHuong.length + 1,
                itemBuilder: (context, index) {
                  if (index < listDanhBaThuHuong.length) {
                    final items = listDanhBaThuHuong[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: CheckBoxWidget(
                                    value: listId.contains(items.id),
                                    handleSelected: (val) {
                                      setState(() {
                                        if (val) {
                                          listId.add(items.id!);
                                        } else {
                                          listId.remove(items.id);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items.sortname ?? ''.toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(items.receiveAccount ?? ''),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(items.receiveName ?? ''),
                                      ),
                                      Text(TransType.getNameByValue(
                                          items.product)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SuaThemDanhBaThuHuong(
                                          id: items.id,
                                          bankAccountNumber:
                                              items.receiveAccount,
                                          userName: items.receiveName,
                                          userNote: items.sortname,
                                          code: items.bankReceiving!.code,
                                          bankName: items.bankReceiving!.name,
                                          typeTrading: items.product,
                                        ),
                                      ),
                                    );
                                    if (result
                                            .toString()
                                            .compareTo("Thành công") ==
                                        0) {
                                      setState(() {
                                        listDanhBaThuHuong.clear();
                                        isLoading = true;
                                        pages = 1;
                                        searchPaging(curentPage: pages);
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: colorBlack_727374,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (listResponse.indexOf(items) !=
                              listResponse.length - 1)
                            const Divider(
                              thickness: 0.8,
                              height: 0,
                              color: colorBlack_727374,
                            ),
                        ],
                      ),
                    );
                  } else {
                    return hasMore
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: LoadingCircle(),
                          )
                        : Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
