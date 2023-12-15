// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/utils/local_notification.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;

import 'package:share/share.dart';

Future<void> saveFileFromAPI(BuildContext context,
    {String? fileName, dynamic requestBody, String? url}) async {
  Map<String, String> headers = {'content-type': 'application/json'};
  final currentUser =
      LoginResponse.fromJson(localStorage.getItem('currentUser'));
  if (currentUser.type != null && currentUser.token != null) {
    headers["Authorization"] = "${currentUser.type} ${currentUser.token}";
  }
  try {
    var response = await http.post(Uri.parse('$baseUrl$url'),
        headers: headers,
        body: requestBody is Map
            ? json.encode(requestBody)
            : json.encode(requestBody.toJson()));
    if (response.statusCode == 200) {
      String? path = await createCBWAYDirectory();
      if (path != null) {
        saveFile(path, response, fileName, context);
      } else {
        showToast(
            context: context,
            msg: 'Không tạo được tệp lưu trữ',
            color: Colors.red,
            icon: const Icon(Icons.error));
      }
    } else {
      showToast(
          context: context,
          msg: 'Tải file không thành công!',
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  } catch (e) {
    dev.log(e.toString());
    if (e.toString().contains('Connection refused')) {
      showToast(
          context: context,
          msg: 'Lỗi kết nối máy chủ',
          color: Colors.red,
          icon: const Icon(Icons.error));
      return;
    }
    if (e.toString().contains('Connection timed out')) {
      showToast(
          context: context,
          msg: 'Vui lòng kiểm tra đường truyền Internet!',
          color: Colors.red,
          icon: const Icon(Icons.error));
      return;
    }
    return;
  }
}

Future saveFile(path, response, fileName, context) async {
  //Lấy định dạng file
  String? fileType = response.headers['export'];
  var timeLoad = DateFormat('_ddMMyyyy').format(DateTime.now());
  if (fileType != null) {
    //Cấu hình tên file
    String fileNameSave = '$fileName' '_CB$timeLoad$fileType';
    var filePathDir = '$path/$fileNameSave';

    //Kiểm tra tên file đã tồn tại chưa và cập nhật lại tên file
    String filePath = await checkFileName(filePathDir);
    File file = File(filePath);
    //Lưu file và đẩy thông báo
    try {
      await file.writeAsBytes(response.bodyBytes);
      if (Platform.isAndroid) {
        LocalNotificationService localNotificationService =
            LocalNotificationService(
                channelID: ChannelIDNotification.LOADFILE.value,
                channelName: ChannelNameNotification.LOADFILE.value,
                urlFile: filePath);
        await localNotificationService.initNotification(context, '');
        localNotificationService.showNotification(
          title: 'Tải file thành công',
          body: file.path.split('/').last,
        );
      } else {
        await Share.shareFiles([filePath]);
      }
    } catch (e) {
      showToast(
          context: context,
          msg: 'Lưu file không thành công!',
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }
}

Future<String?> createCBWAYDirectory() async {
  try {
    String directoryPath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!
            .path // Đường dẫn thư mục trên Android
        : (await getTemporaryDirectory()).path; // Đường dẫn thư mục trên iOS

    // Kiểm tra xem thư mục đã tồn tại chưa, nếu chưa thì tạo mới
    Directory directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    return directoryPath;
  } catch (e) {
    return null;
  }
}

Future checkFileName(String filePath) async {
  //Kiểm tra file tồn tại hay chưa
  File file = File(filePath);
  if (!file.existsSync()) {
    return filePath; // Tệp không tồn tại, trả về nguyên tên tệp
  }
  // Tách tên và phần mở rộng của tệp
  var basename = file.path.substring(0, file.path.lastIndexOf('.'));
  var extension = file.path.split('.').last;
  var counter = 1;
  var newFilePath = '';

  // Kiểm tra và thêm số lần lượt cho đến khi tìm được tên tệp không tồn tại
  do {
    newFilePath = '$basename($counter).$extension';
    counter++;
  } while (File(newFilePath).existsSync());

  return newFilePath;
}
