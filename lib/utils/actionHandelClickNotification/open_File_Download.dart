// ignore_for_file: file_names

import 'package:open_file/open_file.dart';

openFileDownload({String? urlFile}) async {
  if (urlFile != null) {
    OpenFile.open(urlFile);
  }
}
