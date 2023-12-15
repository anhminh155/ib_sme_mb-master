// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/chuyen_tien/danh_ba_thu_huong.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/formatCurrency.dart';
import 'package:provider/provider.dart';
import '../../../../common/button.dart';
import '../../../../common/form/input_show_bottom_sheet.dart';
import '../../../../common/form_input_and_label/form_input.dart';
import '../../../../common/form_input_and_label/text_field.dart';
import '../../../../common/loading_circle.dart';
import '../../../../common/show_important_noti.dart';
import '../../../../enum/enum.dart';
import '../../../../network/services/bank_receiving_service.dart';
import '../../../../network/services/transaction_service.dart';
import '../../../../utils/theme.dart';
import '../ngan_hang_thu_huong_modal.dart';
import '../../dat_lich_chuyen_khoan.dart';
import '../transaction_confirm/multiple_trans_confirm.dart';
import '../transaction_confirm/single_trans_confirm.dart';

class TransactionsCreate extends StatefulWidget {
  final String tranType;
  final Transaction? initTrans;
  const TransactionsCreate({Key? key, required this.tranType, this.initTrans})
      : super(key: key);

  @override
  State<TransactionsCreate> createState() => _TransactionsCreateState();
}

class _TransactionsCreateState extends State<TransactionsCreate> {
  final _sendAccController = TextEditingController();
  final _recieveAccController = TextEditingController();
  final _recieveNameController = TextEditingController();
  final _recieveBankController = TextEditingController();
  final _chiNhanhController = TextEditingController();
  final _amountController = TextEditingController();
  final _transFeeController = TextEditingController();
  final _contentController = TextEditingController();
  final _scheduleFuture = TextEditingController();
  final _schedulesFromDateController = TextEditingController();
  final _schedulesToDateController = TextEditingController();
  final _schedulesTimesController = TextEditingController();
  final _schedulesFrequencyController = TextEditingController();
  final _schedulesTimesFrequencyController = TextEditingController();
  final _scheduleFutureController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;
  bool _scheduleTransfer = false;
  bool _isSameTranInfo = false;
  bool _isSelectedFee = true;
  bool _isSelectedscheduleTransfer = true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusBankAccount = FocusNode();
  late int numberOfRecipients;
  late Cust cust;
  int currentIndex = 0;
  int currentIndexAcc = 0;
  late Transaction initTrans;
  List<Transaction> listTrans = [];
  List<BankReceivingModel> listBankReceiving = [];
  String bankCode = '';
  double balance = 0;
  String amount = '';
  String transactionCode = "";

  @override
  void initState() {
    super.initState();
    cust = Provider.of<CustInfoProvider>(context, listen: false).cust!;
    try {
      var acc =
          Provider.of<SourceAcctnoProvider>(context, listen: false).items[0];
      _sendAccController.text = acc.acctno ?? "";
      balance = acc.curbalance ?? 0;
    } catch (_) {}
    _recieveBankController.text = widget.tranType == TransType.CORE.value
        ? 'Ngân hàng TM TNHH MTV Xây dựng Việt Nam'
        : '';
    _contentController.text = '${cust.company?.fullname ?? ""} chuyen khoan';
    if (widget.initTrans == null) {
      _addInitModel();
    } else {
      listTrans.add(widget.initTrans!);
      _setInitUser(listTrans[0]);
    }
    if (widget.tranType != TransType.CORE.value) {
      _getBankReceivingByProduct();
    }
    _focusBankAccount.addListener(() {
      if (!_focusBankAccount.hasFocus) {
        if (_recieveAccController.text.isNotEmpty) {
          if (widget.tranType == TransType.NAPAS.value) {
            _getRecieveNameNapas();
          }
          if (widget.tranType == TransType.CORE.value) {
            _getRecieveName();
          }
        } else {
          _recieveNameController.text = '';
        }
      }
    });
  }

  _setInitUser(Transaction trans) {
    _amountController.text = Currency.formatNumber(int.parse(trans.amount));
    _contentController.text = trans.content;
    trans.feeType == 1 ? _isSelectedFee = true : _isSelectedFee = false;
    _recieveAccController.text = trans.receiveAccount;
    _recieveBankController.text = trans.receiveBank;
    _recieveNameController.text = trans.receiveName;
    bankCode = trans.receiveBankCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context)!
            .trans_typeKey(widget.initTrans?.transType ?? widget.tranType)),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: primaryColor,
        // leading: ,
      ),
      body: Stack(
        children: [bodyCKNB(), if (_isLoading) const LoadingCircle()],
      ),
    );
  }

  _getBankReceivingByProduct() async {
    try {
      setState(() => _isLoading = true);
      BaseResponseDataList response = await BankReceiveService()
          .getBankReceivingByProduct(
              TransType.getProductTypeByString(widget.tranType));
      if (response.errorCode == FwError.THANHCONG.value) {
        setState(() {
          listBankReceiving = response.data!
              .map((bankReceive) => BankReceivingModel.fromJson(bankReceive))
              .toList();
        });
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

  _addInitModel() {
    initTrans = Transaction(
        transType: 'MB',
        amount: '',
        content: '${cust.company!.fullname} chuyen khoan',
        fee: '0',
        vat: '0',
        sendAccount: _sendAccController.text,
        receiveAccount: '',
        receiveBank: widget.tranType.compareTo(TransType.CORE.value) == 0
            ? 'Ngân hàng TM TNHH MTV Xây dựng Việt Nam'
            : '',
        receiveName: '',
        receiveBankCode: '',
        type: widget.tranType,
        feeType: 1);

    listTrans.add(initTrans);
  }

  bodyCKNB() {
    return Consumer<SourceAcctnoProvider>(
        builder: (context, sourceAcctnoProvider, child) {
      var accounts = sourceAcctnoProvider.items;
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    renderSourceAccount(accounts),
                    const SizedBox(
                      height: 24,
                    ),
                    renderRevieveInfo(),
                    const SizedBox(
                      height: 24,
                    ),
                    ButtonWidget(
                      text: translation(context)!.continueKey,
                      backgroundColor: primaryColor,
                      haveBorder: false,
                      widthButton: MediaQuery.of(context).size.width,
                      colorText: Colors.white,
                      onPressed: _onPressNextButton,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _onPressNextButton() {
    _saveReciever(currentIndex);
    setState(() {
      _isSubmitted = true;
    });
    if (_isSameTranInfo) {
      _saveSameReciever();
    }
    if (_checkDuplicateAccount()) {
      showDiaLogConfirm(
          content: Text("Thông tin người thụ hưởng trùng lặp"),
          context: context);
    } else {
      if (_formKey.currentState!.validate()) {
        _doTransfer();
      }
    }
  }

  _validateListTran() {
    bool result = true;
    for (var element in listTrans) {
      if (element.amount.isEmpty ||
          element.receiveAccount.isEmpty ||
          element.receiveName.isEmpty ||
          element.receiveBank.isEmpty ||
          element.sendAccount.isEmpty) {
        result = false;
      }
    }
    return result;
  }

  renderTotalAmount() {
    double totalamount = 0;
    for (var item in listTrans) {
      if (item.amount.isNotEmpty) {
        totalamount += int.parse(Currency.removeFormatNumber(item.amount));
      }
    }
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TỔNG TIỀN'),
            Text(
              Currency.formatCurrency(totalamount),
              style: TextStyle(color: primaryColor),
            ),
          ],
        )
      ],
    );
  }

  renderSourceAccount(List<TDDAcount> accounts) {
    return Column(
      children: [
        _questionNote(),
        const SizedBox(
          height: 12,
        ),
        CardLayoutWidget(
            child: Column(
          children: [
            FormControlWidget(
              label: "Tài khoản nguồn",
              child: InputShowBottomSheet(
                controller: _sendAccController,
                hintText: "Chọn tài khoản nguồn",
                bodyWidget: (accounts.isNotEmpty)
                    ? renderListAccount(accounts)
                    : Container(
                        alignment: Alignment.center,
                        child: const Text("No data"),
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Text(
                    "Số dư khả dụng",
                    style: TextStyle(color: colorBlack_727374),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: renderBalance(accounts))
              ],
            ),
          ],
        ))
      ],
    );
  }

  renderBalance(List<TDDAcount> accounts) {
    if (accounts.isNotEmpty) {
      return Text(
        Currency.formatCurrency(accounts[currentIndexAcc].curbalance ?? 0),
        style: const TextStyle(color: primaryColor),
        textAlign: TextAlign.right,
      );
    }
  }

  renderListAccount(List<TDDAcount> accounts) {
    return ListView.builder(
      itemCount: accounts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = accounts[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              _sendAccController.text = item.acctno ?? '';
              currentIndexAcc = index;
              balance = double.parse(item.balance!);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: coloreWhite_EAEBEC))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.acctno ?? '',
                  style: TextStyle(
                    color:
                        (_sendAccController.text.compareTo(item.acctno ?? '') ==
                                0)
                            ? primaryColor
                            : primaryBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                (_sendAccController.text == item.acctno)
                    ? const Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: primaryColor,
                        size: 24,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  renderRecieveBank() {
    return FormControlWidget(
        label: "Ngân hàng thụ hưởng",
        child: InputFormWidget(
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
            controller: _recieveBankController,
            readOnly: true,
            hintText: 'Chọn ngân hàng thụ hưởng',
            showBottomSheetWidget: NganHangThuHuongModal(
              listData: listBankReceiving,
              value: _recieveBankController.text,
              handleSelectedBank: (BankReceivingModel item) {
                setState(() {
                  _recieveBankController.text = item.name;
                  bankCode = item.bankCode ?? '';
                });
              },
            )));
  }

  renderRadioButtonFee() {
    return FormControlWidget(
      label: 'Phí giao dịch',
      child: Column(
        children: [
          RadioListTile<bool>(
            title: const Text('Người chuyển trả'),
            value: true,
            groupValue: _isSelectedFee,
            onChanged: (value) {
              setState(() {
                _isSelectedFee = value!;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          ),
          RadioListTile(
            title: const Text('Người nhận trả'),
            value: false,
            groupValue: _isSelectedFee,
            onChanged: (value) {
              setState(() {
                _isSelectedFee = value!;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          ),
        ],
      ),
    );
  }

  renderCard2() {
    return CardLayoutWidget(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // _renderRecieveListUser(),
          renderRevieveInfo()
        ],
      ),
    );
  }

  _questionNote() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/Question.svg',
          semanticsLabel: "icon question note",
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "Mô tả và lưu ý giao dịch chuyển tiền",
            style: TextStyle(
                color: colorBlack_727374,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
        )
      ],
    );
  }

  Future<void> _doTransfer() async {
    setState(() {
      _isLoading = true;
    });
    String errorMessage = '';
    if (listTrans.length >= 2) {
      if (_validateListTran()) {
        errorMessage = await _doMultipleTrans();
        if (errorMessage.isEmpty) {
          _gotoMultipleScreen(transactionCode);
        }
      } else {
        errorMessage = 'Quý khách vui lòng nhập đầy đủ thông tin các giao dịch';
      }
    } else {
      errorMessage = await _doOneTran();
      if (errorMessage.isEmpty) {
        _gotoSingleScreen(transactionCode);
      }
    }
    if (errorMessage.isNotEmpty) {
      showDiaLogConfirm(content: Text(errorMessage), context: context);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _doOneTran() async {
    try {
      BaseResponse feeResponse =
          _scheduleTransfer ? await _getFeeSchedule() : await _getFee();
      if (feeResponse.errorCode != FwError.THANHCONG.value) {
        return feeResponse.errorMessage!;
      }
      TransfeeResponse transfeeResponse =
          TransfeeResponse.fromJson(feeResponse.data);
      listTrans[0].fee = transfeeResponse.fee;
      listTrans[0].vat = transfeeResponse.vat;
      BaseResponse transCodeResponse =
          await Transaction_Service().getTransCode(widget.tranType, context);
      if (transCodeResponse.errorCode != FwError.THANHCONG.value) {
        return transCodeResponse.errorMessage!;
      }
      transactionCode = transCodeResponse.data;
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  _gotoSingleScreen(transactionCode) {
    SchedulesModel schedulesModel = SchedulesModel(
        schedulesFromDate: _schedulesFromDateController.text,
        schedulesToDate: _schedulesToDateController.text,
        schedulesTimes: _schedulesTimesController.text,
        schedulesFrequency: _schedulesFrequencyController.text,
        schedulesTimesFrequency: _schedulesTimesFrequencyController.text,
        schedules: _isSelectedscheduleTransfer
            ? TransSchedulesEnum.TUONGLAI.value
            : TransSchedulesEnum.DINHKY.value,
        scheduleFuture: _scheduleFutureController.text);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleTransConfirm(
                  isScheduleTransfer: _scheduleTransfer,
                  schedulesModel: schedulesModel,
                  transType: widget.tranType,
                  transCode: transactionCode,
                  transfer: listTrans[0],
                )));
  }

  _checkDuplicateAccount() {
    Set<String> seenValues = <String>{};

    for (var item in listTrans) {
      if (seenValues.contains(item.receiveAccount)) {
        return true;
      }
      seenValues.add(item.receiveAccount);
    }
    return false;
  }

  _mapListFee(BaseResponseDataList feeResponse) {
    List<TransfeeResponse> listTransfee = feeResponse.data!
        .map<TransfeeResponse>((json) => TransfeeResponse.fromJson(json))
        .toList();
    for (int i = 0; i < listTrans.length; i++) {
      TransfeeResponse transfeeResponse =
          listTransfee.firstWhere((element) => element.stt == i);
      listTrans[i].fee = transfeeResponse.fee;
      listTrans[i].vat = transfeeResponse.vat;
    }
  }

  Future<String> _doMultipleTrans() async {
    try {
      if (_formKey.currentState!.validate()) {
        BaseResponseDataList feeResponse = await _getListFee();
        if (feeResponse.errorCode != FwError.THANHCONG.value) {
          return feeResponse.errorMessage!;
        }
        _mapListFee(feeResponse);
        BaseResponse transCodeResponse =
            await Transaction_Service().getTransCode(widget.tranType, context);
        if (transCodeResponse.errorCode != FwError.THANHCONG.value) {
          return transCodeResponse.errorMessage!;
        }
        transactionCode = transCodeResponse.data;
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  _gotoMultipleScreen(transCodeResponse) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MultipleTransConfirm(
                  listTrans: listTrans,
                  transType: widget.tranType,
                  transCode: transCodeResponse,
                )));
  }

  Future<BaseResponseDataList> _getListFee() async {
    List<TransfeeRequest> request = [];
    for (int i = 0; i < listTrans.length; i++) {
      TransfeeRequest item = TransfeeRequest(
          stt: i,
          amount: listTrans[i].amount,
          feeType: listTrans[i].feeType.toString(),
          type: widget.tranType);

      request.add(item);
    }
    return await Transaction_Service().getListFee(request);
  }

  Future<BaseResponse> _getFee() {
    TransfeeRequest transfeeRequest = TransfeeRequest(
        amount: _amountController.text,
        feeType: listTrans[0].feeType.toString(),
        type: widget.tranType,
        stt: null);
    return Transaction_Service().getFee(transfeeRequest);
  }

  Future<BaseResponse> _getFeeSchedule() {
    TransfeeScheduleRequest request;
    if (_isSelectedscheduleTransfer) {
      request = _getRequesteFeeTL();
    } else {
      request = _getRequestFeeDK();
    }
    return Transaction_Service().getFeeSchedule(request);
  }

  TransfeeScheduleRequest _getRequestFeeDK() {
    TransfeeScheduleRequest transfeeRequest = TransfeeScheduleRequest(
      amount: _amountController.text,
      feeType: listTrans[0].feeType.toString(),
      type: widget.tranType,
      schedules: TransSchedulesEnum.DINHKY.value.toString(),
      schedulesFrequency: _schedulesFrequencyController.text,
      schedulesTime: int.parse(_schedulesTimesController.text),
      schedulesTimesFrequency:
          int.tryParse(_schedulesTimesFrequencyController.text),
      schedulesFromDate: _schedulesFromDateController.text,
      schedulesToDate: _schedulesToDateController.text,
    );
    return transfeeRequest;
  }

  TransfeeScheduleRequest _getRequesteFeeTL() {
    TransfeeScheduleRequest transfeeRequest = TransfeeScheduleRequest(
      amount: _amountController.text,
      feeType: listTrans[0].feeType.toString(),
      type: widget.tranType,
      schedules: TransSchedulesEnum.TUONGLAI.value.toString(),
      scheduleFuture: _scheduleFutureController.text,
    );
    return transfeeRequest;
  }

  _getRecieveName() async {
    setState(() {
      _isLoading = true;
    });
    BaseResponse response =
        await Transaction_Service().getNameByAcc(_recieveAccController.text);
    setState(() {
      _isLoading = false;
    });
    if (response.errorCode == FwError.THANHCONG.value) {
      if (mounted) {
        setState(() {
          _recieveNameController.text = response.data["fullname"];
        });
      }
    } else {
      _recieveNameController.clear();
      if (mounted) {
        showDiaLogConfirm(
            content: Text('Tên người thụ hưởng không tồn tại'),
            context: context);
      }
    }
  }

  _getRecieveNameNapas() async {
    setState(() => _isLoading = true);
    try {
      BaseResponse response = await Transaction_Service().getNameByAccNapas(
          _recieveAccController.text, _sendAccController.text, bankCode);
      setState(() {});
      if (response.errorCode == FwError.THANHCONG.value) {
        setState(() {
          _recieveNameController.text = response.data["fullname"];
        });
      } else {
        _recieveNameController.clear();
        showDiaLogConfirm(
            content: Text('Số tài khoản thụ hưởng không tồn tại'),
            context: context);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  renderRowIconsReciever() {
    if (listTrans.length >= 2) {
      return Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < listTrans.length; i++)
                InkWell(
                    onTap: () {
                      _saveReciever(currentIndex);
                      currentIndex = i;
                      _setReciever(i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: Container(
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
                    ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              setState(() {
                listTrans.removeLast();
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Người nhận ${currentIndex + 1}',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          )
        ],
      );
    }
    return Container();
  }

  _saveReciever(index) {
    if (index < listTrans.length) {
      Transaction newModel = Transaction(
          amount: _amountController.text,
          content: _contentController.text,
          fee: '0',
          sendAccount: _sendAccController.text,
          receiveAccount: _recieveAccController.text,
          receiveBank: _recieveBankController.text,
          receiveName: _recieveNameController.text,
          type: widget.tranType,
          feeType: _isSelectedFee ? 1 : 2,
          receiveBankCode: bankCode,
          transType: "MB",
          vat: '0');
      listTrans[index] = newModel;
    }
  }

  _setReciever(index) {
    setState(() {
      if (!_isSameTranInfo) {
        _amountController.text = listTrans[index].amount;
        _contentController.text = listTrans[index].content;
        listTrans[index].feeType == 1
            ? _isSelectedFee = true
            : _isSelectedFee = false;
      }
      _recieveAccController.text = listTrans[index].receiveAccount;
      _recieveBankController.text = listTrans[index].receiveBank;
      _recieveNameController.text = listTrans[index].receiveName;
    });
  }

  renderRevieveInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderRecieveListUser(),
        const SizedBox(
          height: 10,
        ),
        renderRowIconsReciever(),
        const SizedBox(
          height: 20,
        ),
        if (widget.tranType != TransType.CORE.value) ...[
          renderRecieveBank(),
          const SizedBox(
            height: 20,
          )
        ],
        renderRecieveAccount(),
        const SizedBox(
          height: 20,
        ),
        renderRecieveName(),
        const SizedBox(
          height: 20,
        ),
        if (listTrans.length >= 2) renderSwitchTrans(),
        renderAmount(),
        const SizedBox(
          height: 10,
        ),
        renderReadAmout(Currency.removeFormatNumber(amount)),
        const SizedBox(
          height: 10,
        ),
        renderRadioButtonFee(),
        const SizedBox(
          height: 10,
        ),
        _renderContent(),
        const SizedBox(
          height: 20,
        ),
        renderSwitchButton(),
        if (listTrans.length >= 2) renderTotalAmount(),
        _scheduleTransfer ? renderScheduleTransfer() : const SizedBox(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  renderSwitchTrans() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Thông tin giao dịch giống nhau",
              style: TextStyle(
                color: colorBlack_727374,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Switch(
              value: _isSameTranInfo,
              onChanged: (value) {
                if (value) {
                  showImportantNoti(context,
                      content:
                          'Khi chọn chức năng này, thông tin giao dịch bao gồm: Số tiền, nội dung, loại phí sẽ được cập nhật giống nhau cho tất cả người dùng',
                      func: _setSameInfoCallBack);
                } else {
                  setState(() {
                    _isSameTranInfo = false;
                  });
                }
              },
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _setSameInfoCallBack() {
    setState(() {
      _saveSameReciever();
      _isSameTranInfo = true;
      Navigator.of(context).pop();
    });
  }

  _scheduleTransferCallBack() {
    setState(() {
      _scheduleTransfer = true;
      listTrans.clear();
      Navigator.of(context).pop();
    });
  }

  _saveSameReciever() {
    for (var element in listTrans) {
      element.amount = _amountController.text;
      element.content = _contentController.text;
      element.feeType = _isSelectedFee ? 1 : 2;
    }
  }

  renderReadAmout(String amount) {
    if (amount.isNotEmpty) {
      return Text(
        Currency.numberToWords(int.parse(amount)),
        style: const TextStyle(color: primaryColor),
      );
    }
    return Container();
  }

  renderRecieveName() {
    return FormControlWidget(
      label: "Tên người thụ hưởng",
      child: TextFieldWidget(
        readOnly: widget.tranType == TransType.CITAD.value ? false : true,
        onTapInput: widget.tranType == TransType.CITAD.value ? null : () {},
        controller: _recieveNameController,
        hintText: widget.tranType == TransType.CITAD.value
            ? "Nhập tên người thụ hưởng"
            : '',
        validator: (value) {
          if (value.isEmpty && _isSubmitted) {
            return 'Vui lòng nhập tên người thụ hưởng';
          }
          return null;
        },
      ),
    );
  }

  _renderContent() {
    return FormControlWidget(
      label: "Nội dung",
      child: TextFieldWidget(
        textInputType: TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
        ],
        maxLength: 300,
        maxLines: 3,
        controller: _contentController,
        hintText: "Nhập nội dung chuyển tiền",
      ),
    );
  }

  renderSwitchButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Đặt lịch chuyển khoản",
          style: TextStyle(
            color: colorBlack_727374,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: _scheduleTransfer,
          onChanged: (value) {
            if (listTrans.length >= 2) {
              if (value) {
                showImportantNoti(context,
                    content:
                        'Đặt lịch chuyển tiền chỉ áp dụng cho chuyển tiền tới 01 người thụ hưởng. Quý khách có muốn ${translation(context)!.continueKey} đặt lịch không?',
                    func: _scheduleTransferCallBack);
              }
            } else {
              setState(() {
                _scheduleTransfer = value;
              });
            }
          },
        )
      ],
    );
  }

  renderScheduleTransfer() {
    return Column(
      children: [
        RadioListTile<bool>(
          title: const Text(
            'Chuyển tiền tương lai',
          ),
          value: true,
          groupValue: _isSelectedscheduleTransfer,
          onChanged: (value) {
            setState(() {
              _isSelectedscheduleTransfer = value!;
            });
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
        RadioListTile(
          title: const Text('Chuyển tiền định kỳ'),
          value: false,
          groupValue: _isSelectedscheduleTransfer,
          onChanged: (value) {
            setState(() {
              _isSelectedscheduleTransfer = value!;
            });
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
        ScheduleTransfer(
          schedual: _isSelectedscheduleTransfer,
          scheduleFuture: _scheduleFutureController,
          schedulesToDate: _schedulesToDateController,
          schedulesFromDate: _schedulesFromDateController,
          schedulesTimesFrequency: _schedulesTimesFrequencyController,
          schedulesFrequency: _schedulesFrequencyController,
          schedulesTimes: _schedulesTimesController,
        )
      ],
    );
  }

  renderRecieveAccount() {
    return FormControlWidget(
      label: "Số tài khoản thụ hưởng",
      child: TextFieldWidget(
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/danh_ba.svg',
            // ignore: deprecated_member_use
            color: _focusBankAccount.hasFocus ? null : colorBlack_727374,
          ),
          onPressed: () {
            _showBottomSheet(context);
          },
        ),
        validator: (value) {
          if (value.isEmpty && _isSubmitted) {
            return 'Vui lòng nhập số tài khoản thụ hưởng';
          }
          return null;
        },
        onSubmitted: (value) {},
        controller: _recieveAccController,
        hintText: "Nhập số tài khoản khoản thụ hưởng",
        focusNode: _focusBankAccount,
        textInputType: TextInputType.number,
      ),
    );
  }

  renderRecieveListUser() {
    return InkWell(
        onTap: () {
          setState(() {
            if (listTrans.length < 3) {
              _scheduleTransfer = false;
              _addInitModel();
            }
          });
        },
        child: Row(
          children: const [
            Text(
              'Thêm người thụ hưởng',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.add_circle,
              color: primaryColor,
            )
          ],
        ));
  }

  renderAmount() {
    return FormControlWidget(
      label: "Số tiền",
      child: TextFieldWidget(
        suffixText: 'VND',
        onSubmitted: (value) {},
        validator: (value) {
          if (value.isNotEmpty &&
              double.parse(Currency.removeFormatNumber(value)) > balance) {
            return 'Số dư không đủ để thực hiện giao dịch.';
          }
          if (value.isEmpty && _isSubmitted) {
            return 'Vui lòng nhập số tiền.';
          }
          return null;
        },
        onChange: (value) {
          setState(() {
            amount = value;
          });
          if (value.isNotEmpty) {
            final intValue = int.parse(value);
            final formattedValue = Currency.formatNumber(intValue);
            _amountController.value = _amountController.value.copyWith(
              text: formattedValue,
              selection: TextSelection.collapsed(offset: formattedValue.length),
            );
          }
        },
        controller: _amountController,
        hintText: "Nhập số tiền",
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(13),
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        // isDismissible: true,
        // isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Constacts(
              callback: (CustContact item) {
                setState(() {
                  bankCode = item.bankReceiving?.bankCode ?? "";
                });
              },
              transType: widget.tranType,
              recieveAccController: _recieveAccController,
              recieveBankController: _recieveBankController,
              recieveNameController: _recieveNameController,
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _sendAccController.dispose();
    _recieveAccController.dispose();
    _recieveNameController.dispose();
    _contentController.dispose();
    _recieveBankController.dispose();
    _chiNhanhController.dispose();
    _amountController.dispose();
    _transFeeController.dispose();
    _schedulesFromDateController.dispose();
    _schedulesToDateController.dispose();
    _scheduleFuture.dispose();
    _schedulesFrequencyController.dispose();
    _schedulesTimesController.dispose();
    _schedulesTimesFrequencyController.dispose();
  }
}
