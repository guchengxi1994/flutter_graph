import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArrowPainter {
  final Offset arrowPosition;
  final double arrowSize;
  final double angle;
  final double arrowAngle;
  final Color angleColor;
  final Canvas canvas;
  final bool fill;

  late Paint arrowPaint;

  ArrowPainter(
      {required this.arrowPosition,
      required this.canvas,
      required this.angleColor,
      this.angle = 0,
      this.arrowSize = 15,
      this.arrowAngle = 25 * math.pi / 180,
      this.fill = true}) {
    if (fill) {
      arrowPaint = Paint()
        ..color = angleColor
        ..style = PaintingStyle.fill
        ..strokeWidth = 1;
    } else {
      arrowPaint = Paint()
        ..color = angleColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
    }
  }

  render() {
    Path path = Path();
    path.moveTo(arrowPosition.dx - arrowSize * math.cos(angle - arrowAngle),
        arrowPosition.dy - arrowSize * math.sin(angle - arrowAngle));
    path.lineTo(arrowPosition.dx, arrowPosition.dy);
    path.lineTo(arrowPosition.dx - arrowSize * math.cos(angle + arrowAngle),
        arrowPosition.dy - arrowSize * math.sin(angle + arrowAngle));
    path.close();

    canvas.drawPath(path, arrowPaint);
  }
}
