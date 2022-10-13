import 'package:flutter_graph/graph/edge.dart';
import 'package:flutter/material.dart';

class EdgeController extends ChangeNotifier {
  List<Edge> edges = [];

  addEdge(Edge e) {
    edges.add(e);
  }
}
