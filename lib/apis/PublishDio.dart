
import 'package:ct_android_plus/apis/BaseDio.dart';
import 'package:dio/dio.dart';

class PublishDio{
  static getAllDaily() async {
    Response response = await BaseDio.getDio().get("/all/daily");

    return response.data;
  }

  static getAllDailyWithUsername(String name) async {
    Response response = await BaseDio.getDio().get("/daily/"+name);

    return response.data;
  }
  //plan
  static getAllPlanWithUsernameAndType(String type,String name) async {
    Response response = await BaseDio.getDio().get("/plan/"+type+"/"+name);

    return response.data;
  }

  static getNoPunch() async {
    Response response = await BaseDio.getDio().get("/nopunch");

    return response.data;
  }

  static publishPlan(String ptype,String pname,String pbody) async {
    Response response = await BaseDio.getDio().post("/plan", queryParameters: {
      "pbody": pbody,
      "pname": pname,
      "ptype": ptype
    });

    return response.data;
  }

  static report(String dname,String dbody) async {
    Response response = await BaseDio.getDio().post("/daily", queryParameters: {
      "dname": dname,
      "dbody": dbody
    });

    return response.data;
  }

  static getReleaseStatus(String date,String username) async {
    Response response = await BaseDio.getDio().get("/publish/"+username,queryParameters: {
      "yyyyMM": date
    });

    return response.data;
  }
}
