import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PublishScoreContentPage extends StatefulWidget {
  PublishScoreContentPage({Key? key}) : super(key: key);

  @override
  State<PublishScoreContentPage> createState() => _PublishScoreContentPageState();
}

class _PublishScoreContentPageState extends State<PublishScoreContentPage> {
  late var _futureBuilderMethod;
  late List<dynamic> users;
  List<bool> unInput = [];
  List<bool> unSelect = [];
  Map<String,Map<String,String>> inputScores = {};
  bool isLoading = false;

  @override
  void initState() {
    _futureBuilderMethod = initData();
    super.initState();
  }

  Future initData() async {
    return initUser();
  }

  Future initUser() async {
    List<dynamic> res = await PersonalDio.getAllUsersPersonalByNameNoKeys(CurrentPublishScore.studio["smembers"].toString().split(","));
    setState(() {
      users = res;
    });
    for(dynamic user in users){
      unInput.add(false);
      unSelect.add(false);
      Map<String,String> initScore = {};
      for(dynamic subject in CurrentPublishScore.subjects){
        initScore[subject] = "";
      }
      inputScores.addAll({user["uid"].toString(): initScore});
    }

    return res;
  }

  void doPublishScore() async {
    setState(() {
      isLoading = true;
    });
    dynamic res = await PersonalDio.publishScores(
        inputScores,
        CurrentPublishScore.info,
        CurrentUser.user["username"],
        CurrentPublishScore.date
    );
    setState(() {
      isLoading = false;
    });

    if(res){
      showToast("发布成功");
      Navigator.pop(context);
      Navigator.pop(context);
    }else{
      showToast("发布失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(CupertinoIcons.back), iconSize: 35, color: Colors.black87,),
        backgroundColor: const Color.fromRGBO(248, 200, 34, 1),
        centerTitle: true,
        title: const Text("录入成绩",style: TextStyle(color: Colors.black87),),
        actions: [
          TextButton(
            onPressed: () {
              if(unInput.contains(false)){
                showToast("请确认填写完整");
              }else if(isLoading){
                showToast("请勿重复提交");
              }else{
                doPublishScore();
              }
            },
            child: const Text("确认录入",style: TextStyle(color: Colors.white,fontSize: 20),)
          )
        ],
      ),
      body: FutureBuilder(
        future: _futureBuilderMethod,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingDialog();
          }else if(snapshot.connectionState == ConnectionState.done){
            return Stack(
              children: [
                AnimationLimiter(
                    child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: CircleAvatar(
                                                          backgroundImage: NetworkImage(UrlSetting.IMAGE_URL + users[index]["headiconURL"]),
                                                        )
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    Text(users[index]["username"],style: const TextStyle(color: Colors.black87,fontSize: 25),),
                                                    const SizedBox(width: 10,),
                                                    Chip(
                                                      label: Text(unInput[index]?"已录入":"未录入"),
                                                      backgroundColor: unInput[index]?Theme.of(context).primaryColor:Colors.grey[260],
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      unSelect[index] = !unSelect[index];
                                                      unInput[index] = !inputScores[users[index]["uid"].toString()]!.values.toList().contains("");
                                                    });
                                                  },
                                                  icon: Icon(unSelect[index]?CupertinoIcons.chevron_down:CupertinoIcons.right_chevron,size: 30,),
                                                )
                                              ],
                                            )
                                        ),
                                        Visibility(
                                            visible: unSelect[index],
                                            child: SingleChildScrollView(
                                                child: Container(
                                                    height: 200,
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    child: ListView.builder(
                                                        physics: const BouncingScrollPhysics(),
                                                        itemCount: CurrentPublishScore.subjects.length,
                                                        itemBuilder: (context, innerIndex){
                                                          return Container(
                                                            height: 50,
                                                            margin: const EdgeInsets.fromLTRB(100,10,100,10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(CurrentPublishScore.subjects[innerIndex]+":",style: const TextStyle(color: Colors.black87,fontSize: 20),),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 50,
                                                                      child: TextField(
                                                                        style: const TextStyle(
                                                                            fontSize: 25
                                                                        ),
                                                                        scrollPadding:EdgeInsets.zero,
                                                                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                                                                        decoration: const InputDecoration(
                                                                          contentPadding: EdgeInsets.zero,
                                                                          isDense: true,
                                                                        ),
                                                                        onChanged: (value){
                                                                          if(value.length<3 || value.isEmpty){
                                                                            inputScores[users[index]["uid"].toString()]![CurrentPublishScore.subjects[innerIndex]] = value;
                                                                          }else if(int.parse(value)>100){
                                                                            setState(() {
                                                                              inputScores[users[index]["uid"].toString()]![CurrentPublishScore.subjects[innerIndex]] = "100";
                                                                            });
                                                                          }
                                                                        },
                                                                        controller: TextEditingController(
                                                                            text: inputScores[users[index]["uid"].toString()]![CurrentPublishScore.subjects[innerIndex]]
                                                                        ),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                                          LengthLimitingTextInputFormatter(3),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 10,),
                                                                    const Text("分",style: TextStyle(color: Colors.black87,fontSize: 20),),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                    )
                                                )
                                            )
                                        ),
                                        const Divider(height: 2,thickness: 2,)
                                      ],
                                    )
                                ),
                              )
                          );
                        }
                    )
                ),
                Visibility(
                    visible: isLoading,
                    child: LoadingDialog()
                ),
              ],
            );
          }else{
            return const SizedBox();
          }
        },
      ),
    );
  }
}

