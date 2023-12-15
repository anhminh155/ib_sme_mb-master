class RolesAcc {
  String? type;
  int? search;
  int? position;
  int? tran;
  int? approve;
  List<Functions>? function;

  RolesAcc(
      {this.position,
      this.search,
      this.tran,
      this.type,
      this.function,
      this.approve});
  factory RolesAcc.fromJson(Map<String, dynamic> json) {
    return RolesAcc(
      type: json['type'],
      search: json['search'],
      position: json['position'],
      tran: json['tran'],
      approve: json['approve'],
      function: json['function'] != null
          ? List<Functions>.from(json['function']
              .map((x) => Functions.fromJson(x))) // Chuyển đổi list kho từ JSON
          : null,
    );
  }
  Map<String, dynamic> toJson() => {
        'type': type,
        'search': search,
        'position': position,
        'tran': tran,
        'funtion': function,
        'approve': approve
      };
}

class Functions {
  String? subFunction;
  List<double>? cust;

  Functions({this.subFunction, this.cust});
  factory Functions.fromJson(Map<String, dynamic> json) {
    return Functions(
      subFunction: json['subfunction'],
      cust: (json['cust'] as List<dynamic>?)?.cast<double>(),
    );
  }
  Map<String, dynamic> toJson() => {
        'subfunction': subFunction,
        'cust': cust,
      };
}
