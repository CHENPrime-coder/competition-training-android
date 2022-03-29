import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/apis/StudioDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PersonStudioPage extends StatefulWidget {
  PersonStudioPage({Key? key}) : super(key: key);

  @override
  State<PersonStudioPage> createState() => _PersonStudioPageState();
}

class _PersonStudioPageState extends State<PersonStudioPage> {

  late List<dynamic> studios;
  late Map<String, dynamic> users;
  late var _futureBuilderMethod;

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
    dynamic res = await StudioDio.getAllStudioByTeacher(CurrentUser.user["username"]);

    if(!mounted){
      return;
    }
    setState(() {
      studios = res;
    });

    return await getUser(res);
  }

  Future getUser(List<dynamic> studios) async {
    List<String> names = [];
    List<String> keys = [];
    for(dynamic studio in studios){
      names.add(studio["teacher"]);
      keys.add(studio["sid"].toString());
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
    return FutureBuilder(
      future: _futureBuilderMethod,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return LoadingDialog();
        }else if(snapshot.connectionState == ConnectionState.done){
          return AnimationLimiter(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: studios.length,
                itemBuilder: (BuildContext context,int index) {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 560),
                      child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20,20,20,0),
                                width: 500,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context).primaryColor
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(50)),
                                      child: Image.network(UrlSetting.IMAGE_URL_FILENAME+studios[index]["sheadicon"],
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(studios[index]["sname"],style: Theme.of(context).textTheme.headline5,),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(0,10,0,10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+users[studios[index]["sid"].toString()]["headiconURL"]),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Text(studios[index]["teacher"],style: Theme.of(context).textTheme.headline6,),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 180,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 85,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                                                        ),
                                                        onPressed: () {
                                                          CurrentStudio.studio = studios[index];
                                                          Navigator.pushNamed(context, "/members/setting");
                                                        },
                                                        child: const Text("设置", style: TextStyle(fontSize: 20,color: Colors.black87),)
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 85,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                                                        ),
                                                        onPressed: () {
                                                          CurrentStudio.studio = studios[index];
                                                          Navigator.pushNamed(context, "/members/content");
                                                        },
                                                        child: const Text("查看", style: TextStyle(fontSize: 20,color: Colors.black87),)
                                                    ),
                                                  )
                                                ],
                                              )
                                            )
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      )
                  );
                },
              )
          );
        }else{
          return const SizedBox();
        }
      }
    );
  }
}

