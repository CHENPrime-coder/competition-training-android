import 'dart:convert';

import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/ProgressLine.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PersonScoreContent extends StatefulWidget {
  PersonScoreContent({Key? key}) : super(key: key);

  @override
  State<PersonScoreContent> createState() => _PersonScoreContentState();
}

class _PersonScoreContentState extends State<PersonScoreContent> {

  late Map<String, dynamic> score;
  late List<String> projectNames;
  late List<dynamic> projectScores;

  @override
  void initState() {
    setState(() {
      score = CurrentScore.score;
      projectNames = jsonDecode(score["score"]).keys.toList();
      projectScores = jsonDecode(score["score"]).values.toList();
    });
    super.initState();
  }

  Color getColor(int progress) {
    if(progress < 60) {
      return Colors.red;
    }else if(progress < 80) {
      return Colors.orange;
    }
    return Colors.lightGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("成绩内容", context),
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(score["info"], style: const TextStyle(fontSize: 25,color: Colors.black87),),
                    Text(score["date"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst("-", " 月 ")+" 日",
                      style: const TextStyle(fontSize: 15,color: Colors.black87),),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  height: 500,
                  child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: projectNames.length,
                        itemBuilder: (BuildContext context,int index) {
                          if(projectScores[index].isEmpty){
                            return const SizedBox();
                          }
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(projectNames[index]+"：",style: const TextStyle(fontSize: 15,color: Colors.black87),),
                                            Text(projectScores[index].toString()+"分",style: const TextStyle(fontSize: 15,color: Colors.black87),),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        ProgressLine(
                                          completionScheduleColor: getColor(int.parse(projectScores[index])),
                                          progress: int.parse(projectScores[index]) ,
                                        ),
                                      ],
                                    )
                                  )
                                ),
                              )
                          );
                        },
                      )
                  )
                )
              ],
            ),
          )
      )
    );
  }
}

