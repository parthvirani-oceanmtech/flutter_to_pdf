// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageClickDemo extends StatefulWidget {
  const ImageClickDemo({super.key});

  @override
  State<ImageClickDemo> createState() => _ImageClickDemoState();
}

class _ImageClickDemoState extends State<ImageClickDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            children: [
              Image.asset("assets/frame.png"),
              Positioned(
                bottom: 41,
                left: 5,
                child: SizedBox(
                  width: 137,
                  height: 27,
                  child: Visibility(visible: false, child: const Text("https://www.parthvirani.com")),
                ),
              ),
              Positioned(
                bottom: 3,
                left: 5,
                child: SizedBox(
                  width: 137,
                  height: 26,
                  child: Visibility(visible: false, child: const Text("tel:+919737027796")),
                ),
              ),
              Positioned(
                bottom: 42,
                left: 164,
                child: SizedBox(
                  width: 156,
                  height: 27,
                  child: Visibility(visible: false, child: const Text("https://parthvirani.com")),
                ),
              ),
              Positioned(
                bottom: 3,
                right: 5,
                child: SizedBox(
                  width: 156,
                  height: 27,
                  child: Visibility(visible: false, child: const Text("https://maps.app.goo.gl/kYq5NbHrCkWc1p9x8")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
