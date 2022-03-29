import 'package:ct_android_plus/apis/StudioDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PublishScorePage extends StatefulWidget {
  PublishScorePage({Key? key}) : super(key: key);

  @override
  State<PublishScorePage> createState() => _PublishScorePageState();
}

class _PublishScorePageState extends State<PublishScorePage> {

  String dateStr = "- 年 - 月 - 日";
  DateTime dateEl = DateTime.now();
  int selectStudio = 0;
  List<dynamic> studios = [];
  List<String> studioNames = [];
  late var _futureBuilderMethod;
  String inputSubject = "";
  List<String> subjects = [];
  String info = "";

  @override
  void initState() {
    if(!mounted){
      return;
    }
    setState(() {
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await StudioDio.getAllStudios();

    if(!mounted){
      return;
    }
    setState(() {
      studios = res;
    });
    for(dynamic studio in res) {
      studioNames.add(studio["sname"]);
    }
    setState(() {
      selectStudio = 0;
    });

    return res;
  }

  List<DropdownMenuItem<int>> getDropdownButtonItems() {
    List<DropdownMenuItem<int>> res = [];

    for(int i=0;i<studios.length;i++){
      res.add(
          DropdownMenuItem(
            onTap: () {
              setState(() {
                selectStudio = i;
              });
            },
            value: i,
            child: Text(studios[i]["sname"]),
          )
      );
    }

    return res;
  }

  subjectNameValidator() {
    if (inputSubject.toString().isEmpty || inputSubject.toString().length > 20 ) {
      return false;
    } else {
      if(subjects.contains(inputSubject)){
        return false;
      }
      return true;
    }
  }

  verify() {
    if(subjects.isEmpty){
      showToast("请选择科目");
    }else if(dateStr=="- 年 - 月 - 日"){
      showToast("请选择日期");
    }else if(info.isEmpty){
      showToast("请填写说明");
    }else{
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("录入成绩", context),
      body: FutureBuilder(
        future: _futureBuilderMethod,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingDialog();
          }else if(snapshot.connectionState == ConnectionState.done){
            return       Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("说明",style: TextStyle(fontSize: 24, color: Colors.black87)),
                        SizedBox(
                          width: 380,
                          height: 40,
                          child: TextField(
                            style: const TextStyle(fontSize: 25, color: Colors.black87),//文字大小、颜色
                            maxLines: 1,//最多多少行
                            minLines: 1,//最少多少行
                            onChanged: (text) {//输入框内容变化回调
                              setState(() {
                                info = text;
                              });
                            },
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 24,right: 24,top: 2,bottom: 6),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ), //去除下边框
                                hintText: "考核说明（必填,1-20字）",
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
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("考核时间",style: TextStyle(fontSize: 24, color: Colors.black87)),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000,1,1),
                              maxTime: DateTime(2099,12,1),
                              onConfirm: (date) {
                                setState(() {
                                  dateEl = date;
                                  dateStr = date.year.toString() + " 年 " + date.month.toString() + " 月 " + date.day.toString() + "日";
                                });
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.zh
                          );
                        },
                        child: Text(dateStr,style: const TextStyle(fontSize: 24, color: Colors.black87)),
                      ),
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
                      const Text("考核工作室",style: TextStyle(fontSize: 24, color: Colors.black87)),
                      DropdownButton(
                        style: const TextStyle(fontSize: 20,color: Colors.black87),
                        value: selectStudio,
                        items: getDropdownButtonItems(),
                        onChanged: (int? value) {  },
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
                      const Text("考核科目",style: TextStyle(fontSize: 24, color: Colors.black87)),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              inputSubject = value;
                            });
                          },
                          autofocus: true,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text("科目名"),
                            hintText: "科目名",
                            filled: true,
                            border:OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                            ),
                            onPressed: () {
                              if(subjectNameValidator()){
                                setState(() {
                                  subjects.add(inputSubject);
                                });
                              }else{
                                showToast("要添加的科目名不可为空，长度不可大于20，不可重复");
                              }
                            },
                            child: const Text("添加",
                              style: TextStyle(fontSize: 20,color: Colors.black87),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(20,0,20,20),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: subjects.length,
                    itemBuilder: (context,index) {
                      return Container(
                        height: 60,
                        margin: const EdgeInsets.fromLTRB(10,0,10,0),
                        color: Theme.of(context).primaryColor,
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            children: [
                              Text(subjects[index],style: const TextStyle(fontSize: 20,color: Colors.black87),),
                              const SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    subjects.remove(subjects[index]);
                                  });
                                },
                                child: const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(CupertinoIcons.xmark,color: Colors.white,size: 30,),
                                ),
                              )
                            ],
                          )
                        ),
                      );
                    }
                  ),
                ),
                const Divider(thickness: 2,height: 2,),
                const SizedBox(height: 180,),
                SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                      ),
                      onPressed: () {
                        if(verify()){
                          CurrentPublishScore.subjects = subjects;
                          CurrentPublishScore.info = info;
                          CurrentPublishScore.date = dateEl;
                          CurrentPublishScore.studio =  studios[selectStudio];
                          Navigator.pushNamed(context, "/publish/pfm/content");
                        }
                      },
                      child: const Text("开始录入",
                        style: TextStyle(fontSize: 20,color: Colors.black87),
                      ),
                    )
                ),
              ],
            );
          }else{
            return const SizedBox();
          }
        },
      )
    );
  }
}

