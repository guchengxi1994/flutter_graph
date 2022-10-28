import 'package:flutter/material.dart';
import 'package:flutter_graph/flutter_graph.dart';

class TreeGraphDemo extends StatelessWidget {
  const TreeGraphDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const TreeGraph(
        widgetHeight: 1000,
        widgetWidth: 1000,
      ),
    );
  }
}
