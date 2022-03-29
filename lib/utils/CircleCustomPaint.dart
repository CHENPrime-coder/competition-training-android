
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CircleCustomPaint extends CustomPainter {
  CircleCustomPaint({
    required this.data
  });

  List<dynamic> data = [];
  final List<Paint> paints = [
    Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10
      ..color = const Color.fromRGBO(232,112,78,1),
    Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10
      ..color = const Color.fromRGBO(36,189,182,1),
    Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10
      ..color = const Color.fromRGBO(124,119,185,1),
    Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10
      ..color = const Color.fromRGBO(94,200,231,1),
  ];

  Paint paintCircleUnDone = Paint()
  ..style = PaintingStyle.fill
  ..strokeWidth = 10
  ..color = const Color.fromRGBO(209,209,209, 1);

  // 圆框画笔
  Paint paintCircleStroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color.fromRGBO(224, 233, 234, 1);

  // 圆画笔
  Paint paintGery = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 10
    ..color = const Color.fromRGBO(224, 233, 234, 1);

  // 圆画笔
  Paint paintCircle = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 10
    ..color = const Color.fromRGBO(255, 255, 255, 1);

  final paragraphStyle = ParagraphStyle(
    // 字体方向，有些国家语言是从右往左排版的
      textDirection: TextDirection.ltr,
      // 字体对齐方式
      textAlign: TextAlign.justify,
      fontSize: 14,
      maxLines: 2,
      // 字体超出大小时显示的提示
      ellipsis: '...',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      height: 5,
  );

  @override
  void paint(Canvas canvas, Size size) {

    // 画甜甜圈 static静态不变的
    canvas.drawCircle(Offset.zero, 205, paintGery);
    // 360 = 2pi
    List<dynamic> radius = drawByData(canvas);

    canvas.drawCircle(Offset.zero, 120, paintCircleStroke); //120
    canvas.drawCircle(Offset.zero, 115, paintCircle);

    drawText(canvas, radius[0], radius[1]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<dynamic> drawByData(Canvas canvas) {
    List<double> radius = [];
    List<double> end = [];
    
    var start = 0.75*2*pi;
    int cur = 0;
    int max = paints.length;
    Rect rect = Rect.fromCenter(center: Offset.zero, width: 390, height: 390);
    for(int i=0;i<data.length;i++){
      if(cur == max) {
        cur = 0;
      }

      if(i == data.length-1){
        canvas.drawArc(rect, start, (data[i]/100)*2*pi, true, paintCircleUnDone);
      }else{
        canvas.drawArc(rect, start, (data[i]/100)*2*pi, true, paints[cur]);
        radius.add(start);
        end.add((data[i]/100)*2*pi);
      }

      start += (data[i]/100)*2*pi;
      cur++;
    }
    return [radius, end];
  }

  void drawText(Canvas canvas, List<double> radius, List<double> end) {
    for(int i=0;i<radius.length;i++){

      // 精髓公式
      final double val = radius[i] + end[i] / 2;

      double x = cos(val) * 155;
      double y = sin(val) * 155;

      TextPainter(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: data[i].toString()+'%',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(
          minWidth: 0,
          maxWidth: 200,
        )
        ..paint(canvas, Offset(x-15,y-10));
    }
  }

}
