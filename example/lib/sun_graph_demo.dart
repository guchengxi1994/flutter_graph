import 'package:flutter/material.dart';
import 'package:flutter_graph/flutter_graph.dart';

class SunGraphPage extends StatefulWidget {
  const SunGraphPage({Key? key}) : super(key: key);

  @override
  State<SunGraphPage> createState() => _SunGraphDemoState();
}

class _SunGraphDemoState extends State<SunGraphPage> {
  List<int> nodesData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
  NodeRelations nodeRelations = NodeRelations(relations: const [
    Tuple2<int, int>(0, 2),
    Tuple2<int, int>(0, 3),
    Tuple2<int, int>(0, 4),
    Tuple2<int, int>(0, 5),
    Tuple2<int, int>(0, 6),
    Tuple2<int, int>(7, 0),
    Tuple2<int, int>(8, 0),
    Tuple2<int, int>(9, 0),
    Tuple2<int, int>(10, 0),
    Tuple2<int, int>(11, 0),
    Tuple2<int, int>(12, 0),
    Tuple2<int, int>(13, 0),
    Tuple2<int, int>(1, 0),
  ]);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          color: Colors.greenAccent,
          width: 200,
        ),
        Expanded(
            child: SunGraph(
          onEdgeSelected: (from, to) {
            debugPrint(from.toString());
            debugPrint(to.toString());
          },
          needsBlur: true,
          relations: nodeRelations,
          widgetWidth: size.width,
          widgetHeight: size.height,
          nodes: nodesData
              .map(
                (e) => NodeWidget(
                  needsBlur: true,
                  index: e,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset("assets/images/file.png"),
                        ),
                        Text(
                          e.toString(),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ))
      ],
    );
  }
}
