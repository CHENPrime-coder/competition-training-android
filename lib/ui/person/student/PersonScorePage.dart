import 'dart:convert';

import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PersonScorePage extends StatefulWidget {
  PersonScorePage({Key? key}) : super(key: key);

  @override
  State<PersonScorePage> createState() => _PersonScorePageState();
}

class _PersonScorePageState extends State<PersonScorePage> {

  late var _futureBuilderMethod;
  late List<dynamic> scores;

  @override
  void initState() {
    setState(() {
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    String uid = CurrentUser.user["uid"].toString();
    dynamic res = await PersonalDio.getAllScore(uid);

    setState(() {
      scores = res;
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("成绩", context),
      body: FutureBuilder(
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
                            height: 120,
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
        }
      ),
    );
  }
}

