import 'package:blurred/blurred.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graph/graph/node_relations.dart';
import 'package:flutter_graph/graph/sun_graph_renderer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SunGraph extends StatefulWidget {
  const SunGraph(
      {Key? key,
      required this.nodes,
      required this.relations,
      required this.widgetHeight,
      required this.widgetWidth})
      : super(key: key);
  final List<Widget> nodes;
  final NodeRelations relations;
  final double widgetWidth;
  final double widgetHeight;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Offset center = size.center(Offset.zero);

    return Blurred(
        blurValue: 0,
        widget: GestureDetector(
          onTapDown: (details) {
            Offset position = Offset(
                controller1.offset + details.localPosition.dx,
                controller2.offset + details.localPosition.dy);
          },
          child: SizedBox(
            width: widget.widgetWidth,
            height: widget.widgetHeight,
            child: Container(
              color: Colors.amber[100],
              child: Scrollbar(
                  controller: controller1,
                  child: SingleChildScrollView(
                    controller: controller1,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: controller2,
                      child: SunGraphWidget(
                        center: center,
                        height: widget.widgetHeight,
                        width: widget.widgetWidth,
                        relations: widget.relations,
                        children: nodes,
                      ),
                    ),
                  )),
            ),
          ),
        ));
  }
}
