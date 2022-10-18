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
    final Offset center = size.center(Offset.zero);

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SunGraphWidget(
          relations: nodeRelations,
          center: center,
          width: size.width,
          height: size.height,
          children: nodesData
              .map((e) => Container(
                    // color: Colors.transparent,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent),
                    padding: const EdgeInsets.all(5),
                    child: Center(
                        child: Text(
                      e.toString(),
                    )),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
