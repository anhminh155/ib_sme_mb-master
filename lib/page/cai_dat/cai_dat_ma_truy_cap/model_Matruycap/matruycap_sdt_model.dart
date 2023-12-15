import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/theme.dart';
import '../../../../common/form_input_and_label/search_input.dart';
import '../../../../model/model.dart';

class NumberPhoneAccessCodeBottom extends StatefulWidget {
  final String? value;
  final Function? handleSelectNumberPhoneAccessCode;
  final List<Cust> listCust;
  const NumberPhoneAccessCodeBottom(
      {Key? key,
      this.value,
      this.handleSelectNumberPhoneAccessCode,
      required this.listCust})
      : super(key: key);

  @override
  State<NumberPhoneAccessCodeBottom> createState() =>
      _NumberPhoneAccessCodeBottomState();
}

class _NumberPhoneAccessCodeBottomState
    extends State<NumberPhoneAccessCodeBottom> {
  late TextEditingController _searchController;
  List<dynamic> listPhoneTemp = [];
  List<dynamic> listPhone = [];

  @override
  void initState() {
    for (Cust item in widget.listCust) {
      if (item.tel != null) {
        listPhone.add(item.tel);
        listPhoneTemp.add(item.tel);
      }
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
                searchAction: searchAction),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  for (var item in listPhone)
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.handleSelectNumberPhoneAccessCode!(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: coloreWhite_EAEBEC))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: (widget.value == item)
                                      ? primaryColor
                                      : primaryBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              (widget.value == item)
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
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
          ),
        ],
      ),
    );
  }

  void searchAction(String query) {
    final suggestions = listPhoneTemp.where((phone) {
      final numberPhone = phone.toLowerCase();
      final input = query.toLowerCase();
      if (numberPhone.contains(input)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      listPhone = suggestions;
    });
  }
}
