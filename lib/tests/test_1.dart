import 'package:flow_graph/graph/line.dart';
import 'package:flow_graph/graph/node.dart';
import 'package:flutter/material.dart';

class MyNodesDemo1 extends StatefulWidget {
  const MyNodesDemo1({Key? key}) : super(key: key);

  @override
  State<MyNodesDemo1> createState() => _MyNodesDemo1State();
}

class _MyNodesDemo1State extends State<MyNodesDemo1> {
  List<int> nodesIds = [0, 1, 2, 3];
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CustomMultiRenderDemoPage"),
      ),
      body: Material(
        color: Colors.greenAccent,
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.width,
        child: CustomPaint(
          foregroundPainter: LinePainter(customLayoutId: nodesIds),
          child: CustomMultiChildLayout(
            key: key,
            delegate: NodeDelegate(customLayoutId: nodesIds),
            children: nodesIds
                .map((e) => LayoutId(
                    id: e,
                    child: NodeWidget(
                      index: e,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.white,
                        child: Text(e.toString()),
                      ),
                    )))
                .toList(),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amberAccent,
          ),
          onPressed: () {
            setState(() {
              nodesIds.add(nodesIds.length);
            });
            debugPrint(key.currentContext!.size.toString());
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
              if (nodesIds.length > 1) {
                nodesIds.removeLast();
              }
            });
          },
          child: const Text(
            "减",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
