// To parse this JSON data, do
//
//     final payload = payloadFromJson(jsonString);

class Payload {
  String d;
  String? e;

  Payload({
    required this.d,
    required this.e,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        d: json["d"],
        e: json["e"],
      );

  Map<String, dynamic> toJson() => {
        "d": d,
        "e": e,
      };
}
