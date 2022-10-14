// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:arrow_path/arrow_path.dart';
import 'package:blurred/blurred.dart';
import 'package:flutter_graph/graph/edge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_graph/graph/node_data.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'blur_controller.dart';
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

  NodeData data = NodeData();

  @override
  void initState() {
    super.initState();
    data.index = 0;
    data.isRoot = true;
    data.children = [];

    NodeData data1 = NodeData();
    data1.index = 1;
    data1.isRoot = false;
    data1.children = [];

    NodeData data2 = NodeData();
    data2.index = 2;
    data2.isRoot = false;
    data2.children = [];

    data.children!.add(data1);
    data.children!.add(data2);

    NodeData data3 = NodeData();
    data3.index = 3;
    data3.isRoot = false;
    data3.children = [];

    NodeData data4 = NodeData();
    data4.index = 4;
    data4.isRoot = false;
    data4.children = [];

    data1.children!.add(data3);
    data3.children!.add(data4);

    data.children!.add(NodeData(index: 5, children: []));
    data.children!.add(NodeData(index: 6, children: []));
    data.children!.add(NodeData(index: 7, children: []));
    data.children!.add(NodeData(index: 8, children: []));
    data.children!.add(NodeData(index: 9, children: []));
    data.children!.add(NodeData(index: 10, children: []));
    data.children!.add(NodeData(index: 11, children: []));
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final relations = NodeData.fromJson(data.toJson()).toRelations();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EdgeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => BlurController(),
        ),
      ],
      builder: (context, child) {
        final edges = context.read<EdgeController>().edges;
        BlurController blurController = context.watch<BlurController>();
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
          body: Blurred(
            blurValue: blurController.shouldBlur ? 1.5 : 0,
            widget: GestureDetector(
              onTapDown: (details) {
                for (int i = 0; i < edges.length; i++) {
                  if (edges[i].path == null) {
                    continue;
                  }
                  final c = edges[i].path!.contains(details.localPosition) ||
                      edges[i].path!.contains(Offset(details.localPosition.dx,
                          details.localPosition.dy - 1)) ||
                      edges[i].path!.contains(Offset(details.localPosition.dx,
                          details.localPosition.dy + 1)) ||
                      edges[i].path!.contains(Offset(
                          details.localPosition.dx - 1,
                          details.localPosition.dy)) ||
                      edges[i].path!.contains(Offset(
                          details.localPosition.dx + 1,
                          details.localPosition.dy));

                  if (c) {
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
                            rootData: data,
                            currentRelation: currentRelation,
                            relations: relations,
                            children: nodesIds
                                .map((e) => NodeWidget(
                                      isRoot: e == 0,
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
            child: blurController.currentWidget,
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
      required this.relations,
      List<RenderBox>? children,
      this.withArrow = true,
      required this.nodes,
      required this.rootData}) {
    addAll(children);
  }

  bool withArrow;
  BuildContext ctx;
  NodeRelations relations;
  final List<NodeWidget> nodes;
  final NodeData rootData;

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
  final double triangleArrowHeight = 8.0;

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

    List<NodeData> nodeDatas = rootData.toList();

    /// 初始化区域
    var recordRect = Rect.zero;
    var previousChildRect = Rect.zero;

    /// 这里记录的是保存的位置
    ///
    /// 如果已经有了组件,就向下继续
    List<Offset> _positions = [];

    RenderBox? child = firstChild;
    var curIndex = 0;
    while (child != null) {
      ///提出数据
      final GraphParentData childParentData =
          child.parentData as GraphParentData;

      final depth = nodeDatas
          .firstWhere((element) => element.index == curIndex,
              orElse: () => NodeData(index: -1))
          .depth;

      child.layout(
          const BoxConstraints(
              minHeight: 1, maxHeight: 100, minWidth: 1, maxWidth: 100),
          parentUsesSize: true);

      var childSize = child.size;

      ///记录大小
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      late Offset position;

      if (curIndex >= 1) {
        int _positionIndex = 0;
        while (1 == 1) {
          position = Offset((depth ?? 1) * nodeHorizontalDistance,
              childSize.height + _positionIndex * nodeVerticalDistance);

          if (!_positions.contains(position)) {
            _positions.add(position);
            // print(position);
            break;
          } else {
            _positionIndex++;
          }
        }
      } else {
        /// 第一个node
        position = Offset(childSize.width, childSize.height);
      }

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

    // print(relations.relations.length);

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
          ..strokeWidth = 3.0;
        var linePath = Path();

        linePath.reset();

        final firstNodeOffset = Offset(firstData.right + offset.dx,
            firstData.top + 0.5 * firstData.height + offset.dy);

        final secondNodeOffset = Offset(secondData.left + offset.dx,
            secondData.top + 0.5 * secondData.height + offset.dy);

        var start = Offset((firstData.left + firstData.right) / 2 + offset.dx,
            (firstData.bottom - 20 + offset.dy));

        var end = Offset((secondData.left + secondData.right) / 2 + offset.dx,
            (secondData.bottom - 20 + offset.dy));

        if (firstNodeOffset.dy == secondNodeOffset.dy) {
          linePath.moveTo(firstNodeOffset.dx, firstNodeOffset.dy);
          linePath.cubicTo(
            firstNodeOffset.dx,
            firstNodeOffset.dy,
            firstNodeOffset.dx + 10,
            firstNodeOffset.dy + 10,
            secondNodeOffset.dx,
            secondNodeOffset.dy,
          );
        } else {
          linePath.moveTo(start.dx, start.dy);
          linePath.cubicTo(
              start.dx,
              start.dy + nodeVerticalDistance / 2,
              end.dx,
              end.dy - nodeVerticalDistance / 2,
              end.dx,
              end.dy - triangleArrowHeight);
        }

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
      required this.currentRelation,
      required this.rootData})
      : super(children: children, key: key);

  Tuple2<int, int> currentRelation;
  NodeRelations relations;
  NodeData rootData;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGraphWidget(
        ctx: context,
        relations: relations,
        nodes: children as List<NodeWidget>,
        rootData: rootData);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderGraphWidget renderObject) {
    renderObject.currentRelation = currentRelation;
    renderObject.ctx = context;
  }
}
