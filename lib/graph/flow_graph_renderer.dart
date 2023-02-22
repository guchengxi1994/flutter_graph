// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter_graph/graph/_arrow_painter.dart';
import 'package:flutter_graph/graph/edge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_graph/graph/node_data.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '_graph_parent_data.dart';
import 'node_relations.dart';
import 'edge.dart';
import 'node.dart';
import 'dart:math' as math;

enum FlowGraphDirection { horizonal, vertical }

class RenderFlowGraphWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GraphParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GraphParentData> {
  RenderFlowGraphWidget(
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

  late FlowGraphDirection _direction = FlowGraphDirection.horizonal;

  set currentDirection(FlowGraphDirection c) {
    if (_direction != c) {
      _direction = c;
      markNeedsLayout();
    }
  }

  FlowGraphDirection get currentDirection => _direction;

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

    if (_direction == FlowGraphDirection.horizonal) {
      if (centerLayout) {
        final maxDepth = (rootData.countPerDepth.values.toList()..sort()).last;
        final maxHeight = (maxDepth + 1) * nodeVerticalDistance;

        while (child != null) {
          final GraphParentData childParentData =
              child.parentData as GraphParentData;
          int? currentDepth = nodeDatas
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

          if (currentDepth == -1 || currentDepth == null) {
            currentDepth = 1;
          }

          if (curIndex >= 1) {
            if (currentDepth > 0) {
              if (rootData.countPerDepth[currentDepth]! >
                  rootData.countPerDepth[currentDepth - 1]!) {
                int _positionIndex = 0;
                while (true) {
                  position = Offset(currentDepth * nodeHorizontalDistance,
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
                  position = Offset(currentDepth * nodeHorizontalDistance,
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
            if (rootData.countPerDepth[currentDepth]! < maxDepth) {
              position = Offset(
                  childSize.width,
                  childSize.height +
                      maxHeight / (rootData.countPerDepth[currentDepth]! + 1));
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

          final currentDepth = nodeDatas
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
              position = Offset((currentDepth ?? 1) * nodeHorizontalDistance,
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
    } else {
      /// FIXME
      ///
      /// node 会重叠
      if (centerLayout) {
        final maxDepth = (rootData.countPerDepth.values.toList()..sort()).last;
        final maxWidth = (maxDepth + 1) * nodeHorizontalDistance;

        while (child != null) {
          final GraphParentData childParentData =
              child.parentData as GraphParentData;
          int? currentDepth = nodeDatas
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

          if (currentDepth == -1 || currentDepth == null) {
            currentDepth = 1;
          }

          if (curIndex >= 1) {
            if (currentDepth > 0) {
              if (rootData.countPerDepth[currentDepth]! >
                  rootData.countPerDepth[currentDepth - 1]!) {
                int _positionIndex = 0;
                while (true) {
                  // position = Offset(currentDepth * nodeHorizontalDistance,
                  //     childSize.height + _positionIndex * nodeVerticalDistance);

                  position = Offset(
                      childSize.width + _positionIndex * nodeHorizontalDistance,
                      currentDepth * nodeVerticalDistance);

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
                  // position = Offset(currentDepth * nodeHorizontalDistance,
                  //     childSize.height + _positionIndex * nodeVerticalDistance);

                  position = Offset(
                      childSize.width + _positionIndex * nodeHorizontalDistance,
                      currentDepth * nodeVerticalDistance);

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
            if (rootData.countPerDepth[currentDepth]! < maxDepth) {
              // position = Offset(
              //     childSize.width,
              //     childSize.height +
              //         maxWidth / (rootData.countPerDepth[currentDepth]! + 1));

              position = Offset(
                  childSize.width +
                      maxWidth / (rootData.countPerDepth[currentDepth]! + 1),
                  childSize.height / 2);
            } else {
              position = Offset(childSize.width, childSize.height / 2);
            }
          }

          childParentData.offset = position;
          previousChildRect = childParentData.content;
          recordRect = recordRect.expandToInclude(previousChildRect);
          curIndex++;
          child = childParentData.nextSibling;
        }
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
    ctx.read<EdgeController>().init();
    var canvas = context.canvas;
    canvas.save();

    final children = getChildrenAsList();

    if (_direction == FlowGraphDirection.horizonal) {
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

            linePath.lineTo(
              secondNodeOffset.dx,
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
              /// 在第二个node上面
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
              /// 在第二个node下面
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
    } else {
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

          // final firstNodeOffset = Offset(firstData.right + offset.dx,
          //     firstData.top + 0.5 * firstData.height + offset.dy);

          final firstNodeOffset = Offset(
              firstData.left + 0.5 * firstData.width + offset.dx,
              firstData.bottom + offset.dy);

          // final secondNodeOffset = Offset(secondData.left + offset.dx,
          //     secondData.top + 0.5 * secondData.height + offset.dy);

          final secondNodeOffset = Offset(
              secondData.left + 0.5 * secondData.width + offset.dx,
              secondData.top + offset.dy);

          // print(
          //     "first : ${firstNodeOffset.dx}  second : ${secondNodeOffset.dx}");

          var start = Offset((firstData.left + firstData.right) / 2 + offset.dx,
              (firstData.bottom - 20 + offset.dy));

          var end = Offset((secondData.left + secondData.right) / 2 + offset.dx,
              (secondData.bottom - 20 + offset.dy));

          if ((firstNodeOffset.dx - secondNodeOffset.dx).abs() < 20) {
            linePath.moveTo(firstNodeOffset.dx, firstNodeOffset.dy);

            linePath.lineTo(
              secondNodeOffset.dx,
              secondNodeOffset.dy,
            );

            arrowPainter = ArrowPainter(
                arrowPosition: secondNodeOffset,
                canvas: canvas,
                angleColor: lineColor,
                arrowSize: arrowSize,
                angle: math.pi / 2);

            arrowPainter.render();
          } else {
            if (firstNodeOffset.dx < secondNodeOffset.dx) {
              /// 在第二个node左边
              start = Offset(firstData.right + offset.dx,
                  (firstData.bottom + firstData.top) / 2 + offset.dy);
              end = Offset((secondData.left + secondData.right) / 2 + offset.dx,
                  secondData.top + offset.dy);
              linePath.moveTo(start.dx, start.dy);
              linePath.cubicTo(
                start.dx + 0.25 * (end.dx - start.dx),
                start.dy,
                end.dx - 0.15 * (end.dx - start.dx),
                end.dy - 0.5 * nodeVerticalDistance,
                end.dx - 0.1 * arrowSize,
                end.dy - arrowSize,
              );
            } else {
              /// 在第二个node右边
              start = Offset(firstData.left + offset.dx,
                  (firstData.bottom + firstData.top) / 2 + offset.dy);

              // end = Offset(secondData.left + offset.dx,
              //     (secondData.bottom + secondData.top) / 2 + offset.dy);

              end = Offset((secondData.left + secondData.right) / 2 + offset.dx,
                  secondData.top + offset.dy);
              linePath.moveTo(start.dx, start.dy);
              linePath.cubicTo(
                start.dx - 0.25 * (start.dx - end.dx),
                start.dy,
                end.dx + 0.15 * (start.dx - end.dx),
                end.dy - 0.5 * nodeVerticalDistance,
                end.dx + 0.1 * arrowSize,
                end.dy - arrowSize,
              );
            }
            arrowPainter = ArrowPainter(
                arrowPosition: end,
                canvas: canvas,
                angleColor: lineColor,
                arrowSize: arrowSize,
                angle: math.pi / 2);

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
    }
    // print(ctx.read<EdgeController>().edges.length);
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
class FlowGraphWidget extends MultiChildRenderObjectWidget {
  FlowGraphWidget(
      {Key? key,
      List<Widget> children = const <Widget>[],
      required this.relations,
      required this.currentRelation,
      required this.rootData,
      this.nodeHorizontalDistance = 150,
      this.nodeVerticalDistance = 100,
      required this.direction})
      : super(children: children, key: key);

  Tuple2<int, int> currentRelation;
  NodeRelations relations;
  NodeData rootData;
  final double nodeHorizontalDistance;
  final double nodeVerticalDistance;
  FlowGraphDirection direction;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFlowGraphWidget(
      ctx: context,
      relations: relations,
      nodes: children as List<NodeWidget>,
      rootData: rootData,
      nodeHorizontalDistance: nodeHorizontalDistance,
      nodeVerticalDistance: nodeVerticalDistance,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderFlowGraphWidget renderObject) {
    renderObject.currentRelation = currentRelation;
    renderObject.ctx = context;
    renderObject.currentDirection = direction;
  }
}
