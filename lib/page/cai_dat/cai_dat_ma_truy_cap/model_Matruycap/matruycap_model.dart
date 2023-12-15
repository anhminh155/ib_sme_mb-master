import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/theme.dart';
import '../../../../common/form_input_and_label/search_input.dart';
import '../../../../model/model.dart';

class AccessCodeBottom extends StatefulWidget {
  final String? value;
  final Function? handleSelectAccessCode;
  final List<Cust> listCust;
  const AccessCodeBottom(
      {Key? key,
      this.value,
      this.handleSelectAccessCode,
      required this.listCust})
      : super(key: key);

  @override
  State<AccessCodeBottom> createState() => _AccessCodeBottomState();
}

class _AccessCodeBottomState extends State<AccessCodeBottom> {
  late TextEditingController _searchController;
  List<dynamic> listMatruyCap = [];
  List<dynamic> listMatruyCapTemp = [];

  @override
  void initState() {
    for (Cust item in widget.listCust) {
      listMatruyCap.add(item.code);
      listMatruyCapTemp.add(item.code);
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
                  for (var item in listMatruyCap)
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.handleSelectAccessCode!(item);
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
    final suggestions = listMatruyCapTemp.where((code) {
      final accessCode = code.toLowerCase();
      final input = query.toLowerCase();
      if (accessCode.contains(input)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      listMatruyCap = suggestions;
    });
  }
}
