// ignore_for_file: constant_identifier_names

library api;

import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/config/config.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/network/services/gateway_service.dart';
import 'package:ib_sme_mb_view/page/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:ib_sme_mb_view/utils/getDeviceInfo.dart';
import 'dart:developer' as dev;

import '../../model/model.dart';
import '../../utils/navigator_model.dart';

class Api {
  static const String CONTENT_TYPE_APPLICATON_JSON = 'application/json';
  static const String HEADER_CONTENT_TYPE = 'content-type';
  static const String LANGUAGE_CODE = 'language';
  static const String HEADER_AUTHORIZATION = 'Authorization';
  static HttpClientRequest? _latestRequest;

  static getAuthorization() {
    final localUser = localStorage.getItem('currentUser');
    if (localUser != null) {
      LoginResponse currentUser = LoginResponse.fromJson(localUser);
      final token = currentUser.token;
      final type = currentUser.type;
      return "$type $token";
    }
    return "";
  }

  static Map<String, String> getCommonHeaders() {
    Map<String, String> headers = {};
    final languageCode = localStorage.getItem('language_code');
    headers[HEADER_CONTENT_TYPE] = CONTENT_TYPE_APPLICATON_JSON;
    headers[LANGUAGE_CODE] = languageCode?.toUpperCase() ?? "VI";
    String authorization = getAuthorization();
    if (authorization.isNotEmpty) {
      headers[HEADER_AUTHORIZATION] = authorization;
    }
    return headers;
  }

  static Future<LoginResponse?> login(LoginRequest loginRequest) async {
    await Firebase.initializeApp();
    var deviceInfo = await DeviceUtils.getDeviceInfo();

    String? token = await FirebaseMessaging.instance.getToken();
    dev.log(token.toString());
    var device = {
      "modelId": deviceInfo.devModelId,
      "manufacturer": deviceInfo.devManufacturer,
      "systemName": deviceInfo.devSystemName,
      "systemVersion": deviceInfo.devSystemVersion,
      "emulator": deviceInfo.devEmulator ? "Y" : "N",
      "firebaseToken": token,
    };
    loginRequest.device = device;
    var finalRequestBody = GatewayService.encryptAES(loginRequest);
    try {
      var response = await http.post(Uri.parse('$baseUrl/api/auth/signin'),
          headers: getCommonHeaders(), body: finalRequestBody);
      dev.log('$baseUrl/api/auth/signin');
      if (response.statusCode == 200) {
        // LoginResponse responseLogin =
        //     LoginResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        Map<String, dynamic> responseJson =
            GatewayService.decryptAES(response.body);
        LoginResponse responseLogin = LoginResponse.fromJson(responseJson);
        localStorage.setItem("currentUser", responseLogin);
        return responseLogin;
        // LoginResponse responseLogin =
        //     LoginResponse.fromJson(responseLogin);
      } else if (response.statusCode == 401) {
        return null;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      dev.log(e.toString());
      return null;
    }
  }

  static searchRequest(path, queryParameters) async {
    _latestRequest?.abort();
    HttpClient client = HttpClient();
    Map<String, String> headers = getCommonHeaders();
    var url = baseUrl + getFullUrlWithParams(path, queryParameters);
    try {
      // Gửi yêu cầu
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
      _latestRequest = request;
      HttpClientResponse response = await request.close();

      dev.log('get $baseUrl$path status code ${response.statusCode}');
      var responeString = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        try {
          return GatewayService.decryptAES(responeString);
        } catch (_) {}
        return json.decode(responeString);
      } else if (response.statusCode == 401) {
        goUnauthorizedWidget();
      } else {
        throw Exception('Failed to load');
      }
    } catch (error) {
      // Xử lý lỗi (nếu có)
      dev.log('error: ${error.toString()}');
      return {
        "errorCode": null,
        "errorMessage": null,
        "data": null,
      };
    } finally {
      client.close();
    }
  }

  static httpGet(path, queryParameters) async {
    var url = baseUrl + getFullUrlWithParams(path, queryParameters);
    var response = await http.get(Uri.parse(url), headers: getCommonHeaders());
    dev.log('get $url status code ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        return GatewayService.decryptAES(response.body);
        // return json.decode(utf8.decode(response.bodyBytes));
      } catch (_) {
        //bypass
      }
      return GatewayService.decryptAES(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      goUnauthorizedWidget();
    } else {
      throw Exception('Failed to load');
    }
  }

  static httpPost(url, request) async {
    var response = await http.post(Uri.parse('$baseUrl$url'),
        headers: getCommonHeaders(), body: GatewayService.encryptAES(request));
    dev.log('post $baseUrl$url status code ${response.statusCode}');
    if (response.statusCode == 200) {
      if (response.headers[HEADER_CONTENT_TYPE] ==
          CONTENT_TYPE_APPLICATON_JSON) {
        try {
          return GatewayService.decryptAES(response.body);
          // return json.decode(utf8.decode(response.bodyBytes));
        } on FormatException {
          //bypass
        }
      }
      return GatewayService.decryptAES(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      goUnauthorizedWidget();
    } else {
      throw Exception('Failed to load');
    }
  }

  static httpPut(url, request) async {
    var response = await http.put(Uri.parse('$baseUrl$url'),
        headers: getCommonHeaders(), body: GatewayService.encryptAES(request));
    dev.log('put $baseUrl$url status code ${response.statusCode}');
    dev.log('body: ${json.encode(request)}');
    if (response.statusCode == 200) {
      if (response.headers[HEADER_CONTENT_TYPE] ==
          CONTENT_TYPE_APPLICATON_JSON) {
        try {
          return GatewayService.decryptAES(response.body);
        } on FormatException {
          //bypass
        }
      }
      return GatewayService.decryptAES(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      goUnauthorizedWidget();
      return null;
    } else {
      throw Exception('Failed to load');
    }
  }

  static httpDelete(id) async {
    var response = await http.delete(Uri.parse('$baseUrl/$id'),
        headers: getCommonHeaders());
    dev.log('delete $baseUrl/$id status code ${response.statusCode}');
    if (response.statusCode == 200) {
      if (response.headers[HEADER_CONTENT_TYPE] ==
          CONTENT_TYPE_APPLICATON_JSON) {
        try {
          return json.decode(utf8.decode(response.bodyBytes));
        } on FormatException {
          //bypass
        }
      }
      return utf8.decode(response.bodyBytes);
    } else if (response.statusCode == 401) {
      goUnauthorizedWidget();
    } else {
      throw Exception('Failed to load');
    }
  }

  static httpDeleteList(url, List<int> idList) async {
    var response = await http.delete(Uri.parse('$baseUrl$url'),
        headers: getCommonHeaders(), body: GatewayService.encryptAES(idList));
    if (response.statusCode == 200) {
      if (response.headers[HEADER_CONTENT_TYPE] ==
          CONTENT_TYPE_APPLICATON_JSON) {
        try {
          return GatewayService.decryptAES(response.body);
        } on FormatException {
          //bypass
        }
      }
      return GatewayService.decryptAES(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      goUnauthorizedWidget();
    } else {
      throw Exception('Failed to load');
    }
  }

  static goUnauthorizedWidget() {
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginWidget()),
        (route) => route.isFirst);
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => const LoginWidget()));
  }

  static getFullUrlWithParams(api, Map? payload) {
    if (payload != null && payload.isNotEmpty) {
      var keys = payload.keys;
      String params = '';
      for (String key in keys) {
        if (payload[key] != null && payload[key] != '') {
          String value = payload[key].toString();
          params += params.isEmpty ? '?$key=$value' : '&$key=$value';
        }
      }
      return '$api$params';
    }

    return api;
  }
}
