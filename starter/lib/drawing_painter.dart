// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:awesome_drawing_quiz/drawing.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final Drawing drawing;

  final Paint _paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  DrawingPainter({
    required this.drawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in drawing.strokes) {
      var points = stroke.points;
      assert(points.isNotEmpty);

      Path path = Path();
      path.moveTo(
        _scale(points[0].x, size.width),
        _scale(points[0].y, size.height),
      );

      for (int i = 1; i < points.length; i++) {
        path.lineTo(
          _scale(points[i].x, size.width),
          _scale(points[i].y, size.height),
        );
      }

      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.drawing.word != drawing.word;
  }

  double _scale(num original, num axisLength) {
    return original * (axisLength / 256);
  }
}
