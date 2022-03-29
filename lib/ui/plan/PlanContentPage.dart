import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../apis/PersonalDio.dart';

class PlanContentPage extends StatefulWidget {
  PlanContentPage({Key? key}) : super(key: key);

  @override
  State<PlanContentPage> createState() => _PlanContentPageState();
}

class _PlanContentPageState extends State<PlanContentPage> {

  late Map<String, dynamic> plan;
  late var _futureBuilderMethod;
  late Map<String, dynamic> user;

  @override
  void initState() {
    if(!mounted){
      return;
    }
    setState(() {
      plan = CurrentPlan.plan;
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await PersonalDio.getUserByName(plan["planner"]);

    setState(() {
      user = res;
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("计划信息", context),
      body: FutureBuilder(
        future: _futureBuilderMethod,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingDialog();
          }else if(snapshot.connectionState == ConnectionState.done){
            return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(plan["pname"], style: const TextStyle(fontSize: 25,color: Colors.black87),),
                          Text(plan["pdate"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst("-", " 月 ")+" 日",
                            style: const TextStyle(fontSize: 15,color: Colors.black87),),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+user["headiconURL"]),
                          ),
                          const SizedBox(width: 10,),
                          Text(plan["planner"], style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(plan["pbody"], style: Theme.of(context).textTheme.headline2,),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Chip(label: Text("coming soon"))
                        ],
                      )
                    ],
                  ),
                )
            );
          }else{
            return const SizedBox();
          }
        },
      ),
    );
  }
}

