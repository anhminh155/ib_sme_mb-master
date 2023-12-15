import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/search_input.dart';
import '../../../../../../utils/theme.dart';
import '../../../../model/model.dart';

class EmailAccessCodeBottom extends StatefulWidget {
  final String? value;
  final Function? handleSelectEmailAccessCode;
  final List<Cust> listCust;
  const EmailAccessCodeBottom(
      {Key? key,
      this.value,
      this.handleSelectEmailAccessCode,
      required this.listCust})
      : super(key: key);

  @override
  State<EmailAccessCodeBottom> createState() => _EmailAccessCodeBottomState();
}

class _EmailAccessCodeBottomState extends State<EmailAccessCodeBottom> {
  late TextEditingController _searchController;
  List<dynamic> listEmail = [];
  List<dynamic> listEmailTemp = [];

  @override
  void initState() {
    for (Cust item in widget.listCust) {
      listEmail.add(item.email);
      listEmailTemp.add(item.email);
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
                  for (var item in listEmail)
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.handleSelectEmailAccessCode!(item);
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
    final suggestions = listEmailTemp.where((emails) {
      final email = emails.toLowerCase();
      final input = query.toLowerCase();
      if (email.contains(input)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      listEmail = suggestions;
    });
  }
}
