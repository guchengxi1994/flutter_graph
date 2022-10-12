import 'package:flow_graph/graph/node.dart';
import 'package:flutter/material.dart';

class Edge {
  Path path;
  NodeWidget firstNode;
  NodeWidget secondNode;
  bool isSelected;
  Edge(
      {required this.firstNode,
      required this.secondNode,
      required this.path,
      this.isSelected = false});

  @override
  bool operator ==(Object other) {
    if (other is! Edge) {
      return false;
    }
    return path == other.path && isSelected == other.isSelected;
  }

  @override
  int get hashCode => path.hashCode;
}
