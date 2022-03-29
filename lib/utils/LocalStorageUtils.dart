import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static saveCookie(List<String> cookie) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList("cookie", cookie);
  }

  static Future<List<String>?> getCookie() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList("cookie");
  }

  static delCookie() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("cookie");
  }

  static Future<bool?> checkCookie() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.containsKey("cookie") ;
  }
}
