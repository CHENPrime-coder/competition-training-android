import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  ProgressLine({Key? key,required this.progress,
    this.backgroundColor = const Color.fromRGBO(235, 238, 245, 1),
    this.width = double.infinity,
    this.height = 20.0,
    this.suffix = "分",
    required this.completionScheduleColor}) : super(key: key);

  int progress;
  double height;
  double width;
  String suffix;
  Color backgroundColor;
  Color completionScheduleColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          if (width == double.infinity){
            width = constraints.maxWidth;
          }
          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                //进度条背景
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: backgroundColor,
                  ),
                ),
                //进度条完成内容的背景
                Container(
                  width: width/100*progress,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: completionScheduleColor,
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}

