import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "CELLUTOWN",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFFF7643),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: 200,
          width: Get.width * 0.6,
        ),
      ],
    );
  }
}
