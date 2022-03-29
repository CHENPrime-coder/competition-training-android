import 'dart:io';

import 'package:ct_android_plus/apis/FileDio.dart';
import 'package:ct_android_plus/apis/PersonalDio.dart';
import 'package:ct_android_plus/components/DefaultAppBar.dart';
import 'package:ct_android_plus/components/LoadingDialog.dart';
import 'package:ct_android_plus/utils/CurrentObjects.dart';
import 'package:ct_android_plus/utils/ToastUtils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeUserHeadIcon extends StatefulWidget {
  ChangeUserHeadIcon({Key? key}) : super(key: key);

  @override
  State<ChangeUserHeadIcon> createState() => _ChangeUserHeadIconState();
}

class _ChangeUserHeadIconState extends State<ChangeUserHeadIcon> {
  late File file;
  bool isSelect = false;
  String tips = "请选择上传头像";
  bool isLoading = false;

  chooseImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        if (image != null) {
          file = File(image.path);
          isSelect = true;
        }
      });
    }
  }

  getImageView() {
    if(isSelect){
      setState(() {
        tips = "";
      });
      return FileImage(file);
    }
    return const AssetImage("lib/images/unSelected.png");
  }

  changeUserImg() async {
    String newFilename = file.path.split("/").last;
    String oldFilename = CurrentUser.user["headiconURL"].toString().split("/").last;
    setState(() {
      isLoading = true;
    });
    dynamic res = await PersonalDio.changeUserImg(newFilename,oldFilename);
    if(res["code"]=="200"){
      String filename = res["filename"];
      dynamic lastRes = await FileDio.uploadFile(file, oldFilename, filename);
      if(lastRes["code"]=="200"){
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, "/main");
      }else{
        showToast("上传失败");
      }
    }else{
      showToast("修改失败");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCanPopAppBar("修改头像", context),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                        chooseImage();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 80),
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(175)),
                            image: DecorationImage(image: getImageView(),fit: BoxFit.cover)
                        ),
                        alignment: Alignment.center,
                        child: Text(tips,style: const TextStyle(color: Colors.black87,fontSize: 30),),
                      )
                  )
                ],
              ),
              const SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                        ),
                        onPressed: (){
                          if(isSelect){
                            changeUserImg();
                          }else{
                            showToast("请选择文件");
                          }
                        },
                        child: const Text("确认提交",style: TextStyle(color: Colors.black87,fontSize: 20),)
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("取       消",style: TextStyle(color: Colors.black87,fontSize: 20),)
                    ),
                  ),
                ],
              )
            ],
          ),
          Visibility(
              visible: isLoading,
              child: LoadingDialog()
          )
        ],
      )
    );
  }
}

