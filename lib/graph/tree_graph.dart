import 'package:flutter/material.dart';

import 'node.dart';
import 'node_data.dart';
import 'tree_graph_renderer.dart';

class TreeGraph extends StatefulWidget {
  const TreeGraph({
    Key? key,
    required this.widgetHeight,
    required this.widgetWidth,
  }) : super(key: key);

  final double widgetWidth;
  final double widgetHeight;

  @override
  State<TreeGraph> createState() => _TreeGraphState();
}

class _TreeGraphState extends State<TreeGraph> {
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  NodeData data = NodeData();
  List<int> ids = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    data.index = 0;
    data.isRoot = true;
    data.children = [];

    NodeData data1 = NodeData();
    data1.index = 1;
    data1.parentIndex = 0;
    data1.isRoot = false;
    data1.children = [];

    NodeData data2 = NodeData();
    data2.index = 2;
    data2.parentIndex = 0;
    data2.isRoot = false;
    data2.children = [];

    data.children!.add(data1);
    data.children!.add(data2);

    NodeData data3 = NodeData();
    data3.index = 3;
    data3.parentIndex = 1;
    data3.isRoot = false;
    data3.children = [];

    NodeData data4 = NodeData();
    data4.index = 4;
    data4.parentIndex = 3;
    data4.isRoot = false;
    data4.children = [];

    data1.children!.add(data3);
    data3.children!.add(data4);

    data.children!.add(NodeData(index: 5, children: [], parentIndex: 0));
    data.children!.add(NodeData(index: 6, children: [], parentIndex: 0));
    data.children!.add(NodeData(index: 7, children: [], parentIndex: 0));
    data.children!.add(NodeData(index: 8, children: [], parentIndex: 0));
    data.children!.add(NodeData(index: 9, children: [], parentIndex: 0));
    data.children!.add(NodeData(index: 10, children: [], parentIndex: 0));
    data.children!.add(NodeData(index: 11, children: [], parentIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Offset center = size.center(Offset.zero);
    return _buildContent(center);
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
                child: TreeGraphWidget(
                  center: center,
                  height: widget.widgetHeight,
                  width: widget.widgetWidth,
                  rootData: data,
                  children: ids
                      .map((e) => NodeWidget(
                            index: e,
                            isRoot: e == 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(e.toString()),
                            ),
                          ))
                      .toList(),
                ),
              ),
            )),
      ),
    );
  }
}
