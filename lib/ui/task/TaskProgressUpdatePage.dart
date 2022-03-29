import 'package:ct_android_plus/apis/TaskDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main/MainPage.dart';

class TaskProgressUpdatePage extends StatefulWidget {
  TaskProgressUpdatePage({Key? key}) : super(key: key);

  @override
  State<TaskProgressUpdatePage> createState() => _TaskProgressUpdatePageState();
}

class _TaskProgressUpdatePageState extends State<TaskProgressUpdatePage> {

  late Map<String, dynamic> task;
  late String oldProgress;
  late String newProgress;
  String remarks = "";
  bool canMinus = false;
  bool canPlus = true;
  bool isLoading = false;

  void doPlus() {
    setState(() {
      newProgress = (int.parse(newProgress) + 1).toString();
      canPlus = newProgress != "100";
      canMinus = newProgress != oldProgress;
    });
  }

  void doMinus() {
    setState(() {
      newProgress = (int.parse(newProgress) - 1).toString();
      canMinus = newProgress != oldProgress;
    });
  }

  bool verify() {
    return newProgress != oldProgress && remarks.isNotEmpty;
  }

  void doPutProgress(BuildContext context) async {
    final String updateProgress = (int.parse(newProgress) - int.parse(oldProgress)).toString();
    setState(() {
      isLoading = true;
    });
    dynamic res = await TaskDio.putProgress(updateProgress, remarks, CurrentUser.username, newProgress, task["tid"].toString());
    setState(() {
      isLoading = false;
    });
    if(res["code"] == "200"){
      while(Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Navigator.pushNamed(context,"/main");
      showToast("发布成功");
    }else{
      showToast("发布失败");
    }
  }

  @override
  void initState() {
    setState(() {
      task = CurrentTask.currentTask;
      newProgress = oldProgress = task["progress"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(CupertinoIcons.back), iconSize: 35, color: Colors.black87,),
        backgroundColor: const Color.fromRGBO(248, 200, 34, 1),
        centerTitle: true,
        title: const Text("更新进度",style: TextStyle(color: Colors.black87),),
        actions: [
          TextButton(
            onPressed: () {
              if(verify()){
                doPutProgress(context);
              }else{
                showToast("请确认修改了进度并填写了备注");
              }
            },
            child: const Text("发布",style: TextStyle(fontSize: 20,color: Colors.black87),)
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap:canMinus ? () {doMinus();} : null ,
                            child: const Icon(CupertinoIcons.minus,size: 100,color: Color.fromRGBO(129, 126, 126, 1),)
                          ),
                        ),
                        // Text(task["progress"]+"%",style: const TextStyle(color: Colors.black87,fontSize: 80),),
                        SizedBox(
                          width: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(newProgress+"%",style: const TextStyle(color: Colors.black87,fontSize: 75),),
                            ],
                          )
                        ),
                        SizedBox(
                          width: 100,
                          child: GestureDetector(
                              onTap: canPlus ? () {doPlus();} : null,
                              child: const Icon(CupertinoIcons.plus,size: 100,color: Color.fromRGBO(129, 126, 126, 1),)
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("时间",style: TextStyle(color: Colors.black87,fontSize: 20),),
                        GestureDetector(
                          child: Text(DateTime.now().toString().substring(0,10).replaceFirst("-", "  年  ").replaceFirst("-", "  月  ")+"  日"
                            ,style: const TextStyle(color: Colors.black87,fontSize: 20),),
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 2,thickness: 2,),
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("备注",style: TextStyle(color: Colors.black87,fontSize: 20),),
                      ],
                    ),
                  ),
                  const Divider(height: 2,thickness: 2,),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10,0,10,0),
                    width: constraints.maxWidth-20,
                    child: TextField(
                      style: const TextStyle(fontSize: 20, color: Colors.black87),//文字大小、颜色
                      maxLines: 10,//最多多少行
                      minLines: 2,//最少多少行
                      onChanged: (text) {//输入框内容变化回调
                        setState(() {
                          remarks = text;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ), //去除下边框
                        hintText: "请描述⼀下您的具体内容（必填,1-100字）",
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isLoading,
                child: LoadingDialog()
              )
            ],
          );
        },
      ),
    );
  }
}

