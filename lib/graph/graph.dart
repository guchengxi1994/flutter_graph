// ignore_for_file: avoid_init_to_null

import 'package:tuple/tuple.dart';

class NodeRelations {
  List<Tuple2<int, int>> relations;
  NodeRelations({required this.relations});

  Tuple2<int, int> getByIndex(int i) {
    return relations[i];
  }
}
