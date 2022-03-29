import 'package:ct_android_plus/apis/AccessDio.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:flutter/material.dart';

import '../components/LoadingDialog.dart';
import '../utils/ToastUtils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _password;
  late String _username;

  bool isLoading = false;
  final GlobalKey<FormState> _loginformkey = GlobalKey<FormState>();

  loginValidator(value, type) {
    var tag = "";
    if (type == "password") {
      tag = "密码";
    } else if (type == "username") {
      tag = "账号";
    }
    if (value.toString().isEmpty || value.toString().length > 20) {
      return tag + '非法';
    } else {
      _loginformkey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height/2.2,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("lib/images/home_title.png",width: 130,height: 130,)],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: height/3.25),
                width: width/1.35,
                height: 300,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 5,color: Color.fromRGBO(0, 0, 0, 0.26))],
                    borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                child: Form(
                    key: _loginformkey,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30,15,30,0),
                      child: Column(
                        children: [
                          const Text("登陆",style: TextStyle(fontSize: 30, color: Colors.black87),),
                          const SizedBox(height: 20,),
                          TextFormField(
                            onSaved: (value) {
                              _username = value!;
                            },
                            validator: (value) => loginValidator(value,"username"),
                            autofocus: true,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              label: Text("账号"),
                              hintText: "请输入账号",
                              filled: true,
                              fillColor: Colors.white,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            onSaved: (value) {
                              _password = value!;
                            },
                            validator: (value) => loginValidator(value,"password"),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              label: Text("密码"),
                              hintText: "请输入密码",
                              filled: true,
                              fillColor: Colors.white,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: height/1.5),
            child: Center(
              child: SizedBox(
                width: width/1.2,
                height: height/14,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                  ),
                  onPressed: () {
                    if(_loginformkey.currentState!.validate()){
                      setState(() {
                        isLoading = true;
                      });
                      AccessDio.login(_username, _password).then((value) {
                        if(value){
                          CurrentUser.username = _username;
                          CurrentUser.password = _password;
                          Navigator.pushNamed(context, "/main");
                          showToast("登陆成功");
                        }else{
                          showToast("登陆失败");
                        }
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                  },
                  child: const Text("开始竞训",
                    style: TextStyle(fontSize: 20,color: Colors.black87),
                  ),
                ),
              )
            ),
          ),
          Visibility(
              visible: isLoading,
              child: LoadingDialog()
          )
        ],
      ),
    );
  }
}

