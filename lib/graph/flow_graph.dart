// ignore_for_file: avoid_init_to_null

import 'package:blurred/blurred.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'blur_controller.dart';
import 'edge_controller.dart';
import 'flow_graph_renderer.dart';
import 'node_data.dart';

class NodeRelations {
  List<Tuple2<int, int>> relations;
  NodeRelations({required this.relations});

  Tuple2<int, int> getByIndex(int i) {
    return relations[i];
  }

  @override
  String toString() {
    return relations.map((e) => e.toString()).toList().join(", ");
  }

  add(Tuple2<int, int> relation) {
    if (!relations.contains(relation)) {
      relations.add(relation);
    }
  }

  addAll(NodeRelations r) {
    for (final i in r.relations) {
      relations.add(i);
    }
  }
}

extension ToNodeRelations on NodeData {
  NodeRelations toRelations() {
    NodeRelations relations = NodeRelations(relations: []);
    if (children != null) {
      for (final i in children!) {
        if (i.children == null || i.children!.isEmpty) {
          relations.add(Tuple2(index!, i.index!));
        } else {
          relations.add(Tuple2(index!, i.index!));
          relations.addAll(i.toRelations());
        }
      }
    }

    return relations;
  }
}

enum FlowGraphDirection { horizonal, vertical }

class FlowGraph extends StatefulWidget {
  const FlowGraph(
      {Key? key,
      this.direction = FlowGraphDirection.vertical,
      this.centerLayout = true,
      required this.data,
      required this.nodes})
      : super(key: key);
  final FlowGraphDirection direction;
  final bool centerLayout;
  final NodeData data;
  final List<Widget> nodes;

  @override
  State<FlowGraph> createState() => _FlowGraphState();
}

class _FlowGraphState extends State<FlowGraph> {
  Tuple2<int, int> currentRelation = const Tuple2(-1, -1);
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();

  List<Widget> nodes = [];
  late NodeData data;

  @override
  void initState() {
    super.initState();
    nodes = widget.nodes;
    data = widget.data;
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
        return Blurred(
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
                      child: FlowGraphWidget(
                          nodeHorizontalDistance: 250,
                          nodeVerticalDistance: 200,
                          rootData: data,
                          currentRelation: currentRelation,
                          relations: relations,
                          children: nodes),
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: blurController.currentWidget,
        );
      },
    );
  }
}
