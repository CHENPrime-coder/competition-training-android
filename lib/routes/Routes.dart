import 'package:ct_android_plus/ui/LoginPage.dart';
import 'package:ct_android_plus/ui/daily/DailyContentPage.dart';
import 'package:ct_android_plus/ui/main/MainPage.dart';
import 'package:ct_android_plus/ui/members/MembersChangeHeadPage.dart';
import 'package:ct_android_plus/ui/members/MembersSettingPage.dart';
import 'package:ct_android_plus/ui/person/select/OtherPersonPage.dart';
import 'package:ct_android_plus/ui/person/setting/SettingsPage.dart';
import 'package:ct_android_plus/ui/person/student/PersonScoreContent.dart';
import 'package:ct_android_plus/ui/person/student/PersonScorePage.dart';
import 'package:ct_android_plus/ui/person/student/ReleaseStatusPage.dart';
import 'package:ct_android_plus/ui/plan/PlanContentPage.dart';
import 'package:ct_android_plus/ui/publish/PublishScoreContentPage.dart';
import 'package:ct_android_plus/ui/publish/PublishScorePage.dart';
import 'package:ct_android_plus/ui/task/TaskContentPage.dart';
import 'package:ct_android_plus/ui/task/TaskProgressPage.dart';
import 'package:ct_android_plus/ui/task/TaskProgressUpdatePage.dart';
import 'package:flutter/material.dart';

import '../ui/members/MembersContent.dart';
import '../ui/person/setting/ChangeUserHeadIcon.dart';

final routes = {
  '/login': (context) => LoginPage(),
  '/main': (context) => MainPage(),
  '/task/content': (context) => TaskContentPage(),
  '/task/progress': (context) => TaskProgressPage(),
  '/task/progress/update': (context) => TaskProgressUpdatePage(),
  '/daily/content': (context) => DailyContentPage(),
  '/members/content': (context) => MembersContent(),
  '/person/release/status': (context) => ReleaseStatusPage(),
  '/plan': (context) => PlanContentPage(),
  '/setting': (context) => SettingsPage(),
  '/setting/change/user/img': (context) => ChangeUserHeadIcon(),
  '/person/score/list': (context) => PersonScorePage(),
  '/person/score/content': (context) => PersonScoreContent(),
  '/members/setting': (context) => MembersSettingPage(),
  '/members/setting/change/head': (context) => MembersChangeHeadPage(),
  '/publish/pfm': (context) => PublishScorePage(),
  '/publish/pfm/content': (context) => PublishScoreContentPage(),
  '/other/person': (context) => OtherPersonPage(),
};

onGenerateRoute(RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageBuilder = routes[name];

  //如果找到的对应的路由
  if(pageBuilder != null) {
    //如果有参数
    if(settings.arguments != null) {
      final Route route = MaterialPageRoute(builder: (context) =>
          pageBuilder(context, arguments: settings.arguments));
      return route;
    }else{
      final Route route = MaterialPageRoute(builder: (context) =>
          pageBuilder(context));
      return route;
    }
  }
}
