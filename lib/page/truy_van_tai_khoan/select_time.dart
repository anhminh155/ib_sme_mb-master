import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:intl/intl.dart';
import '../../common/button.dart';
import '../../common/date_time_picker.dart';
import '../../common/form/form_control.dart';
import '../../utils/theme.dart';

class SelectTime extends StatefulWidget {
  final Function onClickSearch;
  const SelectTime({super.key, required this.onClickSearch});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  late TextEditingController fromDateHistory;
  late TextEditingController toDateHistory;
  int timeCheck = 0;
  bool check = false;

  @override
  void initState() {
    fromDateHistory = TextEditingController(text: mostRecentDay(7));
    toDateHistory = TextEditingController(text: mostRecentDay(0));
    handleSearch();
    super.initState();
  }

  void handleSearch() {
    Map<String, String> bodyRequest = {
      "fromDateHistory": fromDateHistory.text,
      "toDateHistory": toDateHistory.text,
    };
    widget.onClickSearch(bodyRequest);
  }

  String mostRecentDay(int dayInput) {
    DateTime date = DateTime.now();
    return DateFormat("dd/MM/yyyy")
        .format(DateTime(date.year, date.month, date.day - dayInput));
  }

  @override
  void dispose() {
    fromDateHistory.dispose();
    toDateHistory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sổ phụ tài khoản",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10.0,
        ),
        InkWell(
          onTap: () {
            setState(() {
              check = !check;
            });
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                stops: [0.1, 0.5, 0.9],
                colors: [
                  Color.fromRGBO(0, 77, 150, 1),
                  Color.fromRGBO(77, 107, 127, 1),
                  Color.fromRGBO(193, 121, 21, 1),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12.0, bottom: 12.0, left: 16.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      translation(context)!.timeKey,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    timeCheck == 0
                        ? translation(context)!.last_dayKey('7')
                        : timeCheck == 1
                            ? translation(context)!.last_dayKey('30')
                            : timeCheck == 2
                                ? translation(context)!.another_timeKey
                                : '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        if (check == true)
          DecoratedBox(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        timeCheck = 0;
                        check = false;
                        fromDateHistory.text = mostRecentDay(7);
                        toDateHistory.text = mostRecentDay(0);
                      });
                    },
                    child: renderLineContent(
                        label: translation(context)!.last_dayKey('7'),
                        content: ''),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        timeCheck = 1;
                        check = false;
                        fromDateHistory.text = mostRecentDay(30);
                        toDateHistory.text = mostRecentDay(0);
                      });
                    },
                    child: renderLineContent(
                        label: translation(context)!.last_dayKey('30'),
                        content: ''),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        timeCheck = 2;
                        check = false;
                        fromDateHistory.clear();
                        toDateHistory.clear();
                      });
                    },
                    child: renderLineContent(
                        label: translation(context)!.another_timeKey,
                        content: '',
                        line: false),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(
          height: 8.0,
        ),
        if (timeCheck == 2)
          FormControlWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: DateTimePickerWidget(
                      controllerDateTime: fromDateHistory,
                      hintText: "Từ ngày",
                      maxTime: toDateHistory.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').parse(toDateHistory.text)
                          : null,
                      onConfirm: (date) {
                        setState(() {
                          fromDateHistory.text =
                              DateFormat('dd/MM/yyyy').format(date);
                        });
                      },
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DateTimePickerWidget(
                    controllerDateTime: toDateHistory,
                    hintText: "Đến ngày",
                    minTime: fromDateHistory.text.isNotEmpty
                        ? DateFormat('dd/MM/yyyy').parse(fromDateHistory.text)
                        : null,
                    onConfirm: (date) {
                      setState(() {
                        toDateHistory.text =
                            DateFormat('dd/MM/yyyy').format(date);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(
          height: 16.0,
        ),
        ButtonWidget(
            backgroundColor: primaryColor,
            onPressed: () {
              handleSearch();
            },
            text: translation(context)!.searchKey,
            colorText: Colors.white,
            haveBorder: false,
            widthButton: MediaQuery.of(context).size.width)
      ],
    );
  }

  renderLineContent({String? label, dynamic content, bool line = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label!), Text(content)],
          ),
        ),
        if (line)
          const Divider(
            height: 1.0,
            thickness: 1.0,
          ),
      ],
    );
  }
}
