// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/model/JsonSerializable_model/tranSaveContact/trans_save_contact_request.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/cust_contact_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

import '../../common/form/form_control.dart';
import '../../common/form_input_and_label/text_field.dart';
import '../../enum/enum.dart';

class SaveContacts extends StatefulWidget {
  final TransSaveContactRequest request;
  const SaveContacts({super.key, required this.request});

  @override
  State<SaveContacts> createState() => _SaveContactsState();
}

class _SaveContactsState extends State<SaveContacts> {
  final _recieveAccController = TextEditingController();
  final _recieveNameController = TextEditingController();
  final _sortNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _recieveAccController.text = widget.request.receiveAccount;
    _recieveNameController.text = widget.request.receiveName;
    _sortNameController.text = widget.request.receiveName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Đặt độ cong cho border
      ),
      title: const Text(
        'Lưu danh bạ thụ hưởng',
        style: TextStyle(color: primaryColor),
        textAlign: TextAlign.center,
      ),
      content: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .9,
            height: 230,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _renderField('Số tài khoản', _recieveAccController, false),
                const SizedBox(
                  height: 10,
                ),
                _renderField(
                    'Tên người thụ hưởng', _recieveNameController, false),
                const SizedBox(
                  height: 10,
                ),
                _renderField('Tên gọi nhớ', _sortNameController, true),
              ],
            ),
          ),
          if (_isLoading)
            SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                height: 230,
                child: const LoadingCircle())
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Lưu lại'),
          onPressed: () async {
            await _saveContract();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _renderField(label, controller, enable) {
    return FormControlWidget(
      label: label,
      child: TextFieldWidget(
        onSubmitted: (value) {},
        controller: controller,
        hintText: "",
        enabled: enable,
      ),
    );
  }

  _saveContract() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      TransSaveContactRequest request = TransSaveContactRequest(
          product: widget.request.product,
          bankReceiving: widget.request.bankReceiving,
          receiveName: widget.request.receiveName,
          receiveAccount: widget.request.receiveAccount,
          sortname: _sortNameController.text);
      BaseResponse response =
          await CusContactService().saveCustContactTrans(request);
      if (!mounted) return;
      if (response.errorCode == FwError.THANHCONG.value) {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.green,
            icon: const Icon(Icons.check));
      } else {
        showToast(
            context: context,
            msg: response.errorMessage!,
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
