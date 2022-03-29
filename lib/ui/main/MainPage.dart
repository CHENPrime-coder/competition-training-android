import 'package:ct_android_plus/ui/daily/DailyPage.dart';
import 'package:ct_android_plus/ui/members/MembersPage.dart';
import 'package:ct_android_plus/ui/person/PersonPage.dart';
import 'package:ct_android_plus/ui/publish/PublishPage.dart';
import 'package:ct_android_plus/ui/task/TaskPage.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/DefaultAppBar.dart';
import '../../components/MyFlutterAppIcons.dart';

class MainPage extends StatefulWidget {
  late var arguments;
  MainPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _currentIndex = 0;
  late dynamic res;

  List<BottomNavigationBarItem> bottomNavigationBarItems = [
    const BottomNavigationBarItem(
        label: "任务",
        icon: Icon(MyFlutterApp.home),
    ),
    const BottomNavigationBarItem(
        label: "日报",
        icon: Icon(MyFlutterApp.daily),
    ),
    BottomNavigationBarItem(
      icon: Container(
        height: 50,
        width: 60,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: const Color.fromRGBO(248, 200, 34, 1),width: 3)
        ),
        child: const Center(
          child: Icon(Icons.add, ),
        ),
      ),
      label: ""
    ),
    const BottomNavigationBarItem(
      label: "工作室",
      icon: Icon(Icons.group),
    ),
    const BottomNavigationBarItem(
      label: "我的",
      icon: Icon(MyFlutterApp.person),
    ),
  ];

  List<AppBar> appBarWidget = [
    getDefaultAppBar("任务"),
    getDefaultAppBar("日报"),
    getDefaultAppBar("发布"),
    getDefaultAppBar("工作室"),
    getDefaultAppBar("我的"),
  ];

  List<Widget> bodyWidget = [
    TaskPage(),
    DailyPage(),
    PublishPage(),
    MembersPage(),
    PersonPage()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarWidget[_currentIndex],
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        selectedItemColor: Theme.of(context).primaryColor,
        iconSize: 34,
        onTap: (value) {
          if(value != _currentIndex){
            if(value == 4){
              CurrentUser.personUsername = CurrentUser.username;
            }
            setState(() {
              _currentIndex=value;
            });
          }
        },
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: bottomNavigationBarItems,
      ),
      body: bodyWidget[_currentIndex],
    );
  }
}

