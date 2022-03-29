import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../utils/UrlSettings.dart';

class MemberGridView extends StatefulWidget {
  List<String> members;

  MemberGridView({Key? key, required this.members}) : super(key: key);

  @override
  State<MemberGridView> createState() => _MemberGridViewState();
}

class _MemberGridViewState extends State<MemberGridView> {
  late var _futureBuilderMethod;
  late List<dynamic> users;

  @override
  void initState() {
    _futureBuilderMethod = initData();
    super.initState();
  }

  Future initData() async {
    List<dynamic> res = await PersonalDio.getAllUsersPersonalByNameNoKeys(widget.members);
    setState(() {
      users = res;
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderMethod,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return LoadingDialog(opacity: 0,);
        }else if (snapshot.connectionState == ConnectionState.done){
          return AnimationLimiter(
              child: GridView.builder(
                shrinkWrap: false,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //横轴元素个数
                    crossAxisCount: 5,
                    //纵轴间距
                    mainAxisSpacing: 10.0,
                    //横轴间距
                    crossAxisSpacing: 10.0,
                    //子组件宽高长度比例
                    childAspectRatio: 0.8
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: widget.members.length,
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: GestureDetector(
                                  onTap: () {
                                    CurrentUser.selectUser = users[index];
                                    Navigator.pushNamed(context, "/other/person");
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+users[index]["headiconURL"]),
                                  ),
                                )
                              ),
                              const SizedBox(height: 5,),
                              Text(users[index]["username"],style: const TextStyle(color: Colors.black87),)
                            ],
                          )
                        )
                      )
                    )
                  );
                },
                itemCount: widget.members.length,
              ),
            );
        }else{
          return const SizedBox();
        }
      }
    );
  }
}

