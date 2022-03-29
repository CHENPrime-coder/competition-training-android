import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/MemberGridView.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/material.dart';

import '../../components/DefaultAppBar.dart';
import '../../components/LoadingDialog.dart';
import '../../components/ProgressLine.dart';
import '../../utils/UrlSettings.dart';

class TaskContentPage extends StatefulWidget {
  TaskContentPage({Key? key}) : super(key: key);

  @override
  State<TaskContentPage> createState() => _TaskContentPageState();
}

class _TaskContentPageState extends State<TaskContentPage> {
  late Map<String, dynamic> task;
  late Map<String, dynamic> user;
  late List<String> members;

  late var _futureBuilderMethod;

  @override
  void initState() {
    setState(() {
      task = CurrentTask.currentTask;
      members = task["tmembers"].toString().split(',');
      _futureBuilderMethod = getUser();
    });
    super.initState();
  }

  Future getUser() async {
    dynamic res = await PersonalDio.getUserByName(task["publisher"]);
    setState(() {
      user = res;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("任务内容", context),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: _futureBuilderMethod,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return LoadingDialog(opacity: 0,);
            }else if(snapshot.connectionState == ConnectionState.done){
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(task["tname"], style: Theme.of(context).textTheme.headline5,),
                        Text(
                          task["tdate"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst("-", " 月 ")+" 日",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+user["headiconURL"]),
                        ),
                        const SizedBox(width: 10,),
                        Text(user["username"], style: Theme.of(context).textTheme.bodyText1,)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(task["tbody"], style: Theme.of(context).textTheme.headline2,),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const Text("任务进度：", style: TextStyle(color: Colors.black87),),
                        SizedBox(
                          width: 180,
                          child: ProgressLine(
                            progress: int.parse(task["progress"]),
                            completionScheduleColor: Colors.lightGreen,
                            height: 15,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text(task["progress"].toString()+"%", style: Theme.of(context).textTheme.bodyText1,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Chip(label: Text("coming soon"))
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(children: const [Text("任务成员：", style: TextStyle(color: Colors.black87, fontSize: 18),)],),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(10),
                      child: MemberGridView(members: members),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "开始："+task["startdate"].toString().substring(0,10).replaceFirst("-", "年").replaceFirst("-", "月")+"日",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          "截止："+task["enddate"].toString().substring(0,10).replaceFirst("-", "年").replaceFirst("-", "月")+"日",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 80,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/task/progress");
                          },
                          child: const Text("更新进度", style: TextStyle(color: Colors.black87, fontSize: 18),)
                      ),
                    ),
                  ],
                ),
              );
            }else{
              return const SizedBox();
            }
          },
        )
      ),
    );
  }
}

