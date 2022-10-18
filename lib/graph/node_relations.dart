import 'package:tuple/tuple.dart';

import 'node_data.dart';

class NodeRelations {
  List<Tuple2<int, int>> relations;
  NodeRelations({required this.relations});

  Tuple2<int, int> getByIndex(int i) {
    return relations[i];
  }

  @override
  String toString() {
    return relations.map((e) => e.toString()).toList().join(", ");
  }

  add(Tuple2<int, int> relation) {
    if (!relations.contains(relation)) {
      relations.add(relation);
    }
  }

  addAll(NodeRelations r) {
    for (final i in r.relations) {
      relations.add(i);
    }
  }
}

extension ToNodeRelations on NodeData {
  NodeRelations toRelations() {
    NodeRelations relations = NodeRelations(relations: []);
    if (children != null) {
      for (final i in children!) {
        if (i.children == null || i.children!.isEmpty) {
          relations.add(Tuple2(index!, i.index!));
        } else {
          relations.add(Tuple2(index!, i.index!));
          relations.addAll(i.toRelations());
        }
      }
    }

    return relations;
  }
}
