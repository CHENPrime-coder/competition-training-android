import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/apis/PublishDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PersonPlanPage extends StatefulWidget {
  PersonPlanPage({Key? key, required this.type}) : super(key: key);

  String type;

  @override
  State<PersonPlanPage> createState() => _PersonPlanPageState();
}

class _PersonPlanPageState extends State<PersonPlanPage> {

  late var _futureBuilderMethod;
  List<dynamic> plans = [];
  Map<String,dynamic> users = {};

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
    dynamic res = await PublishDio.getAllPlanWithUsernameAndType(widget.type,CurrentUser.selectUser["username"]);

    if(!mounted){
      return;
    }
    setState(() {
      plans = res;
    });

    return await initUser(res);
  }

  Future initUser(List<dynamic> plans) async {
    List<String> names = [];
    List<String> keys = [];
    for(int i=0;i<plans.length;i++){
      names.add(plans[i]["planner"]);
      keys.add(plans[i]["pid"].toString());
    }
    dynamic res = await PersonalDio.getAllUsersPersonalByName(names, keys);
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
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: _futureBuilderMethod,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingDialog();
                }else if(snapshot.connectionState == ConnectionState.done) {
                  return AnimationLimiter(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              duration: const Duration(milliseconds: 560 + 10*140),
                              position: index,
                              child: SlideAnimation(
                                  verticalOffset: 50,
                                  child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () {
                                          CurrentPlan.plan = plans[index];
                                          Navigator.pushNamed(context, "/plan");
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(plans[index]["pname"],style: const TextStyle(color: Colors.black87,fontSize: 15),),
                                                    Text(plans[index]["pdate"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst('-', " 月 ")+" 日",
                                                      style: const TextStyle(color: Colors.black87,fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5,),
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+users[plans[index]["pid"].toString()]["headiconURL"]),
                                                ),
                                                const SizedBox(height: 5,),
                                                Text(plans[index]["pbody"],maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.black87),),
                                                const Chip(label: Text("coming soon"))
                                              ],
                                            )
                                        ),
                                      )
                                  )
                              ),
                            );
                          }
                      )
                  );
                }else{
                  return const SizedBox();
                }
              }
          ),
        )
      ],
    );
  }
}

