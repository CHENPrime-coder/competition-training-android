import 'dart:convert';

import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PersonPublishScorePage extends StatefulWidget {
  PersonPublishScorePage({Key? key}) : super(key: key);

  @override
  State<PersonPublishScorePage> createState() => _PersonPublishScorePageState();
}

class _PersonPublishScorePageState extends State<PersonPublishScorePage> {

  late var _futureBuilderMethod;
  late List<dynamic> scores;
  late Map<String, dynamic> users;

  @override
  void initState() {
    setState(() {
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await PersonalDio.getAllScoreByTeacher(CurrentUser.user["username"]);

    if(!mounted){
      return;
    }
    setState(() {
      scores = res;
    });

    return await initUser(res);
  }

  Future initUser(List<dynamic> score) async {
    List<int> ids = [];
    List<String> keys = [];

    for(dynamic score in scores) {
      ids.add(score["uid"]);
      keys.add(score["pfmid"].toString());
    }
    dynamic res = await PersonalDio.getAllUsersPersonalById(ids, keys);
    if(!mounted){
      return;
    }
    setState(() {
      users = res;
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderMethod,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return LoadingDialog();
        }else if(snapshot.connectionState == ConnectionState.done){
          return AnimationLimiter(
              child: ListView.builder(
                  itemCount: scores.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                        position: scores.length - index - 1,
                        duration: const Duration(milliseconds: 560),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10,10,10,0),
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(scores[index]["info"],style: const TextStyle(color: Colors.black87,fontSize: 25),),
                                        Text(scores[index]["date"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst("-", " 月 ")+" 日",
                                          style: const TextStyle(color: Colors.black87,fontSize: 15),)
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+users[scores[index]["pfmid"].toString()]["headiconURL"]),
                                        ),
                                        const SizedBox(width: 10,),
                                        Text(users[scores[index]["pfmid"].toString()]["username"],style: const TextStyle(color: Colors.black87),)
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(jsonDecode(scores[index]["score"]).keys.toString().replaceFirst("(", "").replaceFirst(")", ""),
                                          style: const TextStyle(color: Colors.grey,fontSize: 15),),
                                        ElevatedButton(
                                          onPressed: () {
                                            CurrentScore.score = scores[index];
                                            Navigator.pushNamed(context, "/person/score/content");
                                          },
                                          child: const Text("查看", style: TextStyle(color: Colors.black87),),
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    );
                  }
              )
          );
        }else{
          return const SizedBox();
        }
      },
    );
  }
}

