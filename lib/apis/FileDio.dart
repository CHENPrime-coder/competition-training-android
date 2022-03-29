
import 'dart:io';

import 'package:ct_android_plus/apis/BaseDio.dart';
import 'package:dio/dio.dart';

class FileDio{
  static uploadFile(File file,String oldFilename,String filename) async {
    FormData formData = FormData.fromMap({
      "filebody": await MultipartFile.fromFile(file.path, filename: oldFilename),
      "filename": filename
    });
    Response response = await BaseDio.getDio().post("/file", data: formData);

    return response.data;
  }
}
