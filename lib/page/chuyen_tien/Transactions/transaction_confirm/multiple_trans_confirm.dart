// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/chuyen_tien/Transactions/transacion_results/multiple_trans_result.dart';
import 'package:ib_sme_mb_view/provider/send_acctno_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../../common/button.dart';
import '../../../../common/card_layout.dart';
import '../../../../common/form_input_and_label/label.dart';
import '../../../../enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../../network/services/transaction_service.dart';
import '../../../../utils/formatCurrency.dart';
import '../../../../utils/theme.dart';

class MultipleTransConfirm extends StatefulWidget {
  final String transCode;
  final String transType;
  final List<Transaction> listTrans;
  const MultipleTransConfirm(
      {super.key,
      required this.listTrans,
      required this.transType,
      required this.transCode});

  @override
  State<MultipleTransConfirm> createState() => _MultipleTransConfirmState();
}

class _MultipleTransConfirmState extends State<MultipleTransConfirm> {
  bool _isLoading = false;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác thực giao dịch'),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [renderBody(), if (_isLoading) const LoadingCircle()],
      ),
    );
  }

  renderSpace(double size) => SizedBox(
        height: size,
      );

  renderBody() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            renderSpace(20),
            renderCard1(),
            renderSpace(20),
            renderCard2(),
            renderSpace(20),
            renderCard3(),
            renderSpace(20),
            renderButtons(),
            renderSpace(30),
          ],
        ),
      ),
    );
  }

  renderListReciever() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin người nhận'),
        renderSpace(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < widget.listTrans.length; i++)
              InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                      _showModelSheetInfo(widget.listTrans[i]);
                    });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .26,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 50, // Đặt chiều rộng của Container tùy ý
                            height: 50, // Đặt chiều cao của Container tùy ý
                            decoration: BoxDecoration(
                              color: (currentIndex == i)
                                  ? primaryColor
                                  : Colors.white,
                              shape: BoxShape
                                  .circle, // Đặt hình dạng của Container là hình tròn
                              border: Border.all(
                                color: primaryColor, // Đặt màu biên viền
                                width: 2, // Đặt độ dày biên viền
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: (currentIndex == i)
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        renderSpace(5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .23,
                          child: Text(
                            widget.listTrans[i].receiveName,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ))
          ],
        ),
      ],
    );
  }

  renderCard1() {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      child: CardLayoutWidget(
        child: Column(
          children: [
            renderField("Loại giao dịch",
                translation(context)!.trans_typeKey(widget.transType)),
            renderLine(),
            renderField("Tài khoản nguồn", widget.listTrans[0].sendAccount),
          ],
        ),
      ),
    );
  }

  renderCard2() {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      child: CardLayoutWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            renderListReciever(),
            renderLine(),
            renderField("Tổng số tiền giao dịch",
                Currency.formatCurrency(_getAllAmount())),
            renderSpace(5),
            renderReadAmout(_getAllAmount().toString()),
            renderLine(),
            renderField(
                "Tổng số tiền phí", Currency.formatCurrency(_getAllFee())),
            renderSpace(10),
            renderReadAmout(_getAllFee().toString()),
            renderLine(),
          ],
        ),
      ),
    );
  }

  _getAllAmount() {
    int amount = 0;
    for (var element in widget.listTrans) {
      amount += int.parse(Currency.removeFormatNumber(element.amount));
    }
    return amount;
  }

  _getAllFee() {
    int amount = 0;
    for (var element in widget.listTrans) {
      amount += int.parse(Currency.removeFormatNumber(element.fee));
      amount += int.parse(Currency.removeFormatNumber(element.vat));
    }
    return amount;
  }

  renderCard3() {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.95,
      child: CardLayoutWidget(
        child: Column(
          children: [
            renderField("Phương thức xác thực", "Smart OTP"),
          ],
        ),
      ),
    );
  }

  renderField(lable, data) {
    return Center(
      child: LabelWidget(
        colors: colorBlack_727374,
        label: lable,
        fontWeight: FontWeight.w500,
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
      ),
    );
  }

  renderLine() {
    return Divider(
      color: coloreWhite_EAEBEC, // Màu của đường kẻ
      thickness: 1.0, // Độ dày của đường kẻ
    );
  }

  renderReadAmout(String amount) {
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

  renderButtons() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderBackButton(context, size),
          renderNextButton(context, size)
        ],
      ),
    );
  }

  renderBackButton(BuildContext context, size) {
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

  renderNextButton(BuildContext context, size) {
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
      BaseResponseDataList response = await Transaction_Service()
          .createListTrans(widget.listTrans, otp, widget.transCode);
      if (response.errorCode == FwError.THANHCONG.value) {
        await Provider.of<SourceAcctnoProvider>(context, listen: false)
            .update();
        Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultipleTransResults(
                transType: widget.transType,
                listTrans: response.data!
                    .map((e) => ListTransactionResponse.fromJson(e))
                    .toList(),
              ),
            ));
      } else {
        showDiaLogConfirm(
            content: Text(response.errorMessage ?? "Lỗi"), context: context);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _showModelSheetInfo(Transaction item) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      child: Text(
                        'Chi tiết',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Đóng',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    renderField("Tài khoản thụ hưởng", item.receiveAccount),
                    renderLine(),
                    renderField("Tên người thụ hưởng", item.receiveName),
                    renderLine(),
                    renderField("Ngân hàng thụ hưởng", item.receiveBank),
                    renderLine(),
                    renderField("Số tiền giao dịch", '${item.amount} VND'),
                    renderReadAmout(Currency.removeFormatNumber(item.amount)),
                    renderLine(),
                    renderField(
                        "Số tiền phí",
                        Currency.formatCurrency(
                            int.parse(item.fee) + int.parse(item.vat))),
                    renderReadAmout(Currency.removeFormatNumber(item.fee)),
                    renderLine(),
                    renderField(
                        "Phí giao dịch",
                        item.feeType == 1
                            ? "Người chuyển trả"
                            : "Người nhận trả"),
                    renderLine(),
                    renderField("Nội dung", item.content),
                    renderLine(),
                    renderField("Mã giao dịch", widget.transCode),
                    renderLine(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
