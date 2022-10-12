import 'package:flutter/material.dart';

class Edge {
  int firstNodeIndex;
  int secondNodeIndex;
  Path? path;

  Edge(
      {required this.firstNodeIndex, required this.secondNodeIndex, this.path});

  @override
  bool operator ==(Object other) {
    if (other is! Edge) {
      return false;
    }
    return firstNodeIndex == other.firstNodeIndex &&
        secondNodeIndex == other.secondNodeIndex;
  }

  @override
  int get hashCode => firstNodeIndex.hashCode + secondNodeIndex.hashCode;
}
