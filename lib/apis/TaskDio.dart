import 'package:ct_android_plus/apis/BaseDio.dart';
import 'package:dio/dio.dart';

class TaskDio {
  static getAllTask() async {
    Response response = await BaseDio.getDio().get('/task');

    return response.data;
  }

  static getAllTaskByUsername(String username) async {
    Response response = await BaseDio.getDio().get('/task/'+username);

    return response.data;
  }

  static getAllTaskProgressByTid(String tid) async {
    Response response = await BaseDio.getDio().get("/progress",queryParameters: {
      "tid": tid
    });

    return response.data;
  }

  static putProgress(String updateProgress,String remarks,String username,String newProgress,String tid) async {
    Response response = await BaseDio.getDio().put("/task",queryParameters: {
      "progress": updateProgress,
      "remarks": remarks,
      "username": username,
      "newPro": newProgress,
      "tid": tid,
    });

    return response.data;
  }

  static delTaskByTid(String tid) async {
    Response response = await BaseDio.getDio().delete('/task',queryParameters: {
      "tid": tid
    });

    return response.data;
  }

  static publishTask(String title,String body,String startdate,String enddate,String tmembers) async {
    Response response = await BaseDio.getDio().post("/task",queryParameters: {
      "tname": title,
      "tbody": body,
      "progress": "0",
      "startdate": startdate,
      "enddate": enddate,
      "tmembers": tmembers
    });

    return response.data;
  }
}
