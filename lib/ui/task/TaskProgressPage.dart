import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/apis/TaskDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CircleCustomPaint.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../utils/UrlSettings.dart';

class TaskProgressPage extends StatefulWidget {
  TaskProgressPage({Key? key}) : super(key: key);

  @override
  State<TaskProgressPage> createState() => _TaskProgressPageState();
}

class _TaskProgressPageState extends State<TaskProgressPage> {
  late var _futureBuilderMethod;
  late Map<String, dynamic> task;
  late List<dynamic> progress;
  late Map<String, dynamic> users;
  List<int> progressInt = [];
  List<bool> isOn = [];
  List<String> names = [];
  List<String> keys = [];
  late int remainingProgress;

  @override
  void initState() {
    setState(() {
      task = CurrentTask.currentTask;
      _futureBuilderMethod = initData();
      remainingProgress = 100 - int.parse(CurrentTask.currentTask["progress"].toString());
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await TaskDio.getAllTaskProgressByTid(task["tid"].toString());
    for(Map<String,dynamic> pro in res){
      setState(() {
        progressInt.add(pro["progress"]);
        isOn.add(false);
        names.add(pro["username"]);
        keys.add(pro["proid"].toString());
      });
    }
    setState(() {
      progress = res;
      progressInt.add(remainingProgress);
    });
    return getUsers();
  }

  Future getUsers() async {
    Map<String, dynamic> res = await PersonalDio.getAllUsersPersonalByName(names, keys);
    setState(() {
      users = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("任务进度", context),
      body: FutureBuilder(
        future: _futureBuilderMethod,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingDialog();
          }else if(snapshot.connectionState == ConnectionState.done){
            return SingleChildScrollView(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraint) {
                      return SizedBox(
                        width: constraint.maxWidth,
                        height: constraint.maxWidth,
                        child: Stack(
                          children: [
                            Center(
                              child: CustomPaint(
                                foregroundPainter: CircleCustomPaint(data: progressInt),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 170,),
                                  Text(task['progress'].toString()+"%",style: const TextStyle(fontSize: 40,color: Colors.black87),),
                                  const Text("任务完成度",style: TextStyle(fontSize: 15,color: Colors.grey),),
                                  task['progress'].toString()=="100"?
                                  const Chip(label: Text("    已完成    ",style: TextStyle(fontSize: 15,color: Colors.white),)) :
                                  GestureDetector(
                                    onTap: () {
                                      if(CurrentUser.user["role"]=="老师"){
                                        showToast("老师不可以更新任务进度");
                                      }
                                      Navigator.pushNamed(context, "/task/progress/update");
                                    },
                                    child: Chip(
                                      label: const Text("    更新进度    ",style: TextStyle(fontSize: 15,color: Colors.black87),),
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  const Divider(color: Color.fromRGBO(220, 225, 235, 1),height: 2,thickness: 2,),
                  const SizedBox(height: 10,),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if(progress.isEmpty){
                        return Image.asset("lib/images/nothing.png");
                      }
                      return AnimationLimiter(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            color: Colors.white,
                            height: 300,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: progress.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: isOn[index] ? 100 : 50,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+users[progress[index]["proid"].toString()]["headiconURL"]),
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(progress[index]["prodate"].toString().substring(0,10),style: const TextStyle(color: Colors.black87),),
                                            ],
                                          ),
                                          Text("("+progress[index]["progress"].toString()+"%)",style: const TextStyle(color: Colors.grey),),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isOn[index] = !isOn[index];
                                              });
                                            },
                                            child: !isOn[index] ? const Text("详情",style: TextStyle(color: Colors.blue),)
                                                : const Text("关闭",style: TextStyle(color: Colors.grey)),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: isOn[index],
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(progress[index]["remarks"],style: TextStyle(color: Colors.black87),)
                                            ],
                                          ),
                                        )
                                      )
                                    ],
                                  )
                                );
                              }
                            ),
                          )
                      );
                    }
                  )
                ],
              ),
            );
          }else{
            return const SizedBox();
          }
        },
      )
    //    SingleChildScrollView
    );
  }
}

