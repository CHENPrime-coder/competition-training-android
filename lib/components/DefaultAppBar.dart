import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

getDefaultAppBar(String title) {
  return AppBar(
    backgroundColor: const Color.fromRGBO(248, 200, 34, 1),
    centerTitle: true,
    automaticallyImplyLeading : false,
    title: Text(title,style: const TextStyle(color: Colors.black87),),
  );
}

getCanPopAppBar(String title, BuildContext context) {
  return AppBar(
    leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(CupertinoIcons.back), iconSize: 35, color: Colors.black87,),
    backgroundColor: const Color.fromRGBO(248, 200, 34, 1),
    centerTitle: true,
    title: Text(title,style: const TextStyle(color: Colors.black87),),
  );
}
