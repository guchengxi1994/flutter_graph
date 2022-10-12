// ignore_for_file: avoid_init_to_null

import 'package:flow_graph/graph/edge.dart';
import 'package:flow_graph/graph/node.dart';

class Graph {
  List<NodeWidget> children;
  List<Edge> edges = [];
  Graph({required this.children});

  int? selectedFirstNodeIndex = null;
  int? selectedSecondNodeIndex = null;

  @override
  bool operator ==(Object other) {
    if (other is! Graph) {
      return false;
    }
    return selectedFirstNodeIndex == other.selectedFirstNodeIndex &&
        selectedSecondNodeIndex == other.selectedSecondNodeIndex;
  }

  @override
  int get hashCode =>
      selectedFirstNodeIndex.hashCode + selectedSecondNodeIndex.hashCode;
}
