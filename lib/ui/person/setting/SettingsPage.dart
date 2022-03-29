import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Future<String?> _show(BuildContext context) {
    return showDialog(
      context: context,
      builder:(context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("确定要退出登陆吗?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context,"false");
                },
                child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context,"true");
              },
              child: const Text("确认",style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("设置", context),
      body: Column(
        children: [
          const Divider(height: 5,thickness: 2,),
          ListTile(
            onTap: () async {
              var dialog = await _show(context);
              if (dialog == "true") {
                while(Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            leading: const Icon(Icons.logout),
            title: const Text("退出登陆"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(height: 2,thickness: 2,),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "/setting/change/user/img");
            },
            leading: const Icon(CupertinoIcons.person),
            title: const Text("修改头像"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(height: 2,thickness: 2,),
        ],
      ),
    );
  }
}

