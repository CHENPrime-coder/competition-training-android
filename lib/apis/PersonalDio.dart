import 'dart:convert';

import 'package:ct_android_plus/apis/BaseDio.dart';
import 'package:dio/dio.dart';

class PersonalDio{
  static getAllUsersPersonalByName(List<String> names, List<String> keys) async {
    Dio dio = BaseDio.getDio();
    Map<String, dynamic> personals = {};
    for (int i=0;i<keys.length;i++) {
      Response response = await dio.get("/personalname/"+names[i]);
      personals.addAll({keys[i] :response.data});
    }

    return personals;
  }

  static getAllUsersPersonalById(List<int> ids, List<String> keys) async {
    Dio dio = BaseDio.getDio();
    Map<String, dynamic> personals = {};
    for (int i=0;i<keys.length;i++) {
      Response response = await dio.get("/personal/"+ids[i].toString());
      personals.addAll({keys[i] :response.data});
    }

    return personals;
  }

  static getAllUsersPersonalByNameNoKeys(List<String> names) async {
    Dio dio = BaseDio.getDio();
    List<dynamic> personals = [];
    for (String name in names) {
      Response response = await dio.get("/personalname/"+name);
      personals.add(response.data);
    }

    return personals;
  }


  static getUserByName(String name) async {
    Response response = await BaseDio.getDio().get("/personalname/"+name);

    return response.data;
  }

  static changeUserImg(String filename,String oldFilename) async {
    Response response = await BaseDio.getDio().post("/userimg",queryParameters: {
      "filename": filename,
      "oldFilename": oldFilename
    });

    return response.data;
  }
  
  static getAllScore(String uid) async {
    Response response = await BaseDio.getDio().get('/pfm/'+uid);

    return response.data;
  }

  static getAllScoreByTeacher(String username) async {
    Response response = await BaseDio.getDio().get("/pfm/teacher/"+username);

    return response.data;
  }

  static publishScores(Map<String,Map<String,String>> scores,String info,String teacher,DateTime date) async {
    String dateStr = date.year.toString()+"-"+
        (date.month<10?"0"+date.month.toString():date.month.toString())+"-"+
        (date.day<10?"0"+date.day.toString():date.day.toString())+" 00:00:00";
    List<String> ids = scores.keys.toList();
    for(String id in ids){
      Response response = await BaseDio.getDio().post("/pfm",queryParameters: {
        "uid": id,
        "score": jsonEncode(scores[id]),
        "info": info,
        "teacher": teacher,
        "date": dateStr
      });
      if(response.data["code"]=="405" || response.data["code"]=="403"){
        return false;
      }
    }
    return true;
  }
}
