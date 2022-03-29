
import 'package:ct_android_plus/apis/BaseDio.dart';
import 'package:dio/dio.dart';

class StudioDio{
  static getAllStudios() async {
    Response response = await BaseDio.getDio().get("/studio");

    return response.data;
  }

  static getAllStudioByTeacher(String teacher) async {
    Response response = await BaseDio.getDio().get("/studio/teacher/"+teacher);

    return response.data;
  }

  static changeHeadIcon(String filename,String oldFilename,String sname) async {
    Response response = await BaseDio.getDio().post("/studio",queryParameters: {
      "filename": filename,
      "oldFilename": oldFilename,
      "sname": sname
    });

    return response.data;
  }
}
