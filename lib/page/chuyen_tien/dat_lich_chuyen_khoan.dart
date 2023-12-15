import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:intl/intl.dart';
import '../../common/form_input_and_label/text_field.dart';
import '../../utils/theme.dart';

class ScheduleTransfer extends StatefulWidget {
  final TextEditingController scheduleFuture;
  final TextEditingController schedulesFromDate;
  final TextEditingController schedulesToDate;
  final TextEditingController schedulesTimes;
  final TextEditingController schedulesFrequency;
  final TextEditingController schedulesTimesFrequency;
  final bool schedual;
  const ScheduleTransfer(
      {super.key,
      required this.schedual,
      required this.scheduleFuture,
      required this.schedulesFromDate,
      required this.schedulesToDate,
      required this.schedulesTimes,
      required this.schedulesFrequency,
      required this.schedulesTimesFrequency});

  @override
  State<ScheduleTransfer> createState() => _ScheduleTransferState();
}

class _ScheduleTransferState extends State<ScheduleTransfer> {
  DateTime dateNow = DateTime.now();

  //late DateTime selectedDateTime;
  final List<String> _dropdownItems = [
    'Ngày',
    'Tuần',
    'Tháng',
    'Quý',
    'Năm',
  ];
  String _selectedItem = 'Ngày';
  DateTime initDate = DateTime.now().toLocal();
  final formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    widget.schedulesTimes.text = '1';
    widget.schedulesFrequency.text = '1';
    widget.scheduleFuture.text =
        formatter.format(initDate.add(const Duration(days: 1)));
    widget.schedulesFromDate.text = formatter.format(initDate);
    widget.schedulesToDate.text =
        formatter.format(initDate.add(const Duration(days: 1)));
    widget.schedulesTimesFrequency.text = '2';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return renderBody();
  }

  renderBody() {
    {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SizeTransition(sizeFactor: animation, child: child);
        },
        child: widget.schedual ? _chuyenTienTuongLai() : _chuyenTienDinhKy(),
      );
    }
  }

  _chuyenTienTuongLai() {
    return SizedBox(
      key: const ValueKey(1),
      child: FormControlWidget(
        label: 'Đặt lịch',
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFieldWidget(
            suffixIcon: const Icon(Icons.calendar_month_outlined),
            controller: widget.scheduleFuture,
            readOnly: true,
            hintText: 'Đặt lịch',
            onTapInput: () => _onPressDate(
                widget.scheduleFuture, formatter, dateNow, DateTime.now().add(const Duration(days: 1))),
          ),
        ),
      ),
    );
  }

  _chuyenTienDinhKy() {
    return SizedBox(
      key: const ValueKey(2),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            // width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tần suất",
                  style: TextStyle(
                    color: colorBlack_727374,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFieldWidget(
                        textInputType: TextInputType.number,
                        controller: widget.schedulesTimes,
                        hintText: 'Nhập tần suất',
                        onChange: (value) {
                          _tinhTanSuat(
                              widget.schedulesTimes.text,
                              _selectedItem,
                              formatter.parse(widget.schedulesFromDate.text),
                              formatter.parse(widget.schedulesToDate.text));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: DropdownButton(
                        alignment: Alignment.centerRight,
                        value: _selectedItem,
                        items: _dropdownItems.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value!;
                          });
                          _tinhTanSuat(
                              widget.schedulesTimes.text,
                              value!,
                              formatter.parse(widget.schedulesFromDate.text),
                              formatter.parse(widget.schedulesToDate.text));
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Khoảng thời gian",
                  style: TextStyle(
                    color: colorBlack_727374,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFieldWidget(
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        controller: widget.schedulesFromDate,
                        readOnly: true,
                        hintText: 'Từ ngày',
                        onTapInput: () => _onPressDate(widget.schedulesFromDate,
                            formatter, dateNow, DateTime(1970)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFieldWidget(
                        textInputType: TextInputType.datetime,
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        controller: widget.schedulesToDate,
                        readOnly: true,
                        hintText: 'Đến ngày',
                        onTapInput: () => _onPressDate(
                            widget.schedulesToDate,
                            formatter,
                            dateNow,
                            formatter.parse(widget.schedulesFromDate.text)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: Text(
                    "Số lần giao dịch: ${widget.schedulesTimesFrequency.text}",
                    style: const TextStyle(
                        color: colorBlack_727374,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _onPressDate(
      controller, DateFormat dateFormat, currentTime, DateTime minTime) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: minTime,
        maxTime: DateTime(2100, 1, 1),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        controller.text = formatter.format(date);
        _tinhTanSuat(
            widget.schedulesTimes.text,
            _selectedItem,
            formatter.parse(widget.schedulesFromDate.text),
            formatter.parse(widget.schedulesToDate.text));
      });
    }, currentTime: currentTime, locale: LocaleType.vi);
  }

  inputDecorationScreen({hintText, suffixText, suffixIcon}) => InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: colorBlack_727374,
        ),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        fillColor: Colors.white,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            // color: Color(0xFFC0C2C3),
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC0C2C3), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          color: colorBlack_20262C,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
      );

  _tinhTanSuat(
      String frequency, String date, DateTime startDate, DateTime endDate) {
    if (!startDate.isAfter(endDate) && frequency.isNotEmpty) {
      int times = int.parse(frequency);
      setState(() {
        widget.schedulesTimes.text = frequency;
        Duration difference = endDate.difference(startDate);
        switch (date) {
          case 'Ngày':
            int numberOfDays = difference.inDays;
            widget.schedulesTimesFrequency.text =
                (1 + numberOfDays ~/ times).toString();
            widget.schedulesFrequency.text = '1';
            break;
          case 'Tuần':
            int numberOfDays = difference.inDays;
            widget.schedulesTimesFrequency.text =
                (1 + numberOfDays ~/ (7 * times)).toString();
            widget.schedulesFrequency.text = '2';
            break;
          case 'Tháng':
            int numberOfMonths = (endDate.year - startDate.year) * 12 +
                (endDate.month - startDate.month);
            widget.schedulesTimesFrequency.text =
                (1 + numberOfMonths ~/ times).toString();
            widget.schedulesFrequency.text = '3';
            break;
          case 'Quý':
            widget.schedulesTimesFrequency.text = (1 +
                    (((endDate.year - startDate.year) * 12) +
                            (endDate.month - startDate.month)) ~/
                        (3 * times))
                .toString();
            widget.schedulesFrequency.text = '4';
            break;
          case 'Năm':
            widget.schedulesTimesFrequency.text =
                (1 + (endDate.year - startDate.year) ~/ times).toString();
            widget.schedulesFrequency.text = '5';
            break;
          default:
        }
      });
    } else {
      setState(() {
        widget.schedulesTimesFrequency.text = '0';
      });
    }
  }
}
