// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/transaction_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:provider/provider.dart';
import '../../../../common/button.dart';
import '../../../../common/card_layout.dart';
import '../../../../common/dialog_confirm.dart';
import '../../../../common/form_input_and_label/label.dart';
import '../../../../enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../../utils/formatCurrency.dart';
import '../../../../utils/theme.dart';
import '../transacion_results/single_trans_result.dart';

class SingleTransConfirm extends StatefulWidget {
  final Transaction transfer;
  final SchedulesModel schedulesModel;
  final String transType;
  final String transCode;
  final bool isScheduleTransfer;
  const SingleTransConfirm(
      {Key? key,
      required this.transfer,
      required this.schedulesModel,
      required this.isScheduleTransfer,
      required this.transType,
      required this.transCode})
      : super(key: key);

  @override
  State<SingleTransConfirm> createState() => _SingleTransConfirmState();
}

class _SingleTransConfirmState extends State<SingleTransConfirm> {
  bool _isLoading = false;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  Timer? timer;
  int _start = 100;

  void _startTimer() async {
    timer?.cancel();
    setState(() {
      _isLoading = false;
    });
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          showDiaLogConfirm(
            context: context,
            content:Text("Mã giao dịch hết hạn",textAlign: TextAlign.center,))
            .whenComplete(() => Navigator.of(context).pop());
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác thực giao dịch"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [_renderBody(context), if (_isLoading) const LoadingCircle()],
      ),
    );
  }

  _renderBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _renderCard1(context),
            const SizedBox(
              height: 20,
            ),
            _renderCard2(context),
            const SizedBox(
              height: 20,
            ),
            _renderCard3(context),
            const SizedBox(
              height: 20,
            ),
            _renderButtons(context, size),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _renderCard1(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      child: CardLayoutWidget(
        child: Column(
          children: [
            _renderField(context, "Loại giao dịch",
                translation(context)!.trans_typeKey(widget.transType)),
            renderLine(),
            _renderField(
                context, "Tài khoản nguồn", widget.transfer.sendAccount),
          ],
        ),
      ),
    );
  }

  _renderCard2(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      child: CardLayoutWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _renderField(
                context, "Tài khoản thụ hưởng", widget.transfer.receiveAccount),
            renderLine(),
            _renderField(
                context, "Tên người thụ hưởng", widget.transfer.receiveName),
            renderLine(),
            _renderField(
                context, "Ngân hàng thụ hưởng", widget.transfer.receiveBank),
            renderLine(),
            _renderField(
                context, "Số tiền giao dịch", '${widget.transfer.amount} VND'),
            _renderReadAmout(
                Currency.removeFormatNumber(widget.transfer.amount)),
            renderLine(),
            _renderField(context, "Số tiền phí",
                Currency.formatCurrency(_getTotalFee())),
            _renderReadAmout(_getTotalFee().toString()),
            renderLine(),
            _renderField(
                context,
                "Phí giao dịch",
                widget.transfer.feeType == 1
                    ? "Người chuyển trả"
                    : "Người nhận trả"),
            renderLine(),
            _renderField(context, "Nội dung", widget.transfer.content),
            renderLine(),
            _renderField(context, "Mã giao dịch", widget.transCode),
            renderLine(),
            renderCountDown()
          ],
        ),
      ),
    );
  }

  renderCountDown() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
                text: 'Mã giao dịch của quý khách sẽ hết hạn sau :',
                style: TextStyle(color: Colors.black)),
            TextSpan(
              text: ' ${_start}s',
              style: const TextStyle(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  _getTotalFee() {
    double fee =
        double.tryParse(Currency.removeFormatNumber(widget.transfer.fee)) ?? 0;
    double vat =
        double.tryParse(Currency.removeFormatNumber(widget.transfer.vat)) ?? 0;
    return (fee + vat).truncate();
  }

  _renderReadAmout(String amount) {
    if (amount.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Text(
          Currency.numberToWords(int.parse(amount)),
          style: const TextStyle(color: primaryColor),
          textAlign: TextAlign.left,
        ),
      );
    }
    return Container();
  }

  _renderCard3(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      child: CardLayoutWidget(
        child: Column(
          children: [
            _renderField(context, "Phương thức xác thực", "Smart OTP"),
          ],
        ),
      ),
    );
  }

  _renderField(BuildContext context, lable, data) {
    return Center(
      child: LabelWidget(
          colors: colorBlack_727374,
          label: lable,
          fontWeight: FontWeight.w500,
          //padding: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              data,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                color: primaryBlackColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    );
  }

  renderLine() {
    return Divider(
      color: coloreWhite_EAEBEC, // Màu của đường kẻ
      thickness: 1.0, // Độ dày của đường kẻ
    );
  }

  _renderButtons(BuildContext context, size) {
    return SizedBox(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _renderBackButton(context, size),
          _renderNextButton(context, size)
        ],
      ),
    );
  }

  _renderBackButton(BuildContext context, size) {
    return SizedBox(
      width: size.width * 0.3,
      child: ButtonWidget(
        text: translation(context)!.backKey,
        backgroundColor: secondaryColor,
        haveBorder: false,
        widthButton: MediaQuery.of(context).size.width,
        colorText: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _renderNextButton(BuildContext context, size) {
    return SizedBox(
        width: size.width * 0.3,
        child: ButtonWidget(
          text: translation(context)!.continueKey,
          backgroundColor: primaryColor,
          haveBorder: false,
          widthButton: MediaQuery.of(context).size.width,
          colorText: Colors.white,
          onPressed: () {
            OtpFunction().showDialogEnterPinOTP(
                context: context,
                transCode: widget.transCode,
                callBack: (otp, transCode) {
                  _doTranfer(otp);
                });
          },
        ));
  }

  _doTranfer(otp) async {
    try {
      setState(() => _isLoading = true);
      BaseResponse response = const BaseResponse();
      if (!widget.isScheduleTransfer) {
        response = await Transaction_Service()
            .createtrans(widget.transfer, otp, widget.transCode);
      } else {
        var tran = widget.transfer;
        var schedulesModel = widget.schedulesModel;
        TranSchedule tranSchedule = TranSchedule(
            amount: tran.amount,
            content: tran.content,
            fee: tran.fee,
            vat: tran.vat,
            sendAccount: tran.sendAccount,
            receiveAccount: tran.receiveAccount,
            receiveBank: tran.receiveBank,
            receiveName: tran.receiveName,
            type: tran.type,
            feeType: tran.feeType,
            schedules: schedulesModel.schedules,
            scheduleFuture: schedulesModel.scheduleFuture,
            schedulesFromDate: schedulesModel.schedulesFromDate,
            schedulesToDate: schedulesModel.schedulesToDate,
            schedulesTimes: schedulesModel.schedulesTimes,
            schedulesFrequency: schedulesModel.schedulesFrequency,
            schedulesTimesFrequency: schedulesModel.schedulesTimesFrequency,
            transType: 'MB');
        response = await Transaction_Service()
            .createtranschedule(tranSchedule, otp, widget.transCode);
      }
      if (response.errorCode == FwError.THANHCONG.value) {
        //cap nhap so du
        await Provider.of<SourceAcctnoProvider>(context, listen: false)
            .update();
        Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleTranResult(
                response: TransactionResponse.fromJson(response.data),
                transType: widget.transType,
              ),
            ));
      } else if (mounted) {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
