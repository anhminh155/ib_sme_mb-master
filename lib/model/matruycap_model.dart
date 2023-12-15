class MaTruyCapModel {
  final int id;
  final String accessCode;
  final String roles;
  final String numberPhone;
  final String email;
  final int status; // 1: hoạt động - 2: Khóa - 0: Hủy;
  final int smsBanking; // 1: Bật - 0: tắt;
  final int balanceNoties; // 1: Bật - 0: tắt

  const MaTruyCapModel(
      {required this.id,
      required this.accessCode,
      required this.roles,
      required this.numberPhone,
      required this.email,
      required this.status,
      required this.smsBanking,
      required this.balanceNoties});
}

const List<MaTruyCapModel> listMaTruyCapModel = [
  MaTruyCapModel(
      id: 1,
      accessCode: "0123456789TL01",
      roles: "Mã lập lệnh",
      numberPhone: '0123456789',
      email: "abcdefgh@gmail.com",
      status: 1,
      smsBanking: 1,
      balanceNoties: 1),
  MaTruyCapModel(
      id: 2,
      accessCode: "0123456789TL02",
      roles: "Mã lập lệnh",
      numberPhone: '0123456700',
      email: "abcdefgh1@gmail.com",
      status: 2,
      smsBanking: 0,
      balanceNoties: 1),
  MaTruyCapModel(
      id: 3,
      accessCode: "0123456789TL03",
      roles: "Mã lập lệnh",
      numberPhone: '0123456789',
      email: "abcdefgh@gmail.com",
      status: 0,
      smsBanking: 0,
      balanceNoties: 1),
  MaTruyCapModel(
      id: 4,
      accessCode: "0123456789DL01",
      roles: "Mã duyệt lệnh",
      numberPhone: '0123456789',
      email: "abcdefgh@gmail.com",
      status: 1,
      smsBanking: 1,
      balanceNoties: 1),
  MaTruyCapModel(
      id: 5,
      accessCode: "0123456789DL02",
      roles: "Mã duyệt lệnh",
      numberPhone: '0123456700',
      email: "abcdefgh1@gmail.com",
      status: 2,
      smsBanking: 0,
      balanceNoties: 1),
  MaTruyCapModel(
      id: 6,
      accessCode: "0123456789DL03",
      roles: "Mã duyệt lệnh",
      numberPhone: '0123456789',
      email: "abcdefgh@gmail.com",
      status: 0,
      smsBanking: 0,
      balanceNoties: 1),
];
