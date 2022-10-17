import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '_graph_parent_data.dart';

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
      required this.center}) {
    addAll(children);
  }

  BuildContext ctx;
  final Color unSelectedEdgeColor;
  final Color selectedEdgeColor;
  final double width;
  final double height;
  final Offset center;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GraphParentData) {
      child.parentData = GraphParentData();
    }
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

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
        Random random = Random.secure();
        position =
            Offset(random.nextDouble() * width, random.nextDouble() * height);
      }

      childParentData.offset = position;
      curIndex++;
      child = childParentData.nextSibling;
    }

    size = constraints
        .tighten(
          height: recordRect.height,
          width: recordRect.width,
        )
        .smallest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class SunGraphWidget extends MultiChildRenderObjectWidget {
  SunGraphWidget(
      {Key? key,
      List<Widget> children = const <Widget>[],
      required this.center,
      required this.height,
      required this.width})
      : super(children: children, key: key);
  final double width;
  final double height;
  final Offset center;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSunGraphWidget(
        ctx: context, width: width, height: height, center: center);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSunGraphWidget renderObject) {
    // TODO: implement updateRenderObject
    super.updateRenderObject(context, renderObject);
  }
}
