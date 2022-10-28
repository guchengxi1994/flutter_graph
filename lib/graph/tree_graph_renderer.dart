// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '_graph_parent_data.dart';
import 'node_data.dart';

class RenderTreeGraphWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GraphParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GraphParentData> {
  RenderTreeGraphWidget(
      {List<RenderBox>? children,
      required this.ctx,
      required this.rootData,
      required this.center,
      this.height = 1000,
      this.width = 1000})
      : assert(width > 100) {
    addAll(children);
  }

  BuildContext ctx;
  final NodeData rootData;
  final double height;
  final double width;
  final Offset center;

  static const margin = 50.0;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GraphParentData) {
      child.parentData = GraphParentData();
    }
  }

  void _walk() {
    List<NodeData> nodeDatas = rootData.toList(getDepths: true);
    final maxDepthCount = (rootData.countPerDepth.values.toList()..sort()).last;
    final maxDepth = (rootData.countPerDepth.keys.toList()..sort()).last;
    final minVerticalHeight = (height - 2 * margin) / (maxDepthCount + 1);
    final horizontalGap = (width - 2 * margin) / (maxDepth + 1);
    final children = getChildrenAsList();
    List<int> nodeIds = nodeDatas.map((e) => e.index!).toList()..sort();
    while (nodeIds.isNotEmpty) {
      final curIndex = nodeIds.removeAt(0);
      final currentNode = nodeDatas.firstWhere(
          (element) => element.index == curIndex,
          orElse: () => NodeData(index: -1));
      int? currentDepth = currentNode.depth;
      if (currentDepth == -1 || currentDepth == null) {
        currentDepth = 1;
      }

      final currentChild = children[curIndex];
      currentChild.layout(
          const BoxConstraints(
              minHeight: 1, maxHeight: 100, minWidth: 1, maxWidth: 100),
          parentUsesSize: true);
      var childSize = currentChild.size;

      final GraphParentData childParentData =
          currentChild.parentData as GraphParentData;

      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      final verticalGap =
          (height - 2 * margin) / (rootData.countPerDepth[currentDepth]! + 1);
      final position =
          Offset(currentDepth * horizontalGap + margin, verticalGap);
      // print(position);
      childParentData.offset = position;
      _walkChildren(currentNode, horizontalGap, nodeIds, nodeDatas);
    }
  }

  late List<Offset> positions = [];

  void _walkChildren(NodeData nodeData, double horizontalGap, List<int> nodeIds,
      List<NodeData> nodeDatas) {
    final children = getChildrenAsList();
    if (nodeData.parentIndex == null) {
      return;
    }
    final parentData = nodeDatas.firstWhere(
        (element) => element.index == nodeData.parentIndex,
        orElse: () => NodeData(index: -1));
    final brotherCount = parentData.children!.length;
    final parent = children[nodeData.parentIndex!];
    final offset = (parent.parentData! as GraphParentData).offset;
    final currentChild = children[nodeData.index!];
    currentChild.layout(
        const BoxConstraints(
            minHeight: 1, maxHeight: 100, minWidth: 1, maxWidth: 100),
        parentUsesSize: true);
    var childSize = currentChild.size;
    final GraphParentData childParentData =
        currentChild.parentData as GraphParentData;
    childParentData.width = childSize.width;
    childParentData.height = childSize.height;

    final curDepthItemCount = rootData.countPerDepth[nodeData.depth]!;
    // print(curDepthItemCount);

    final baseY = offset.dy;
    final num minTop;
    final double maxTop;
    if (curDepthItemCount == brotherCount) {
      minTop = 50;
      maxTop = height - 50;
    } else {
      minTop = baseY - 100;
      maxTop = baseY + 100;
    }

    final verticalGap = (maxTop - minTop) / (brotherCount + 1);

    int k = 0;
    Offset position;
    while (true) {
      double y;
      if (k % 2 == 0) {
        y = k / 2 * verticalGap;
        position = Offset(offset.dx + horizontalGap, y + baseY);
      } else {
        y = (-k + 1) / 2 * verticalGap;
        position = Offset(offset.dx + horizontalGap, y + baseY);
      }

      if (positions.contains(position)) {
        k = k + 1;
      } else {
        positions.add(position);
        break;
      }
    }

    childParentData.offset = position;
    for (var n in nodeData.children!) {
      _walkChildren(n, horizontalGap, nodeIds, nodeDatas);
    }

    nodeIds.remove(nodeData.index!);
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    var recordRect =
        Rect.fromCenter(center: center, width: width, height: height);
    _walk();

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

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result as BoxHitTestResult,
        position: position);
  }
}

// ignore: must_be_immutable
class TreeGraphWidget extends MultiChildRenderObjectWidget {
  NodeData rootData;
  final double width;
  final double height;
  final Offset center;
  TreeGraphWidget(
      {Key? key,
      List<Widget> children = const <Widget>[],
      required this.center,
      required this.height,
      required this.width,
      required this.rootData})
      : super(children: children, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTreeGraphWidget(
        center: center,
        ctx: context,
        rootData: rootData,
        height: height,
        width: width);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}
