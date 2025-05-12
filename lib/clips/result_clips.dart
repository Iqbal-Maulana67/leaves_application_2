import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class ResultClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final svgPathString =
        'M8 255.941V40.544C13.9612 10.0785 40.8698 -9.92288 114.113 15.8095C163.751 25.1057 192.542 25.3039 245.98 15.8095C322.302 -13.4288 345.982 18.3736 347.971 40.544V255.941C348.701 271.1 336.05 308.645 254.222 287.889C172.394 267.134 150.057 277.827 99.6897 287.889C49.3226 297.952 14.2724 297.676 8 255.941Z';

    final path = parseSvgPathData(svgPathString);

    // OPTIONAL: scale to widget size
    final matrix4 = Matrix4.identity();
    matrix4.scale(size.width / 356, size.height / 306); // scale to fit
    return path.transform(matrix4.storage);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PathBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final svgPath =
        'M8 255.941V40.544C13.9612 10.0785 40.8698 -9.92288 114.113 15.8095C163.751 25.1057 192.542 25.3039 245.98 15.8095C322.302 -13.4288 345.982 18.3736 347.971 40.544V255.941C348.701 271.1 336.05 308.645 254.222 287.889C172.394 267.134 150.057 277.827 99.6897 287.889C49.3226 297.952 14.2724 297.676 8 255.941Z';
    Path path = parseSvgPathData(svgPath);

    final matrix4 = Matrix4.identity();
    matrix4.scale(size.width / 356, size.height / 306);
    path = path.transform(matrix4.storage);

    final paint = Paint()
      ..color = Color.fromRGBO(38, 88, 222, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
