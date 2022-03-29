import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MembersSettingPage extends StatefulWidget {
  MembersSettingPage({Key? key}) : super(key: key);

  @override
  State<MembersSettingPage> createState() => _MembersSettingPageState();
}

class _MembersSettingPageState extends State<MembersSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("工作室设置", context),
      body: Column(
        children: [
          const Divider(thickness: 2,height: 2,),
          ListTile(
            leading: const Icon(CupertinoIcons.photo),
            title: const Text("修改工作室头像"),
            onTap: () {
              Navigator.pushNamed(context, "/members/setting/change/head");
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(thickness: 2,height: 2,)
        ],
      ),
    );
  }
}

