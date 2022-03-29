import 'package:ct_android_plus/apis/BaseDio.dart';
import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/LocalStorageUtils.dart';
import 'package:dio/dio.dart';

class AccessDio{
  
  static Future<bool> login(String username,String password) async {
    Response response = await BaseDio.getDio().post("/login", queryParameters: {
      "username": username,
      "password": password
    });

    if(response.data["code"] == "200") {
      response.headers.forEach((name, values) async {
        if (name == "set-cookie") {
          BaseDio.cookie = values;
          await LocalStorageUtils.saveCookie(values);
        }
      });
      CurrentUser.user = await PersonalDio.getUserByName(username);
      return true;
    }

    return false;
  }
  
  static getAllStudent() async {
   Response response = await BaseDio.getDio().get("/students");

   return response.data;
  }
}
