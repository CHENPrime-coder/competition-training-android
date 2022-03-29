import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key? key, this.opacity = 0.5}) : super(key: key);

  double opacity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, opacity),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.black87
          ),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20,),
              Text("加载中……", style: Theme.of(context).textTheme.bodyText2,)
            ],
          ),
        ),
      )
    );
  }
}

class LoadingDialogSized extends StatelessWidget {
  LoadingDialogSized({Key? key, this.opacity = 0.5, this.size = const Size(120, 120)}) : super(key: key);

  double opacity = 0.5;
  late Size size = const Size(120, 120);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
