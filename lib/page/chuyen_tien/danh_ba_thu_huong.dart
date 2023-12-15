import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/search_input.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/cust_contact.dart';
import 'package:ib_sme_mb_view/network/services/cust_contact_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import '../../enum/enum.dart';
import '../../model/model.dart';

class Constacts extends StatefulWidget {
  final String? transType;
  final Function? callback;
  final TextEditingController recieveAccController;
  final TextEditingController recieveNameController;
  final TextEditingController recieveBankController;
  const Constacts(
      {super.key,
      required this.recieveAccController,
      required this.recieveNameController,
      required this.recieveBankController,
      this.transType,
      this.callback});

  @override
  State<Constacts> createState() => _ConstactsState();
}

class _ConstactsState extends State<Constacts> {
  bool _isLoading = true;
  List<CustContact> allContact = [];
  List<CustContact> contacts = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    _getContracts();
    super.initState();
  }

  _getContracts() async {
    try {
      setState(() => _isLoading = true);
      // BaseResponseDataList response = await Transaction_Service()
      //     .getContractByCustId(
      //         TransType.getProductType(widget.transType), context);
      PagesRequest page = PagesRequest();
      page.curentPage = 1;
      page.size = 100;
      BasePagingResponse response = await CusContactService().searchCustContact(
        page,
        TransType.getProductTypeByString(widget.transType.toString()),
        null,
      );
      setState(() => _isLoading = false);

      allContact = response.data!.content!
          .map((json) => CustContact.fromJson(json))
          .toList();
      contacts = allContact;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: (_isLoading) ? const LoadingCircle() : _renderBody(),
      ),
    );
  }

  _renderBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        _renderSearchContract(),
        (contacts.isNotEmpty)
            ? Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = contacts[index];
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text(item.sortname ?? ''),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.receiveAccount!),
                                Text(item.bankReceiving!.name),
                              ],
                            ),
                            onTap: () {
                              if (widget.callback != null) {
                                widget.callback!(item);
                              }
                              //Navigator.pop(context);
                              setState(() {
                                widget.recieveAccController.text =
                                    item.receiveAccount!;
                                widget.recieveNameController.text =
                                    item.receiveName!;
                                widget.recieveBankController.text =
                                    item.bankReceiving!.name;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          const Divider(
                            indent: 20.0,
                            endIndent: 20.0,
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : const Expanded(
                child: Center(
                    child: Text(
                'Không có dữ liệu',
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              ))),
      ],
    );
  }

  _renderSearchContract() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              const Expanded(
                flex: 1,
                child: Text(
                  "Danh bạ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: primaryColor),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Đóng",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SearchInput(
            searchController: searchController,
            searchAction: (value) {
              setState(() {
                contacts = allContact
                    .where((element) => element.sortname!
                        .toLowerCase()
                        .toString()
                        .contains(value.toString().toLowerCase()))
                    .toList();
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
