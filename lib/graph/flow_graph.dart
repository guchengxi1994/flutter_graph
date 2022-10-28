// ignore_for_file: avoid_init_to_null

import 'package:blurred/blurred.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'blur_controller.dart';
import 'edge_controller.dart';
import 'flow_graph_renderer.dart';
import 'node_data.dart';
import 'node_relations.dart';

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

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final relations = NodeData.fromJson(data.toJson()).toRelations();

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

          /// 为什么设置 0.001
          /// 因为 flutter web canvas渲染有bug,设置为0会报错
          /// https://github.com/flutter/flutter/issues/114055
          blurValue: blurController.shouldBlur ? 1.5 : 0.001,
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
