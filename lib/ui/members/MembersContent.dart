import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/UrlSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/MemberGridView.dart';

class MembersContent extends StatefulWidget {
  MembersContent({Key? key}) : super(key: key);

  @override
  State<MembersContent> createState() => _MembersContentState();
}

class _MembersContentState extends State<MembersContent> {

  late var _futureBuilderMethod;
  late Map<String, dynamic> studio = {};
  late Map<String, dynamic> user = {};
  late List<String> members = [];

  @override
  void initState() {
    setState(() {
      studio = CurrentStudio.studio;
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await PersonalDio.getUserByName(studio["teacher"]);

    setState(() {
      user = res;
      members = studio["smembers"].toString().split(',');
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("工作室详情", context),
      body: FutureBuilder(
        future: _futureBuilderMethod,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingDialog();
          }else if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 180,
                      color: const Color.fromRGBO(247, 224, 144, 1),
                      child: Row(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 60, 0, 0),
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(UrlSetting.IMAGE_URL_FILENAME+studio["sheadicon"],),
                                fit: BoxFit.cover
                            ),
                            border: Border.all(
                                width: 2,
                                color: Colors.grey
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(studio["sname"],style: const TextStyle(fontSize: 30,color: Colors.black87,),textAlign: TextAlign.center,)
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 70,
                              height: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+user["headiconURL"]),
                              )
                          ),
                          const SizedBox(width: 10,),
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text("老师："+studio["teacher"],style: const TextStyle(fontSize: 30,color: Colors.black87),)
                          ),
                        ],
                      ),
                      Text("成员数："+members.length.toString(),style: const TextStyle(fontSize: 20,color: Colors.black87),)
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text("工作室成员：",style: TextStyle(fontSize: 20,color: Colors.black87),),
                ),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(10),
                  child: MemberGridView(members: members),
                ),
              ],
            );
          }else{
            return const SizedBox();
          }
        }
      ),
    );
  }
}

