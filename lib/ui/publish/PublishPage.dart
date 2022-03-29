import 'package:ct_android_plus/apis/AccessDio.dart';
import 'package:ct_android_plus/apis/PublishDio.dart';
import 'package:ct_android_plus/apis/TaskDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PublishPage extends StatefulWidget {
  PublishPage({Key? key}) : super(key: key);

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  String type = "日报";
  String body = "";
  String title = "";
  bool isLoading = false;
  bool isStu = true;
  bool isAdmin = false;
  String startDateStr = "- 年 - 月 - 日";
  String endDateStr = "- 年 - 月 - 日";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  var _futureBuilderMethod;
  List<bool> userSelects = [];
  List<int> selectUsersIndex = [];
  List<dynamic> users = [];

  @override
  void initState() {
    if(!mounted){
      return;
    }
    setState(() {
      _futureBuilderMethod = initAllStudents();
      if(CurrentUser.user["role"]=="administrator"){
        isAdmin = true;
      }
      if(CurrentUser.user["role"]=="学生"){
        isStu = true;
      }else if(CurrentUser.user["role"]=="老师"){
        isStu = false;
      }
    });
    super.initState();
  }

  bool verify() {
    return body.trim().isNotEmpty && title.trim().isNotEmpty;
  }

  void report() async {
    setState(() {
      isLoading = true;
    });
    dynamic res = await PublishDio.report(title, body);
    setState(() {
      isLoading = false;
    });
    if(res["code"] == "200"){
      showToast("发布成功");
    }else{
      showToast("发布失败");
    }
  }

  void publishPlan() async {
    setState(() {
      isLoading = true;
    });
    dynamic res = await PublishDio.publishPlan(type,title, body);
    setState(() {
      isLoading = false;
    });
    if(await res["code"] == "200"){
      showToast("发布成功");
    }else{
      showToast("发布失败");
    }
  }

  void publishTask(String startdate,String enddate,String tmembers) async {
    setState(() {
      isLoading = true;
    });
    dynamic res = await TaskDio.publishTask(title, body, startdate, enddate, tmembers);
    setState(() {
      isLoading = false;
    });
    if(await res["code"] == "200"){
      showToast("发布成功");
    }else{
      showToast("发布失败");
    }
  }

  void changeDate(bool isEnd, DateTime target) {
    if(isEnd){
      // 结束时间比开始时间早
      if(target.toUtc().difference(startDate).inDays < 0){
        showToast("结束时间不可以比开始时间早");
        return;
      }else{
        setState(() {
          endDate = target;
          endDateStr = target.year.toString() + " 年 " + target.month.toString() + " 月 " + target.day.toString() + "日";
        });
      }
    }else{
      // 开始时间比结束时间迟
      if(target.toUtc().difference(endDate).inDays > 0){
        showToast("开始时间不可以比结束时间迟");
        return;
      }else{
        setState(() {
          startDate = target;
          startDateStr = target.year.toString() + " 年 " + target.month.toString() + " 月 " + target.day.toString() + "日";
        });
      }
    }
  }

  Future initAllStudents() async {
    dynamic res = await AccessDio.getAllStudent();
    setState(() {
      users = res;
      for(dynamic el in res){
        userSelects.add(false);
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("标题",style: TextStyle(fontSize: 24, color: Colors.black87)),
                      SizedBox(
                        width: 380,
                        height: 40,
                        child: TextField(
                          style: const TextStyle(fontSize: 25, color: Colors.black87),//文字大小、颜色
                          maxLines: 1,//最多多少行
                          minLines: 1,//最少多少行
                          onChanged: (text) {//输入框内容变化回调
                            setState(() {
                              title = text;
                            });
                          },
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 24,right: 24,top: 2,bottom: 6),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //去除下边框
                              hintText: "请描述⼀下您的标题（必填,1-20字）",
                              hintStyle: TextStyle(fontSize: 15)
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                        ),
                      )
                    ],
                  )
              ),
              const Divider(thickness: 2,height: 2,),
              SizedBox(
                width: 500,
                height: 260,
                child: TextField(
                  style: const TextStyle(fontSize: 25, color: Colors.black87),//文字大小、颜色
                  maxLines: 10,//最多多少行
                  minLines: 1,//最少多少行
                  onChanged: (text) {//输入框内容变化回调
                    body = text;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 24,right: 24,top: 2,bottom: 6),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ), //去除下边框
                      hintText: "请描述⼀下您的内容",
                      hintStyle: TextStyle(fontSize: 20)
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(500),
                  ],
                ),
              ),
              const Divider(thickness: 2,height: 2,),
              Container(
                height: 100,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("类型",style: TextStyle(fontSize: 24, color: Colors.black87)),
                    LayoutBuilder(
                        builder: (context, constraints){
                          if(isStu){
                            return DropdownButton(
                              style: const TextStyle(fontSize: 20,color: Colors.black87),
                              value: type,
                              items: [
                                DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        type =  "日报";
                                      });
                                    },
                                    value: "日报",
                                    child: const Text("日报")
                                ),
                                DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        type =  "周计划";
                                      });
                                    },
                                    value: "周计划",
                                    child: const Text("周计划")
                                ),
                                DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        type =  "月计划";
                                      });
                                    },
                                    value: "月计划",
                                    child: const Text("月计划")
                                ),
                                DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        type =  "学期计划";
                                      });
                                    },
                                    value: "学期计划",
                                    child: const Text("学期计划")
                                ),
                              ],
                              onChanged: (String? value) {  },
                            );
                          }else{
                            return const Text("任务",style: TextStyle(fontSize: 24, color: Colors.black87));
                          }
                        }
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 2,height: 2,),
              LayoutBuilder(
                  builder: (context, constraints){
                    if(!isStu){
                      return Column(
                        children: [
                          Container(
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("开始时间",style: TextStyle(fontSize: 24, color: Colors.black87)),
                                GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2000,1,1),
                                        maxTime: DateTime(2099,12,1),
                                        onConfirm: (date) {
                                          changeDate(false, date);
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.zh
                                    );
                                  },
                                  child: Text(startDateStr,style: const TextStyle(fontSize: 24, color: Colors.black87)),
                                )
                              ],
                            ),
                          ),
                          const Divider(thickness: 2,height: 2,),
                          Container(
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("结束时间",style: TextStyle(fontSize: 24, color: Colors.black87)),
                                GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2000,1,1),
                                      maxTime: DateTime(2099,12,1),
                                      onConfirm: (date) {
                                        changeDate(true, date);
                                      },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.zh
                                    );
                                  },
                                  child: Text(endDateStr,style: const TextStyle(fontSize: 24, color: Colors.black87)),
                                )
                              ],
                            ),
                          ),
                          const Divider(thickness: 2,height: 2,),
                          Container(
                            height: 500,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text("任务成员",style: TextStyle(fontSize: 24, color: Colors.black87)),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  height: 400,
                                  child: FutureBuilder(
                                    future: _futureBuilderMethod,
                                    builder: (context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting) {
                                        return LoadingDialog();
                                      }else if(snapshot.connectionState == ConnectionState.done) {
                                        return AnimationLimiter(
                                            child: GridView.builder(
                                              shrinkWrap: false,
                                              physics: const BouncingScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                //横轴元素个数
                                                  crossAxisCount: 4,
                                                  //纵轴间距
                                                  mainAxisSpacing: 10.0,
                                                  //横轴间距
                                                  crossAxisSpacing: 10.0,
                                                  //子组件宽高长度比例
                                                  childAspectRatio: 0.75
                                              ), 
                                              itemCount: users.length,
                                              itemBuilder: (BuildContext context, int index) { 
                                                return AnimationConfiguration.staggeredGrid(
                                                  position: index,
                                                  columnCount: users.length,
                                                  child: SlideAnimation(
                                                    verticalOffset: 50,
                                                    child: FadeInAnimation(
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Stack(
                                                          children: [
                                                            SizedBox(
                                                              width: 80,
                                                              height: 80,
                                                              child: CircleAvatar(
                                                                backgroundImage: NetworkImage(UrlSetting.IMAGE_URL_FILENAME+users[index]["headicon"]),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  userSelects[index] = !userSelects[index];
                                                                  if(userSelects[index]) {
                                                                    selectUsersIndex.add(index);
                                                                  }else{
                                                                    selectUsersIndex.remove(index);
                                                                  }
                                                                });
                                                              },
                                                              child: Container(
                                                                  alignment: Alignment.center,
                                                                  width: 30,
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                      color: userSelects[index]?Colors.red:Theme.of(context).primaryColor,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                      border: Border.all(
                                                                          color: Colors.white,
                                                                          width: 3
                                                                      )
                                                                  ),
                                                                  margin: const EdgeInsets.only(top: 70),
                                                                  child: Icon(
                                                                    userSelects[index]?CupertinoIcons.minus:CupertinoIcons.add,
                                                                    size: 20,
                                                                    color: Colors.white,
                                                                  )
                                                              )
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets.only(top: 100),
                                                              child: Text(users[index]["username"],style: const TextStyle(color: Colors.black87),),
                                                            )
                                                          ],
                                                          alignment: Alignment.topCenter,
                                                        ),
                                                      )
                                                    ),
                                                  )
                                                );
                                              },
                                            )
                                        );
                                      }else{
                                        return const SizedBox();
                                      }
                                    },
                                  )
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          const Divider(thickness: 2,height: 2,),
                        ],
                      );
                    }
                    return const SizedBox();
                  }
              ),
              const SizedBox(height: 100,),
              SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                    ),
                    onPressed: () async {
                      if(verify()){
                        if(!isStu){
                          if(startDateStr == "- 年 - 月 - 日" || endDateStr == "- 年 - 月 - 日") {
                            showToast("请确认选择了开始，结束时间");
                          }else{
                            if(selectUsersIndex.isEmpty) {
                              showToast("请确认选择了任务成员");
                            }else{
                              String members = "";
                              for(int index in selectUsersIndex) {
                                members = members + users[index]["username"] + ",";
                              }
                              String startdate = startDate.year.toString() + "-" +
                                  (startDate.month.toString().length==1?"0"+startDate.month.toString():startDate.month.toString()) + "-" +
                                  (startDate.day.toString().length==1?"0"+startDate.day.toString():startDate.day.toString());
                              String enddate = startDate.year.toString() + "-" +
                                  (endDate.month.toString().length==1?"0"+endDate.month.toString():endDate.month.toString()) + "-" +
                                  (endDate.day.toString().length==1?"0"+endDate.day.toString():endDate.day.toString());
                              String tmembers = members.substring(0,members.length-1);
                              publishTask(startdate,enddate,tmembers);
                            }
                          }
                        }else if(type == "日报"){
                          report();
                        }else{
                          publishPlan();
                        }
                      }else{
                        showToast("请确认填写内容");
                      }
                    },
                    child: const Text("发 布",
                      style: TextStyle(fontSize: 20,color: Colors.black87),
                    ),
                  )
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                      builder: (context, constraints) {
                        if(isAdmin){
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("老师",style: Theme.of(context).textTheme.bodyText1,),
                              CupertinoSwitch(
                                value: isStu,
                                onChanged: (bool value) {
                                  setState(() {
                                    isStu = value;
                                  });
                                },
                              ),
                              Text("学生",style: Theme.of(context).textTheme.bodyText1,),
                            ],
                          );
                        }
                        return const SizedBox();
                      }
                  ),
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: isLoading,
          child: LoadingDialog()
        )
      ],
    );
  }
}
