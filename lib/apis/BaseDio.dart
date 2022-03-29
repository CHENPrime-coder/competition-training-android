import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:dio/dio.dart';

class BaseDio{
  static List<String> cookie = [];

  static Dio getDio(){
    BaseOptions baseOptions = BaseOptions(
      baseUrl: UrlSetting.SERVER_URL,
      headers: {
        "Cookie": cookie.isEmpty ? "" : cookie[0]
      }
    );
    return Dio(baseOptions);
  }
}
