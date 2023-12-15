import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/text_field.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/cust_contact.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/cust_contact_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

class SaveContactsManager extends StatefulWidget {
  final CustContact request;
  const SaveContactsManager({super.key, required this.request});

  @override
  State<SaveContactsManager> createState() => _SaveContactsManagerState();
}

class _SaveContactsManagerState extends State<SaveContactsManager> {
  final TextEditingController _recieveAccController = TextEditingController();
  final TextEditingController _recieveNameController = TextEditingController();
  final TextEditingController _sortNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recieveAccController.text = widget.request.receiveAccount!;
    _recieveNameController.text = widget.request.receiveName!;
    _sortNameController.text = widget.request.receiveName!;
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
      content: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _renderField('Số tài khoản', _recieveAccController, false),
            const SizedBox(
              height: 10,
            ),
            _renderField('Tên người thụ hưởng', _recieveNameController, false),
            const SizedBox(
              height: 10,
            ),
            _renderField('Tên gọi nhớ', _sortNameController, true),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.zero,
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () {
            // Do something when the "Cancel" button is pressed
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Lưu lại'),
          onPressed: () {
            // Do something when the "OK" button is pressed
            _saveContract();
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
    CustContact request = CustContact(
        product: widget.request.product,
        bankReceiving: widget.request.bankReceiving,
        receiveName: widget.request.receiveName,
        receiveAccount: widget.request.receiveAccount,
        sortname: _sortNameController.text);
    BaseResponse response = await CusContactService().saveCustContact(request);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }
}
