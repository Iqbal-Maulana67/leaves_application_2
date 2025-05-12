import 'package:flutter/material.dart';
import 'package:leaves_classification_application_nimas/clips/result_clips.dart';

class TestingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Stack(children: [
              CustomPaint(
                size: Size(MediaQuery.sizeOf(context).width, 300),
                painter: PathBorderPainter(),
              ),
              ClipPath(
                clipper: ResultClip(),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg_benefit.png"),
                        fit: BoxFit.cover),
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: 300,
                ),
              ),
            ])),
      ),
    );
  }
}
