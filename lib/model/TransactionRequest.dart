// ignore_for_file: file_names

class SchedulesModel {
  final int schedules;
  final String scheduleFuture;
  final String schedulesFromDate;
  final String schedulesToDate;
  final String schedulesTimes;
  final String schedulesFrequency;
  final String schedulesTimesFrequency;

  SchedulesModel(
      {required this.schedulesFromDate,
      required this.schedulesToDate,
      required this.schedulesTimes,
      required this.schedulesFrequency,
      required this.schedulesTimesFrequency,
      required this.schedules,
      required this.scheduleFuture});
}

class TranSchedule {
  late String? amount;
  late String? content;
  late String? fee;
  late String? vat;
  late String? sendAccount;
  late String? receiveAccount;
  late String? receiveBank;
  late String? receiveName;
  late String? type;
  late int? feeType; //1 nguoi chuyen tra ,2 nguoi nhan tra
  late int? schedules; //1 dinh ky, 0 tuong lai
  late String? scheduleFuture;
  late String? schedulesFromDate;
  late String? schedulesToDate;
  late String? schedulesTimes;
  late String? schedulesFrequency;
  late String? schedulesTimesFrequency;
  late String transType;
  TranSchedule(
      {required this.amount,
      required this.content,
      required this.fee,
      required this.vat,
      required this.sendAccount,
      required this.receiveAccount,
      required this.receiveBank,
      required this.receiveName,
      required this.type,
      required this.feeType,
      required this.schedules,
      required this.scheduleFuture,
      required this.schedulesFromDate,
      required this.schedulesToDate,
      required this.schedulesTimes,
      required this.schedulesFrequency,
      required this.schedulesTimesFrequency,
      required this.transType});

  Map<String, dynamic> toJson() {
    if (schedules == 0) {
      return {
        'amount': amount,
        'content': content,
        'fee': fee,
        'vat': vat,
        'sendAccount': sendAccount,
        'receiveAccount': receiveAccount,
        'receiveBank': receiveBank,
        'receiveName': receiveName,
        'type': type,
        'feeType': feeType,
        'schedules': schedules,
        'scheduleFuture': scheduleFuture,
        'transType': transType
      };
    } else {
      return {
        'amount': amount,
        'content': content,
        'fee': fee,
        'vat': vat,
        'sendAccount': sendAccount,
        'receiveAccount': receiveAccount,
        'receiveBank': receiveBank,
        'receiveName': receiveName,
        'type': type,
        'feeType': feeType,
        'schedules': schedules,
        'schedulesFromDate': schedulesFromDate,
        'schedulesToDate': schedulesToDate,
        'schedulesTimes': schedulesTimes,
        'schedulesFrequency': schedulesFrequency,
        'schedulesTimesFrequency': schedulesTimesFrequency,
        'transType': transType
      };
    }
  }
}

class TranScheduleRequest {
  late String? otp;
  late String? code;
  late TranSchedule data;

  TranScheduleRequest(
      {required this.otp, required this.code, required this.data});

  Map<String, dynamic> toJson() {
    return {'otp': otp, 'code': code, 'data': data.toJson()};
  }
}
