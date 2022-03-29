import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/material.dart';

import '../../utils/UrlSettings.dart';

class DailyContentPage extends StatefulWidget {
  DailyContentPage({Key? key}) : super(key: key);

  @override
  State<DailyContentPage> createState() => _DailyContentPageState();
}

class _DailyContentPageState extends State<DailyContentPage> {

  late Map<String, dynamic> daily;
  late var _futureBuilderMethod;
  late Map<String, dynamic> user;

  @override
  void initState() {
    setState(() {
      daily = CurrentDaily.currentDaily;
      _futureBuilderMethod = initData();
    });
    super.initState();
  }

  Future initData() async {
    dynamic res = await PersonalDio.getUserByName(daily["reporter"]);

    setState(() {
      user = res;
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("日报内容", context),
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
                        Text(daily["dname"], style: const TextStyle(fontSize: 25,color: Colors.black87),),
                        Text(daily["ddate"].toString().substring(0,10).replaceFirst("-", " 年 ").replaceFirst("-", " 月 ")+" 日",
                          style: const TextStyle(fontSize: 15,color: Colors.black87),),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            CurrentUser.selectUser = user;
                            Navigator.pushNamed(context, "/other/person");
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(UrlSetting.IMAGE_URL+user["headiconURL"]),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text(daily["reporter"], style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(daily["dbody"], style: Theme.of(context).textTheme.headline2,),
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

