import 'package:ct_android_plus/apis/PublishDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReleaseStatusPage extends StatefulWidget {
  ReleaseStatusPage({Key? key}) : super(key: key);

  @override
  State<ReleaseStatusPage> createState() => _ReleaseStatusPageState();
}

class _ReleaseStatusPageState extends State<ReleaseStatusPage> {

  late int month;
  late int year;
  bool isLoading = false;
  late DateTime firstDatePerMonth;
  late int daysCount;
  late int emptyCount;

  late int lastStart;
  int nextStart = 0;

  late List<int> days;

  List<Color> colors = [
    Colors.black87,
    const Color.fromRGBO(248,200,34,1),
    const Color.fromRGBO(42,248,34,1),
    const Color.fromRGBO(248,34,34,1),
    const Color.fromRGBO(195,34,248,1),
  ];

  @override
  void initState() {
    setState(() {
      DateTime now = DateTime.now();
      month = now.month;
      year = now.year;
      getMonthDays();
    });
    super.initState();
  }

  void lastMonth() {
    if(month == 1){
      setState(() {
        month = 12;
        year --;
      });
    }else{
      setState(() {
        month --;
      });
    }
    getMonthDays();
  }
  void nextMonth() {
    if(month == 12){
      setState(() {
        month = 1;
        year ++;
      });
    }else{
      setState(() {
        month ++;
      });
    }
    getMonthDays();
  }

  void getMonthDays() async {
    firstDatePerMonth = DateTime(year, month, 1);
    DateTime last = DateTime(year, month-1, 1);

    DateTime next = DateTime(year, month+1, 1);
    setState(() {
      daysCount = firstDatePerMonth.difference(next).inDays.abs();
      emptyCount = firstDatePerMonth.weekday;

      int lastDaysCount = firstDatePerMonth.difference(last).inDays.abs();

      lastStart = lastDaysCount - emptyCount;
      nextStart = 0;
    });
    setState(() {
      isLoading = true;
    });
    String monthStr = month.toString().length == 1?"0"+month.toString():month.toString();
    String yearStr = year.toString();
    dynamic res = await PublishDio.getReleaseStatus(yearStr+monthStr,CurrentUser.user["username"]);
    days = [];
    for(int i=0;i<res["yearplan"].length;i++){
      int tag = 0;
      if(res["daily"][i]=="1"){
        tag = 1;
      }
      if(res["weekplan"][i]=="1"){
        tag = 2;
      }
      if(res["monthplan"][i]=="1"){
        tag = 3;
      }
      if(res["yearplan"][i]=="1"){
        tag = 4;
      }
      days.add(tag);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("发布情况", context),
      body: Container(
        margin: const EdgeInsets.all(50),
        height: 600,
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: (){
                      lastMonth();
                    },
                    icon: const Icon(CupertinoIcons.left_chevron,color: Colors.white,)
                  ),
                  Text(year.toString()+"年"+month.toString()+"月",style: const TextStyle(fontSize: 20),),
                  IconButton(
                    onPressed: (){
                      nextMonth();
                    },
                    icon: const Icon(CupertinoIcons.right_chevron,color: Colors.white,)
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text("日",style: TextStyle(color: Colors.black87),),
                  Text("一",style: TextStyle(color: Colors.black87),),
                  Text("二",style: TextStyle(color: Colors.black87),),
                  Text("三",style: TextStyle(color: Colors.black87),),
                  Text("四",style: TextStyle(color: Colors.black87),),
                  Text("五",style: TextStyle(color: Colors.black87),),
                  Text("六",style: TextStyle(color: Colors.black87),),
                ],
              )
            ),
            SizedBox(
              height: 330,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if(isLoading) {
                    return LoadingDialog();
                  }
                  return GridView.builder(
                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                        crossAxisCount: 7,
                        //纵轴间距
                        mainAxisSpacing: 8.0,
                        //横轴间距
                        crossAxisSpacing: 8.0,
                        //子组件宽高长度比例
                        childAspectRatio: 1
                    ),
                    itemCount: 42,
                    itemBuilder: (context, index) {
                      if(index < emptyCount){
                        return Container(
                          alignment: Alignment.center,
                          child: Text((++lastStart).toString(),textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,color: Colors.grey),),
                        );
                      }
                      if(index > daysCount+emptyCount-1){
                        return Container(
                          alignment: Alignment.center,
                          child: Text((++nextStart).toString(),textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,color: Colors.grey),),
                        );
                      }
                      return Container(
                        alignment: Alignment.center,
                        child: Text((index+1-emptyCount).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: colors[days[index-emptyCount]]),),
                      );
                    },
                  );
                },
              )
            ),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors[1],
                            borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Text("日报",style: Theme.of(context).textTheme.bodyText1,)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: colors[2],
                              borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Text("周计划",style: Theme.of(context).textTheme.bodyText1,)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: colors[3],
                              borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Text("月计划",style: Theme.of(context).textTheme.bodyText1,)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: colors[4],
                              borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Text("学期计划",style: Theme.of(context).textTheme.bodyText1,)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

