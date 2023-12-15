import 'dart:convert';

import 'package:ib_sme_mb_view/config/config.dart';
import 'package:ib_sme_mb_view/model/payload.dart';
import 'package:ib_sme_mb_view/network/services/rsa_service.dart';

class GatewayService {
  static String password = keyDecryptAESPassword;
  static decryptAES(String response) {
    var mapPayload = json.decode(response);
    Payload payload = Payload.fromJson(mapPayload);
    var decrypted = Rsa.decryptAES(payload.d, password);
    return json.decode(decrypted);
  }

  static String encryptAES(request) {
    return json.encode(Rsa.encryptAES(request, password));
  }
}
