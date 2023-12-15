import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/text_field.dart';

import '../form_input_and_label/search_input.dart';

class InputShowBottomSheet extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final Function? onSearch;
  final Widget bodyWidget;
  const InputShowBottomSheet(
      {super.key,
      this.hintText,
      this.controller,
      this.icon,
      this.onSearch,
      required this.bodyWidget});
  @override
  State<InputShowBottomSheet> createState() => _InputShowBottomSheetState();
}

class _InputShowBottomSheetState extends State<InputShowBottomSheet> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      controller: widget.controller ?? TextEditingController(),
      fontSize: 14.0,
      horizontal: 6,
      readOnly: true,
      onTapInput: () {
        showModalBottomSheet<void>(
            backgroundColor: Colors.transparent,
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, setState) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Wrap(
                      children: [
                        Container(
                          height: 3.5,
                          width: 30,
                          margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  (MediaQuery.of(context).size.width * 0.45)),
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        if (widget.onSearch != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SearchInput(
                                searchController: searchController,
                                searchAction: (String query) {
                                  widget.onSearch!(query);
                                }),
                          ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.1,
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          child: SingleChildScrollView(
                            child: widget.bodyWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      hintText: widget.hintText ?? "",
      suffixIcon: Icon(widget.icon ?? Icons.keyboard_arrow_down),
    );
  }
}
