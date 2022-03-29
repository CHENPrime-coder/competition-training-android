import 'dart:io';

import 'package:ct_android_plus/routes/Routes.dart';
import 'package:ct_android_plus/ui/LoginPage.dart';
import 'package:ct_android_plus/ui/main/MainPage.dart';
import 'package:ct_android_plus/utils/LocalStorageUtils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isNotLogin = false;

  @override
  void initState() {
    super.initState();
    checkIsNotLogin();
  }

  checkIsNotLogin() async {
    bool? notLogin = await LocalStorageUtils.checkCookie();
    setState(() {
      isNotLogin = notLogin!;
    });
  }

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();
    return MaterialApp(
        title: 'ct',
        initialRoute: isNotLogin ? '/main' : '/login',
        theme: ThemeData(
            primaryColor: const Color.fromRGBO(248, 200, 34, 1),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            textTheme: const TextTheme(
              bodyText2: TextStyle(color: Colors.white),
              subtitle2: TextStyle(color: Colors.grey),
              headline2: TextStyle(fontSize: 18,color: Colors.black87)
            )
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => onGenerateRoute(settings),
    );
  }

}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}