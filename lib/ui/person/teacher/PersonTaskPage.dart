import 'package:ct_android_plus/apis/TaskDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/components/ProgressLine.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../apis/PersonalDio.dart';
import '../../../utils/CurrentObjects.dart';

class PersonTaskPage extends StatefulWidget {
  PersonTaskPage({Key? key}) : super(key: key);

  @override
  State<PersonTaskPage> createState() => _PersonTaskPageState();
}

class _PersonTaskPageState extends State<PersonTaskPage> {

  List<dynamic> tasks = [];
  Map<String, dynamic> publishers = {};
  bool isLoadingTask = true;
  bool isDeleting = false;
  late var _futureBuilderMethod;

  @override
  void initState() {
    if(!mounted){
      return;
    }
    _futureBuilderMethod = initData();
    super.initState();
  }

  initData() async {
    //先后顺序控制
    return getAllTaskByUsername().then((value) async {
      return await getAllUsersWithUsers(value);
    });
  }

  Future getAllTaskByUsername() async {
    dynamic res = await TaskDio.getAllTaskByUsername(CurrentUser.user["username"]);

    if(!mounted){
      return;
    }
    setState(() {
      tasks = res;
      isLoadingTask = false;
    });

    return res;
  }

  Future getAllUsersWithUsers(List<dynamic> tasks) async {
    List<String> names = [];
    List<String> tids = [];
    for (Map<String, dynamic> task in tasks) {
      names.add(task["publisher"]);
      tids.add(task["tid"].toString());
    }
    Map<String, dynamic> response = await PersonalDio.getAllUsersPersonalByName(names, tids);
    setState(() {
      publishers = response;
    });
  }

  Future<String?> _show(BuildContext context) {
    return showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            title: const Text("提示"),
            content: const Text("确定要删除任务吗?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context,"false");
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context,"true");
                },
                child: const Text("确认",style: TextStyle(color: Colors.red),),
              ),
            ],
          );
        }
    );
  }

  doDelTask(String tid) async {
    if(!mounted){return;}
    setState(() {
      isDeleting = true;
    });

    dynamic res = await TaskDio.delTaskByTid(tid);
    if(res["code"]=="200"){
      showToast("删除成功");
      while(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      Navigator.pushNamed(context, "/main");
    }else{
      showToast("删除失败");
    }

    setState(() {
      isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return FutureBuilder(
      future: _futureBuilderMethod,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        //正在加载中
        if(snapShot.connectionState == ConnectionState.waiting){
          return LoadingDialog();
          //加载完毕
        }else if(snapShot.connectionState == ConnectionState.done){
          return Stack(
            children: [
              AnimationLimiter(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context,int index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 560+tasks.length*140),
                          child: SlideAnimation( //滑动动画
                            verticalOffset: 50,
                            child: FadeInAnimation( //渐变动画
                                child: GestureDetector(
                                  onTap: () {
                                    CurrentTask.currentTask = tasks[tasks.length-index-1];
                                    Navigator.pushNamed(context, "/task/content");
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tasks[tasks.length-index-1]["tname"], style: Theme.of(context).textTheme.bodyText1,),
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+publishers[tasks[tasks.length-index-1]["tid"].toString()]["headiconURL"]),
                                                ),
                                                const SizedBox(width: 10,),
                                                Text(tasks[tasks.length-index-1]["publisher"], style: Theme.of(context).textTheme.bodyText1,),
                                              ],
                                            ),
                                            Row(
                                              children: const [
                                                Chip(label: Text("coming soon"))
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(tasks[tasks.length-index-1]["tbody"], style: Theme.of(context).textTheme.bodyText1, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                        const SizedBox(height: 10,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("任务进度：", style: Theme.of(context).textTheme.bodyText1,),
                                                SizedBox(
                                                  width: width/2.8,
                                                  child: ProgressLine(
                                                    progress: int.parse(tasks[tasks.length-index-1]["progress"]),
                                                    completionScheduleColor: Colors.lightGreen,
                                                    height: 15,
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                Text(tasks[tasks.length-index-1]["progress"].toString()+"%", style: Theme.of(context).textTheme.bodyText1,),
                                              ],
                                            ),
                                            SizedBox(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(Colors.red)
                                                ),
                                                onPressed: () async {
                                                  var dialog = await _show(context);
                                                  if(dialog == "true"){
                                                    doDelTask(tasks[tasks.length-index-1]["tid"].toString());
                                                  }
                                                },
                                                child: const Text("删除任务"),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          )
                      );
                    }
                ),
              )
            ],
          );
        }else{
          return const SizedBox();
        }
      },
    );
  }
}

