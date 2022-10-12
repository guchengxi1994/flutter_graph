// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:arrow_path/arrow_path.dart';
import 'package:flow_graph/graph/edge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'node.dart';

class GraphDemoPage extends StatefulWidget {
  const GraphDemoPage({Key? key}) : super(key: key);

  @override
  State<GraphDemoPage> createState() => _GraphDemoPageState();
}

class _GraphDemoPageState extends State<GraphDemoPage> {
  List<int> nodesIds = [0, 1, 2, 3];
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  int currentIndex = -1;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EdgeController(),
      builder: (context, child) {
        return Scaffold(
          persistentFooterButtons: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.amberAccent,
              ),
              onPressed: () {
                setState(() {
                  nodesIds.add(nodesIds.length);
                });
              },
              child: const Text(
                "加",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.indigoAccent),
              onPressed: () {
                setState(() {
                  if (nodesIds.length > 1) {
                    nodesIds.removeLast();
                  }
                });
              },
              child: const Text(
                "减",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          body: GestureDetector(
            onTapDown: (details) {
              // debugPrint(details.localPosition.toString());
              final edges = context.read<EdgeController>().edges;
              // print(edges.length);
              for (int i = 0; i < edges.length; i++) {
                if (edges[i].contains(details.localPosition)) {
                  print(true);

                  setState(() {
                    currentIndex = i;
                  });

                  break;
                }
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                color: Colors.amber[100],
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: controller1,
                  child: SingleChildScrollView(
                    controller: controller1,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: controller2,
                      child: GraphWidget(
                          currentIndex: currentIndex,
                          children: nodesIds
                              .map((e) => NodeWidget(
                                    index: e,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.white,
                                      child: Text(e.toString()),
                                    ),
                                  ))
                              .toList()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GraphParentData extends ContainerBoxParentData<RenderBox> {
  late double width;
  late double height;

  Rect get content => Rect.fromLTWH(
        offset.dx,
        offset.dy,
        width,
        height,
      );
}

class RenderGraphWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GraphParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GraphParentData> {
  RenderGraphWidget(
      {required this.ctx,
      List<RenderBox>? children,
      this.withArrow = true,
      required this.currentIndex}) {
    addAll(children);
  }

  bool withArrow;
  BuildContext ctx;
  int currentIndex;

  final double nodeHorizontalDistance = 150;
  final double nodeVerticalDistance = 100;

  ///设置为我们的数据
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

    ///初始化区域
    var recordRect = Rect.zero;
    var previousChildRect = Rect.zero;

    RenderBox? child = firstChild;
    var curIndex = 0;
    while (child != null) {
      ///提出数据
      final GraphParentData childParentData =
          child.parentData as GraphParentData;

      // child.layout(constraints, parentUsesSize: true);

      child.layout(
          const BoxConstraints(
              minHeight: 1, maxHeight: 100, minWidth: 1, maxWidth: 100),
          parentUsesSize: true);

      var childSize = child.size;

      ///记录大小
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;
      final position = Offset(
          childSize.width + curIndex * nodeHorizontalDistance,
          childSize.height + curIndex * nodeVerticalDistance);
      childParentData.offset = position;
      previousChildRect = childParentData.content;
      recordRect = recordRect.expandToInclude(previousChildRect);
      curIndex++;
      child = childParentData.nextSibling;
    }

    ///调整布局大小
    size = constraints
        .tighten(
          // 底部加长30
          height: recordRect.height + 30,
          // 右侧拓宽30
          width: recordRect.width + 30,
        )
        .smallest;
  }

  // 画笔颜色
  Color lineColor = Colors.red;

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();

    final children = getChildrenAsList();

    for (int i = 0; i < childCount; i++) {
      if (i == childCount - 1) {
        break;
      }
      Paint paint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      var linePath = Path();
      final firstData = (children[i].parentData! as GraphParentData).content;
      final secondData =
          (children[i + 1].parentData! as GraphParentData).content;

      linePath.reset();

      final firstNodeOffset = Offset(firstData.right + offset.dx,
          firstData.top + 0.5 * firstData.height + offset.dy);

      final secondNodeOffset = Offset(secondData.left + offset.dx,
          secondData.top + 0.5 * secondData.height + offset.dy);
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
      if (ctx.read<EdgeController>().edges.length < children.length - 1) {
        ctx.read<EdgeController>().addEdge(linePath);
      }

      canvas.drawPath(linePath, paint);
    }

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
class GraphWidget extends MultiChildRenderObjectWidget {
  GraphWidget(
      {Key? key,
      List<Widget> children = const <Widget>[],
      required this.currentIndex})
      : super(children: children, key: key);

  int currentIndex;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGraphWidget(ctx: context, currentIndex: currentIndex);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderGraphWidget renderObject) {
    renderObject.currentIndex = currentIndex;
    renderObject.ctx = context;
  }
}
