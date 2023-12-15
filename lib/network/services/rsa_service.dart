// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:ib_sme_mb_view/config/config.dart';
import 'package:ib_sme_mb_view/model/payload.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'dart:convert';

import 'package:pointycastle/export.dart' as pointycastle;
import 'package:basic_utils/basic_utils.dart';

class Rsa {
  pointycastle.RSASigner getRsaSah512Signer() {
    // RSA (SHA512)
    //https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
    return pointycastle.RSASigner(SHA512Digest(), '0609608648016503040203');
  }

  static pointycastle.RSASigner getRsaSah256Signer() {
    // RSA (SHA512)
    //https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
    return pointycastle.RSASigner(SHA256Digest(), '0609608648016503040201');
  }

  static Uint8List signature(String message, String masterPrivateKey) {
    // final signer = getRsaSah512Signer();
    final signer = getRsaSah256Signer();
    final key = RSAKeyParser().parse(masterPrivateKey) as RSAPrivateKey;
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(key));
    // Convert string : message to byte: dataToSign
    final Uint8List dataToSign = Uint8List.fromList(utf8.encode(message));
    return signer.generateSignature(dataToSign).bytes;
  }

  static String signature64(String message, String masterPrivateKey) {
    return base64Url.encode(signature(message, masterPrivateKey));
  }

  bool verifySignature(
      String message, String signature64, String masterPublicKey) {
    final signer = getRsaSah512Signer();
    final key = RSAKeyParser().parse(masterPublicKey) as RSAPublicKey;
    signer.init(false, PublicKeyParameter<RSAPublicKey>(key));
    // Convert string : message to byte: dataToSign
    final Uint8List dataToSign = Uint8List.fromList(utf8.encode(message));
    return signer.verifySignature(
        dataToSign, RSASignature(base64.decode(signature64)));
  }

  String decrypt64(String encrypted64, String masterPrivateKey) {
    final key = RSAKeyParser().parse(masterPrivateKey) as RSAPrivateKey;
    Encrypter encrypter = Encrypter(RSA(privateKey: key));
    return encrypter.decrypt64(encrypted64);
  }

  String encrypt64(String message, String masterPublicKey) {
    final key = RSAKeyParser().parse(masterPublicKey) as RSAPublicKey;
    Encrypter encrypter = Encrypter(RSA(publicKey: key));
    return encrypter.encrypt(message).base64;
  }

  String encrypt64Frombyte(List<int> message, String masterPublicKey) {
    final key = RSAKeyParser().parse(masterPublicKey) as RSAPublicKey;
    Encrypter encrypter = Encrypter(RSA(publicKey: key));
    return encrypter.encryptBytes(message).base64;
  }

  String aesDecrypt(String encrypted64, String key64, String iv64) {
    final key = Key.fromBase64(key64);
    final iv = IV.fromBase64(iv64);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    return hex.encode(
        encrypter.decryptBytes(Encrypted.fromBase64(encrypted64), iv: iv));
  }

  String createOtp(
      String ocraSuite, String keyI, String transactionCode, String password) {
    if (ocraSuite == null || ocraSuite.split(":").length < 2) {
      return '';
    }
    String counter = "";
    String timeStamp = "";
    String sessionInformation = "";
    String cryptoFunction = ocraSuite.split(":")[1];
    String dataInput = ocraSuite.split(":")[2];
    var timeDiv = 60000;
    if (dataInput.toLowerCase().startsWith("t") ||
        (dataInput.toLowerCase().indexOf("-t") > 1)) {
      RegExp exp = RegExp(r't([0-9]{1,2})([SMH])', caseSensitive: false);
      RegExpMatch? timeDivMatch = exp.firstMatch(dataInput);

      if (timeDivMatch != null) {
        timeDiv = int.parse(timeDivMatch[1]!);
        timeDiv = timeDiv * 60;
        timeDiv = timeDiv * 1000;
        // switch (timeDivMatch[2]) {
        //   case 'H':
        //     timeDiv = timeDiv * 60;
        //     break;
        //   case 'M':
        //     timeDiv = timeDiv * 60;
        //     break;
        //   case 'S':
        //     timeDiv = timeDiv * 1000;
        // }
      }
    }
    DateTime now = DateTime.now();
    timeStamp = (now.millisecondsSinceEpoch / timeDiv).ceil().toRadixString(16);
    var msgHex = "${hex.encode(ocraSuite.codeUnits)}00";
    // Counter
    if (dataInput.toLowerCase().startsWith("c")) {
      // Fix the length of the HEX string
      while (counter.length < 16) {
        counter = "0$counter";
      }
      msgHex = msgHex + counter;
    }

    // Question - always 128 bytes
    if (dataInput.toLowerCase().startsWith("q") ||
        (dataInput.toLowerCase().contains("-q"))) {
      if (transactionCode == null) return '';
      var question = hex.encode(transactionCode.codeUnits);
      while (question.length < 256) {
        question = "${question}0";
      }
      msgHex = msgHex + question;
    }

    // Password - sha1
    if (dataInput.toLowerCase().indexOf("psha1") > 1) {
      if (password == null) return '';
      var passwordFullSize = password;
      while (passwordFullSize.length < 40) {
        passwordFullSize = "0$passwordFullSize";
      }
      msgHex = msgHex + passwordFullSize;
    }
    // Password - sha256
    if (dataInput.toLowerCase().indexOf("psha256") > 1) {
      if (password == null) return '';
      var passwordFullSize = password;
      while (passwordFullSize.length < 64) {
        passwordFullSize = "0$passwordFullSize";
      }
      msgHex = msgHex + passwordFullSize;
    }

    // Password - sha512
    if (dataInput.toLowerCase().indexOf("psha512") > 1) {
      if (password == null) return '';
      var passwordFullSize = password;
      while (passwordFullSize.length < 128) {
        passwordFullSize = "0$passwordFullSize";
      }
      msgHex = msgHex + passwordFullSize;
    }

    // sessionInformation - s064
    if (dataInput.toLowerCase().indexOf("s064") > 1) {
      while (sessionInformation.length < 128) {
        sessionInformation = "0$sessionInformation";
      }
      msgHex = msgHex + sessionInformation;
    }

    // sessionInformation - s128
    if (dataInput.toLowerCase().indexOf("s128") > 1) {
      while (sessionInformation.length < 256) {
        sessionInformation = "0$sessionInformation";
      }
      msgHex = msgHex + sessionInformation;
    }

    // sessionInformation - s256
    if (dataInput.toLowerCase().indexOf("s256") > 1) {
      while (sessionInformation.length < 512) {
        sessionInformation = "0$sessionInformation";
      }
      msgHex = msgHex + sessionInformation;
    }

    // sessionInformation - s512
    if (dataInput.toLowerCase().indexOf("s512") > 1) {
      while (sessionInformation.length < 1024) {
        sessionInformation = "0$sessionInformation";
      }
      msgHex = msgHex + sessionInformation;
    }

    // TimeStamp
    if (dataInput.toLowerCase().startsWith("t") ||
        (dataInput.toLowerCase().indexOf("-t") > 1)) {
      while (timeStamp.length < 16) {
        timeStamp = "0$timeStamp";
      }
      msgHex = msgHex + timeStamp;
    }

    var msg = hex.decode(msgHex);
    var key = hex.decode(keyI);
    Uint8List hash;
    var hmac = pointycastle.HMac(pointycastle.SHA1Digest(), 64);

    if (cryptoFunction.toLowerCase().indexOf("sha256") > 1) {
      hmac = pointycastle.HMac(pointycastle.SHA256Digest(),
          64); // for HMAC SHA-256, block length must be 64
    }
    if (cryptoFunction.toLowerCase().indexOf("sha512") > 1) {
      hmac = pointycastle.HMac(pointycastle.SHA512Digest(),
          128); // for HMAC SHA-512, block length must be 128
    }
    hmac.init(KeyParameter(
        Uint8List.fromList(key))); // for HMAC SHA-1, block length must be 64
    hash = hmac.process(Uint8List.fromList(msg));
    var hashHex = hex.encode(hash);
    var offset =
        int.parse(hashHex.substring(hashHex.length - 2), radix: 16) & 0xf;

    var hashOffsetBytes = [
      int.parse(hashHex.substring((offset + 0) * 2, (offset + 1) * 2),
          radix: 16),
      int.parse(hashHex.substring((offset + 1) * 2, (offset + 2) * 2),
          radix: 16),
      int.parse(hashHex.substring((offset + 2) * 2, (offset + 3) * 2),
          radix: 16),
      int.parse(hashHex.substring((offset + 3) * 2, (offset + 4) * 2),
          radix: 16),
    ];
    var binary = ((hashOffsetBytes[0] & 0x7f) << 24) |
        ((hashOffsetBytes[1] & 0xff) << 16) |
        ((hashOffsetBytes[2] & 0xff) << 8) |
        (hashOffsetBytes[3] & 0xff);
    var otp = binary.toString();
    var codeDigits = 0;
    codeDigits = int.parse(
        cryptoFunction.substring(cryptoFunction.lastIndexOf("-") + 1));
    if (otp.length > codeDigits) {
      otp = otp.substring(otp.length - codeDigits);
    }
    while (otp.length < codeDigits) {
      otp = "0$otp";
    }

    return otp;
  }

  String sha256Convert(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String decryptAES(String encryptedBase64, String password) {
    final hash = sha1.convert(utf8.encode(password));
    List<int> byteList = List<int>.from(hash.bytes.sublist(0, 16));
    final key = Uint8List.fromList(byteList);
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    final decrypter = Encrypter(AES(Key(key), mode: AESMode.ecb));
    final decrypted = decrypter.decrypt(encrypted, iv: IV.fromLength(16));
    return decrypted;
  }

  static Payload encryptAES(request, password) {
    var message = jsonEncode(request);
    final hash = sha1.convert(utf8.encode(password));
    List<int> byteList = List<int>.from(hash.bytes.sublist(0, 16));
    final key = Uint8List.fromList(byteList);
    final decrypter = Encrypter(AES(Key(key), mode: AESMode.ecb));
    final d = decrypter.encrypt(message, iv: IV.fromLength(16)).base64;
    final e = signature64(d, masterPrivateKey);
    return Payload(d: d, e: e);
  }
}
