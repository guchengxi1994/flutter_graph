import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tuple/tuple.dart';

import '_arrow_painter.dart';
import '_graph_parent_data.dart';
import 'node_relations.dart';

class RenderSunGraphWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GraphParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GraphParentData> {
  RenderSunGraphWidget(
      {required this.ctx,
      List<RenderBox>? children,
      this.unSelectedEdgeColor = Colors.redAccent,
      this.selectedEdgeColor = Colors.black,
      required this.width,
      required this.height,
      required this.center,
      required this.relations}) {
    addAll(children);
  }

  double mathPi = math.pi * 2;

  BuildContext ctx;
  final Color unSelectedEdgeColor;
  final Color selectedEdgeColor;
  final double width;
  final double height;
  final Offset center;
  final NodeRelations relations;
  final double distanceBetweenNodes = 200;

  // int get currentIndex => _currentIndex;
  Tuple2<int, int> get currentRelation => _currentRelation;

  // ignore: prefer_final_fields
  late Tuple2<int, int> _currentRelation = const Tuple2(-1, -1);

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GraphParentData) {
      child.parentData = GraphParentData();
    }
  }

  late double r;

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    num angle;

    if (childCount > 1) {
      angle = mathPi / (childCount - 1);
    } else {
      angle = 0;
    }

    r = distanceBetweenNodes / (2 * math.cos((math.pi - angle) / 2));

    var recordRect =
        Rect.fromCenter(center: center, width: width, height: height);
    RenderBox? child = firstChild;

    var curIndex = 0;

    while (child != null) {
      final GraphParentData childParentData =
          child.parentData as GraphParentData;
      child.layout(
          const BoxConstraints(
              minHeight: 1, maxHeight: 100, minWidth: 1, maxWidth: 100),
          parentUsesSize: true);
      var childSize = child.size;

      ///记录大小
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      late Offset position;

      if (curIndex == 0) {
        position = Offset(center.dx - 0.5 * childSize.width,
            center.dy - 0.5 * childSize.height);
      } else {
        // math.Random random = math.Random.secure();
        // position =
        //     Offset(random.nextDouble() * width, random.nextDouble() * height);
        final dx = r * math.cos(math.pi / 2 - angle * (curIndex - 1));
        final dy = r * math.sin(math.pi / 2 - angle * (curIndex - 1));

        position = Offset(center.dx + dx, center.dy - dy);
      }

      childParentData.offset = position;
      recordRect = recordRect.expandToInclude(childParentData.content);
      curIndex++;
      child = childParentData.nextSibling;
    }

    size = constraints
        .tighten(
          // 底部加长30
          height: recordRect.height + 30,
          // 右侧拓宽30
          width: recordRect.width + 30,
        )
        .smallest;
  }

  final double arrowSize = 15;

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();

    final children = getChildrenAsList();
    late ArrowPainter arrowPainter;
    List<Offset> positions = [];

    for (int i = 0; i < relations.relations.length; i++) {
      Tuple2<int, int> relation = relations.getByIndex(i);
      if (relation.item1 < children.length &&
          relation.item2 < children.length) {
        final firstData =
            (children[relation.item1].parentData! as GraphParentData).content;
        final secondData =
            (children[relation.item2].parentData! as GraphParentData).content;

        bool isSecondNodeRoot = relation.item2 == 0;

        var linePath = Path();

        linePath.reset();

        final lineColor = currentRelation == relation
            ? selectedEdgeColor
            : unSelectedEdgeColor;
        Paint paint = Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

        late Offset start;
        late Offset end;
        double t;

        // 两个点水平方向上差距小于0.5*gap像素，
        if ((firstData.left - secondData.right).abs() <
                0.5 * distanceBetweenNodes ||
            (firstData.right - secondData.left).abs() <
                0.5 * distanceBetweenNodes) {
          // 第一个在上方
          if (firstData.top < secondData.bottom) {
            start = Offset((firstData.left + firstData.right) / 2 + offset.dx,
                firstData.bottom + offset.dy);
            end = Offset((secondData.left + secondData.right) / 2 + offset.dx,
                secondData.top + offset.dy);
          } else {
            // 第一个在下方
            start = Offset((firstData.left + firstData.right + offset.dx) / 2,
                firstData.top + offset.dy);
            end = Offset((secondData.left + secondData.right + offset.dx) / 2,
                secondData.bottom + offset.dy);
          }

          if (isSecondNodeRoot) {
            int k = 1;
            while (true) {
              if ((firstData.left - secondData.left).abs() >
                  (firstData.right - secondData.left).abs()) {
                end =
                    Offset(secondData.left + k * arrowSize + offset.dx, end.dy);
              } else {
                end = Offset(
                    secondData.right - k * arrowSize + offset.dx, end.dy);
              }

              if (!positions.contains(end)) {
                positions.add(end);
                break;
              } else {
                k = k + 1;
              }
            }
          }

          t = (end.dy - start.dy) / (end.dx - start.dx + 0.001);

          double tanAngle;

          if (end.dx < start.dx) {
            tanAngle = math.atan(t) + math.pi;
          } else {
            tanAngle = math.atan(t);
          }

          arrowPainter = ArrowPainter(
              arrowPosition: end,
              canvas: canvas,
              angleColor: lineColor,
              arrowSize: arrowSize,
              angle: tanAngle);
        } else {
          // 左右连接
          // 第一个在在左侧
          if (firstData.right < secondData.left) {
            start = Offset(firstData.right + offset.dx,
                (firstData.top + firstData.bottom) / 2 + offset.dy);
            end = Offset(secondData.left + offset.dx,
                (secondData.top + secondData.bottom) / 2 + offset.dy);
          } else {
            // 第一个在右侧
            start = Offset(firstData.left + offset.dx,
                (firstData.top + firstData.bottom) / 2 + offset.dy);
            end = Offset(secondData.right + offset.dx,
                (secondData.top + secondData.bottom) / 2 + offset.dy);
          }

          if (isSecondNodeRoot) {
            int k = 1;
            while (true) {
              if ((firstData.top - secondData.top).abs() >
                  (firstData.bottom - secondData.top).abs()) {
                end =
                    Offset(end.dx, secondData.top + k * arrowSize + offset.dy);
              } else {
                end = Offset(
                    end.dx, secondData.bottom - k * arrowSize + offset.dy);
              }

              if (!positions.contains(end)) {
                positions.add(end);
                break;
              } else {
                k = k + 1;
              }
            }
          }

          t = (end.dy - start.dy) / (end.dx - start.dx + 0.001);
          arrowPainter = ArrowPainter(
              arrowPosition: end,
              canvas: canvas,
              angleColor: lineColor,
              arrowSize: arrowSize,
              angle: math.atan(t));
        }

        linePath.moveTo(start.dx, start.dy);
        linePath.cubicTo(
          start.dx,
          start.dy - 25,
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2 - 50,
          end.dx,
          end.dy,
        );

        // PathMetrics pms = linePath.computeMetrics();

        // final metric = pms.last;

        // print(metric.getTangentForOffset(metric.length - 1)?.angle);

        arrowPainter.render();

        // print(pms.last.getTangentForOffset(pms.last.length * 0.99));

        canvas.drawPath(linePath, paint);
      }
    }
    defaultPaint(context, offset);
  }
}

class SunGraphWidget extends MultiChildRenderObjectWidget {
  SunGraphWidget(
      {Key? key,
      List<Widget> children = const <Widget>[],
      required this.center,
      required this.height,
      required this.width,
      required this.relations})
      : super(children: children, key: key);
  final double width;
  final double height;
  final Offset center;
  final NodeRelations relations;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSunGraphWidget(
        ctx: context,
        width: width,
        height: height,
        center: center,
        relations: relations);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSunGraphWidget renderObject) {
    // TODO: implement updateRenderObject
    super.updateRenderObject(context, renderObject);
  }
}
