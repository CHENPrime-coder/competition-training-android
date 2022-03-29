import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/ui/person/select/student/PersonDailyPage.dart';
import 'package:ct_android_plus/ui/person/select/student/PersonPlanPage.dart';
import 'package:ct_android_plus/ui/person/select/teacher/PerosnScoreHistoryPage.dart';
import 'package:ct_android_plus/ui/person/select/teacher/PersonStudioPage.dart';
import 'package:ct_android_plus/ui/person/select/teacher/PersonTaskPage.dart';

import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherPersonPage extends StatefulWidget {
  OtherPersonPage({Key? key}) : super(key: key);

  @override
  State<OtherPersonPage> createState() => _OtherPersonPageState();
}

class _OtherPersonPageState extends State<OtherPersonPage> with TickerProviderStateMixin {

  late var _futureBuilderMethod;
  late Map<String,dynamic> me;
  Color tabColor = const Color.fromRGBO(248, 200, 34, 1);
  late TabController controllerStu;
  late TabController controllerTea;
  bool isStu = true;

  final List<Widget> _tabsStu = [
    const Tab(text: "日报"),
    const Tab(text: "周计划"),
    const Tab(text: "月计划"),
    const Tab(text: "学期计划"),
  ];

  final List<Widget> _tabsTea = [
    const Tab(text: "任务"),
    const Tab(text: "工作室"),
    const Tab(text: "历史考核"),
  ];

  final List<Widget> _tagViewsStu = [
    PersonDailyPage(),
    PersonPlanPage(type: 'weekplan',),
    PersonPlanPage(type: 'monthplan',),
    PersonPlanPage(type: 'yearplan',),
  ];

  final List<Widget> _tagViewsTea = [
    PersonTaskPage(),
    PersonStudioPage(),
    PersonPublishScorePage(),
  ];

  @override
  void initState() {
    if(!mounted){
      return;
    }
    setState(() {
      controllerStu = TabController(
        length: 4, vsync: this,
      );
      controllerTea = TabController(
        length: 3, vsync: this
      );
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    setState(() {
      me = CurrentUser.selectUser;
      if(me["role"]=="老师"){
        isStu = false;
      }else if(me["role"]=="学生"){
        isStu = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("用户信息", context),
      body: FutureBuilder(
          future: _futureBuilderMethod,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return LoadingDialog();
            }else if(snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 230,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                height: 180,
                                color: const Color.fromRGBO(247, 224, 144, 1),
                                child: Row(),
                              ),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(20,140,20,0),
                                  height: 200,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+me["headiconURL"]),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Text(me["username"],style: const TextStyle(color: Colors.black87,fontSize: 40),),
                              const SizedBox(width: 5,),
                              Text(me["role"],style: const TextStyle(color: Colors.grey,fontSize: 20),)
                            ],
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if(!isStu) {
                                return const SizedBox();
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 400,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          CurrentUser.user = CurrentUser.selectUser;
                                          Navigator.pushNamed(context, '/person/release/status');
                                        },
                                        child: const Text("发布情况",style: TextStyle(fontSize: 20,color: Colors.black87),),
                                        style:  ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.grey[200])
                                        ),
                                      )
                                  )
                                ],
                              );
                            },
                          )
                      ),
                      TabBar(
                        indicatorColor: tabColor,
                        tabs: isStu ? _tabsStu : _tabsTea,
                        controller: isStu ? controllerStu : controllerTea,
                      ),
                      SizedBox(
                          height: 630,
                          child: TabBarView(
                            controller: isStu ? controllerStu : controllerTea,
                            children: isStu ? _tagViewsStu : _tagViewsTea,
                          )
                      )
                    ],
                  )
              );
            }else{
              return const SizedBox();
            }
          }
      ),
    );
  }
}

