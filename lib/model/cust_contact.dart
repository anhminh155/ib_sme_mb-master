import 'models.dart';

class CustContact {
  final int? id;
  final int? product;
  final String? receiveAccount;
  final BankReceivingModel? bankReceiving;
  final String? sortname;
  final String? receiveName;

  const CustContact(
      {this.id,
      this.product,
      this.receiveAccount,
      this.bankReceiving,
      this.sortname,
      this.receiveName});

  factory CustContact.fromJson(Map<String, dynamic> json) {
    return CustContact(
        id: json['id'],
        product: json['product'],
        receiveAccount: json['receiveAccount'],
        bankReceiving: json['bankReceiving'] != null
            ? BankReceivingModel.fromJson(json['bankReceiving'])
            : null,
        sortname: json['sortname'],
        receiveName: json['receiveName']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['receiveAccount'] = receiveAccount;
    data['bankReceiving'] = bankReceiving!.toJson();
    data['sortname'] = sortname;
    data['receiveName'] = receiveName;
    return data;
  }
}
