// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:blurred/blurred.dart';
import 'package:flutter_graph/graph/_arrow_painter.dart';
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
  // List<int> nodesIds = [0, 1, 2, 3];
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  Tuple2<int, int> currentRelation = const Tuple2(-1, -1);
  List<DemoNodeWidgetData> nodesData = [];

  NodeData data = NodeData();

  final names = ["壹零", "工程师", "文件A"];
  final urls = ["assets/images/file.png", "assets/images/user.png"];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 20; i++) {
      nodesData.add(
          DemoNodeWidgetData(index: i, url: urls[i % 2], name: names[i % 3]));
    }

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
                  nodesData.add(DemoNodeWidgetData(
                      index: nodesData.length,
                      url: urls[nodesData.length % 2],
                      name: names[nodesData.length % 3]));
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
                  if (nodesData.length > 1) {
                    nodesData.removeLast();
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
                Offset position = Offset(
                    controller1.offset + details.localPosition.dx,
                    controller2.offset + details.localPosition.dy);

                for (int i = 0; i < edges.length; i++) {
                  if (edges[i].path == null) {
                    continue;
                  }

                  final c = edges[i].path!.contains(position) ||
                      edges[i]
                          .path!
                          .contains(Offset(position.dx, position.dy - 1)) ||
                      edges[i]
                          .path!
                          .contains(Offset(position.dx, position.dy + 1)) ||
                      edges[i]
                          .path!
                          .contains(Offset(position.dx - 1, position.dy)) ||
                      edges[i]
                          .path!
                          .contains(Offset(position.dx + 1, position.dy));

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
                            nodeHorizontalDistance: 250,
                            nodeVerticalDistance: 200,
                            rootData: data,
                            currentRelation: currentRelation,
                            relations: relations,
                            children: nodesData
                                .map((e) => NodeWidget(
                                      isRoot: e.index == 0,
                                      index: e.index!,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Image.asset(e.url!),
                                            ),
                                            Text(
                                              e.name.toString(),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
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
      this.centerLayout = true,
      required this.nodes,
      required this.rootData,
      required this.nodeHorizontalDistance,
      required this.nodeVerticalDistance,
      this.unSelectedEdgeColor = Colors.redAccent,
      this.selectedEdgeColor = Colors.black}) {
    addAll(children);
  }

  BuildContext ctx;
  NodeRelations relations;
  final List<NodeWidget> nodes;
  final NodeData rootData;
  final double nodeHorizontalDistance;
  final double nodeVerticalDistance;
  final Color unSelectedEdgeColor;
  final Color selectedEdgeColor;

  final bool centerLayout;

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

    List<NodeData> nodeDatas = rootData.toList(getDepths: true);

    // print(rootData.countPerDepth);

    /// 初始化区域
    var recordRect = Rect.zero;
    var previousChildRect = Rect.zero;

    /// 这里记录的是保存的位置
    ///
    /// 如果已经有了组件,就向下继续
    List<Offset> _positions = [];

    RenderBox? child = firstChild;
    var curIndex = 0;

    if (centerLayout) {
      final maxDepth = (rootData.countPerDepth.values.toList()..sort()).last;
      final maxHeight = (maxDepth + 1) * nodeVerticalDistance;

      while (child != null) {
        final GraphParentData childParentData =
            child.parentData as GraphParentData;
        int? depth = nodeDatas
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

        depth = depth ?? 1;

        if (curIndex >= 1) {
          if (depth > 0) {
            if (rootData.countPerDepth[depth]! >
                rootData.countPerDepth[depth - 1]!) {
              int _positionIndex = 0;
              while (true) {
                position = Offset(depth * nodeHorizontalDistance,
                    childSize.height + _positionIndex * nodeVerticalDistance);

                if (!_positions.contains(position)) {
                  _positions.add(position);
                  break;
                } else {
                  _positionIndex++;
                }
              }
            } else {
              int _positionIndex = 0;
              while (true) {
                position = Offset(depth * nodeHorizontalDistance,
                    childSize.height + _positionIndex * nodeVerticalDistance);

                if (!_positions.contains(position)) {
                  _positions.add(position);
                  // print(position);
                  break;
                } else {
                  _positionIndex++;
                }
              }
            }
          }
        } else {
          /// 第一个node
          if (rootData.countPerDepth[depth]! < maxDepth) {
            position = Offset(
                childSize.width,
                childSize.height +
                    maxHeight / (rootData.countPerDepth[depth]! + 1));
          } else {
            position = Offset(childSize.width, childSize.height);
          }
        }

        childParentData.offset = position;
        previousChildRect = childParentData.content;
        recordRect = recordRect.expandToInclude(previousChildRect);
        curIndex++;
        child = childParentData.nextSibling;
      }
    } else {
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

  final double arrowSize = 15;

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
        final lineColor = currentRelation == relation
            ? selectedEdgeColor
            : unSelectedEdgeColor;
        Paint paint = Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;
        var linePath = Path();

        linePath.reset();
        late ArrowPainter arrowPainter;

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
            secondNodeOffset.dx - arrowSize,
            secondNodeOffset.dy,
          );

          arrowPainter = ArrowPainter(
              arrowPosition: secondNodeOffset,
              canvas: canvas,
              angleColor: lineColor,
              arrowSize: arrowSize);

          arrowPainter.render();
        } else {
          if (firstNodeOffset.dy < secondNodeOffset.dy) {
            start = Offset(firstData.right + offset.dx,
                (firstData.bottom + firstData.top) / 2 + offset.dy);
            end = Offset(secondData.left + offset.dx,
                (secondData.bottom + secondData.top) / 2 + offset.dy);
            linePath.moveTo(start.dx, start.dy);
            linePath.cubicTo(
              start.dx + 0.25 * nodeHorizontalDistance,
              start.dy,
              end.dx - 0.4 * nodeHorizontalDistance,
              end.dy - 0.5 * nodeVerticalDistance + secondData.height,
              end.dx - arrowSize,
              end.dy,
            );
          } else {
            start = Offset(firstData.right + offset.dx,
                (firstData.bottom + firstData.top) / 2 + offset.dy);

            end = Offset(secondData.left + offset.dx,
                (secondData.bottom + secondData.top) / 2 + offset.dy);
            linePath.moveTo(start.dx, start.dy);
            linePath.cubicTo(
              start.dx + 0.25 * nodeHorizontalDistance,
              start.dy,
              end.dx - 0.25 * nodeHorizontalDistance,
              end.dy - 0.5 * nodeVerticalDistance + secondData.height,
              end.dx - arrowSize,
              end.dy,
            );
          }
          arrowPainter = ArrowPainter(
              arrowPosition: end,
              canvas: canvas,
              angleColor: lineColor,
              arrowSize: arrowSize);

          arrowPainter.render();
        }

        ctx.read<EdgeController>().addEdge(Edge(
              path: linePath,
              firstNodeIndex: relation.item1,
              secondNodeIndex: relation.item2,
            ));

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
      required this.rootData,
      this.nodeHorizontalDistance = 150,
      this.nodeVerticalDistance = 100})
      : super(children: children, key: key);

  Tuple2<int, int> currentRelation;
  NodeRelations relations;
  NodeData rootData;
  final double nodeHorizontalDistance;
  final double nodeVerticalDistance;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGraphWidget(
        ctx: context,
        relations: relations,
        nodes: children as List<NodeWidget>,
        rootData: rootData,
        nodeHorizontalDistance: nodeHorizontalDistance,
        nodeVerticalDistance: nodeVerticalDistance);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderGraphWidget renderObject) {
    renderObject.currentRelation = currentRelation;
    renderObject.ctx = context;
  }
}
