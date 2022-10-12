import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final List<int> customLayoutId;
  Size? childSize;
  bool withArrow;
  LinePainter(
      {required this.customLayoutId, this.childSize, this.withArrow = true});

  @override
  void paint(Canvas canvas, Size size) {
    Offset startPoint = const Offset(100, 100);
    childSize ??= const Size(100, 100);
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    var linePath = Path();

    for (final i in customLayoutId) {
      linePath.reset();
      if (i == customLayoutId.last) {
        break;
      }
      final firstNodeOffset =
          Offset(startPoint.dx + i * 150 + 100, startPoint.dy + i * 100 + 50);
      final secondNodeOffset =
          Offset(firstNodeOffset.dx + 50, firstNodeOffset.dy + 100);
      // canvas.drawLine(firstNodeOffset, secondNodeOffset, paint);
      linePath.moveTo(firstNodeOffset.dx, firstNodeOffset.dy);
      linePath.cubicTo(
        firstNodeOffset.dx,
        firstNodeOffset.dy,
        firstNodeOffset.dx + 15,
        firstNodeOffset.dy + 75,
        secondNodeOffset.dx,
        secondNodeOffset.dy,
      );
      if (withArrow) {
        linePath = ArrowPath.make(path: linePath);
      }

      canvas.drawPath(linePath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.customLayoutId.length != customLayoutId.length;
  }
}
