import 'package:flutter/material.dart';
import 'package:flutter_graph/flutter_graph.dart';

class SunGraphPage extends StatefulWidget {
  const SunGraphPage({Key? key}) : super(key: key);

  @override
  State<SunGraphPage> createState() => _SunGraphDemoState();
}

class _SunGraphDemoState extends State<SunGraphPage> {
  List<int> nodesData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
          center: center,
          width: size.width,
          height: size.height,
          children: nodesData
              .map((e) => Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(5),
                    child: Text(e.toString()),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
