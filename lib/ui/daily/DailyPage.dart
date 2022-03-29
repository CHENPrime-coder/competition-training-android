import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/apis/PublishDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../utils/CurrentObjects.dart';
import '../../utils/UrlSettings.dart';

class DailyPage extends StatefulWidget {
  DailyPage({Key? key}) : super(key: key);

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {

  late var _futureBuilderMethod;
  late var _futureBuilderNoPunched;
  bool unPunchVisibility = false;
  List<dynamic> dailies = [];
  List<dynamic> noPunchPerson = [];
  Map<String,dynamic> users = {};

  @override
  void initState() {
    if(!mounted){
      return;
    }
    setState(() {
      _futureBuilderMethod = initData();
      _futureBuilderNoPunched = initUnPunch();
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await PublishDio.getAllDaily();
    if(!mounted){
      return;
    }
    setState(() {
      dailies = res;
    });

    return await initUser(res);
  }

  Future initUser(List<dynamic> dailies) async {
    List<String> names = [];
    List<String> keys = [];
    for(int i=0;i<dailies.length;i++){
      names.add(dailies[i]["reporter"]);
      keys.add(dailies[i]["did"].toString());
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

  Future initUnPunch() async {
    dynamic res = await PublishDio.getNoPunch();

    if(!mounted){
      return;
    }
    setState(() {
      noPunchPerson = res;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              Container(
                height: unPunchVisibility ? 170 : 30,
                color: const Color.fromRGBO(247, 224, 144, 0.7),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      width: constraints.maxWidth,
                      child: GestureDetector(
                       onTap: () {
                         setState(() {
                           unPunchVisibility = !unPunchVisibility;
                         });
                       },
                       child: Icon(unPunchVisibility ?
                       CupertinoIcons.chevron_up :
                       CupertinoIcons.chevron_down,color: Colors.grey,),
                      )
                    ),
                    Visibility(
                      visible: unPunchVisibility,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text("昨日未发日报:", style: Theme.of(context).textTheme.bodyText1,),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 90,
                            width: constraints.maxWidth,
                            child: FutureBuilder(
                              future: _futureBuilderNoPunched,
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting) {
                                  return LoadingDialogSized(
                                    size: const Size(50,50),
                                  );
                                }else if(snapshot.connectionState == ConnectionState.done) {
                                  return AnimationLimiter(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: noPunchPerson.length,
                                          itemBuilder: (context, index) {
                                            return AnimationConfiguration.staggeredList(
                                              duration: const Duration(milliseconds: 560),
                                              position: index,
                                              child: SlideAnimation(
                                                  verticalOffset: 50,
                                                  child: FadeInAnimation(
                                                    child: Container(
                                                      margin: const EdgeInsets.only(left: 10),
                                                      width: 70,
                                                      height: 90,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 60,
                                                            height: 60,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                CurrentUser.selectUser = noPunchPerson[index];
                                                                Navigator.pushNamed(context, "/other/person");
                                                              },
                                                              child: CircleAvatar(
                                                                backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+noPunchPerson[index]["headiconURL"]),
                                                              ),
                                                            )
                                                          ),
                                                          Text(noPunchPerson[index]["username"],style: const TextStyle(fontSize: 12, color: Colors.black87),)
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            );
                                          }
                                      )
                                  );
                                }else{
                                  return const SizedBox();
                                }
                              },
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
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
                          itemCount: dailies.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              duration: const Duration(milliseconds: 560 + 10*140),
                              position: index,
                              child: SlideAnimation(
                                  verticalOffset: 50,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        CurrentDaily.currentDaily = dailies[dailies.length-index-1];
                                        Navigator.pushNamed(context, "/daily/content");
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(dailies[dailies.length-index-1]["dname"],style: const TextStyle(color: Colors.black87,fontSize: 15),),
                                                  Text(dailies[dailies.length-index-1]["ddate"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst('-', " 月 ")+" 日",
                                                    style: const TextStyle(color: Colors.black87,fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+users[dailies[dailies.length-index-1]["did"].toString()]["headiconURL"]),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(dailies[dailies.length-index-1]["dbody"],maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black87),),
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
          )

        );
      },
    );


  }
}

