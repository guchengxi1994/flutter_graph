// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:arrow_path/arrow_path.dart';
import 'package:flow_graph/graph/edge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'edge.dart';
import 'graph.dart';
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
  Tuple2<int, int> currentRelation = const Tuple2(-1, -1);

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
                if (edges[i].path == null) {
                  continue;
                }
                if (edges[i].path!.contains(details.localPosition)) {
                  setState(() {
                    // currentIndex = i;
                    currentRelation = Tuple2(
                        edges[i].firstNodeIndex, edges[i].secondNodeIndex);
                  });

                  break;
                } else {
                  setState(() {
                    currentRelation = const Tuple2(-1, -1);
                  });
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
                          currentRelation: currentRelation,
                          relations: NodeRelations(relations: [
                            const Tuple2(0, 1),
                            const Tuple2(0, 2),
                            const Tuple2(0, 3),
                          ]),
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
  RenderGraphWidget({
    required this.ctx,
    required this.relations,
    List<RenderBox>? children,
    this.withArrow = true,
  }) {
    addAll(children);
  }

  bool withArrow;
  BuildContext ctx;
  NodeRelations relations;

  set currentRelation(Tuple2<int, int> c) {
    if (_currentRelation != c) {
      _currentRelation = c;
      markNeedsLayout();
    }
  }

  // int get currentIndex => _currentIndex;
  Tuple2<int, int> get currentRelation => _currentRelation;

  // ignore: prefer_final_fields
  late Tuple2<int, int> _currentRelation = const Tuple2(-1, -1);

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

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();

    final children = getChildrenAsList();

    for (int i = 0; i < relations.relations.length; i++) {
      Tuple2<int, int> relation = relations.getByIndex(i);
      if (relation.item1 < children.length &&
          relation.item2 < children.length) {
        final firstData =
            (children[relation.item1].parentData! as GraphParentData).content;
        final secondData =
            (children[relation.item2].parentData! as GraphParentData).content;
        Paint paint = Paint()
          ..color = currentRelation == relation ? Colors.black : Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        var linePath = Path();

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
          ctx.read<EdgeController>().addEdge(Edge(
              path: linePath,
              firstNodeIndex: relation.item1,
              secondNodeIndex: relation.item2));
        }

        canvas.drawPath(linePath, paint);
      }
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
      required this.relations,
      required this.currentRelation})
      : super(children: children, key: key);

  Tuple2<int, int> currentRelation;
  NodeRelations relations;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGraphWidget(ctx: context, relations: relations);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderGraphWidget renderObject) {
    renderObject.currentRelation = currentRelation;
    renderObject.ctx = context;
  }
}
