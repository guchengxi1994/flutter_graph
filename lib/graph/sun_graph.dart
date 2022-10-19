import 'package:blurred/blurred.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graph/graph/node_relations.dart';
import 'package:flutter_graph/graph/sun_graph_renderer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'blur_controller.dart';
import 'edge_controller.dart';

typedef OnEdgeSelected = Function(int from, int to);

class SunGraph extends StatefulWidget {
  const SunGraph(
      {Key? key,
      required this.nodes,
      required this.relations,
      required this.widgetHeight,
      required this.widgetWidth,
      this.needsBlur = false,
      this.onEdgeSelected})
      : super(key: key);
  final List<Widget> nodes;
  final NodeRelations relations;
  final double widgetWidth;
  final double widgetHeight;
  final bool needsBlur;
  final OnEdgeSelected? onEdgeSelected;

  @override
  State<SunGraph> createState() => _SunGraphState();
}

class _SunGraphState extends State<SunGraph> {
  Tuple2<int, int> currentRelation = const Tuple2(-1, -1);
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();

  List<Widget> nodes = [];

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nodes = widget.nodes;
  }

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Offset center = size.center(Offset.zero);

    if (widget.needsBlur) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => EdgeController()..init(),
          ),
          ChangeNotifierProvider(
            create: (_) => BlurController(),
          ),
        ],
        builder: (context, child) {
          final edges = context.read<EdgeController>().edges;
          BlurController blurController = context.watch<BlurController>();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            final RenderBox box =
                globalKey.currentContext!.findRenderObject() as RenderBox;
            final topLeftPosition = box.localToGlobal(Offset.zero);
            context.read<BlurController>().changeGlobalOffset(topLeftPosition);
          });
          return Blurred(
              key: globalKey,
              blurValue: blurController.shouldBlur ? 1.5 : 0,
              widget: GestureDetector(
                onTapDown: (details) {
                  Offset position = Offset(
                      controller1.offset + details.localPosition.dx,
                      controller2.offset + details.localPosition.dy);
                  // print(position);
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

                  if (currentRelation != const Tuple2(-1, -1) &&
                      widget.onEdgeSelected != null) {
                    widget.onEdgeSelected!(
                        currentRelation.item1, currentRelation.item2);
                  }
                },
                child: _buildContent(center),
              ),
              child: blurController.currentWidget);
        },
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => EdgeController()..init(),
          ),
        ],
        builder: (context, child) {
          final edges = context.read<EdgeController>().edges;
          return GestureDetector(
            onTapDown: (details) {
              Offset position = Offset(
                  controller1.offset + details.localPosition.dx,
                  controller2.offset + details.localPosition.dy);
              // print(position);
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
            child: _buildContent(center),
          );
        },
      );
    }
  }

  Widget _buildContent(Offset center) {
    return SizedBox(
      width: widget.widgetWidth,
      height: widget.widgetHeight,
      child: Container(
        color: Colors.white,
        child: Scrollbar(
            thumbVisibility: true,
            controller: controller1,
            child: SingleChildScrollView(
              controller: controller1,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                controller: controller2,
                child: SunGraphWidget(
                  currentRelation: currentRelation,
                  center: center,
                  height: widget.widgetHeight,
                  width: widget.widgetWidth,
                  relations: widget.relations,
                  children: nodes,
                ),
              ),
            )),
      ),
    );
  }
}
