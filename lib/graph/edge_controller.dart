import 'package:flutter/material.dart';

class EdgeController extends ChangeNotifier {
  List<Path> edges = [];

  addEdge(Path p) {
    edges.add(p);
  }
}
