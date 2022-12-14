class NodeData {
  int? index;
  List<NodeData>? children;
  bool? isRoot;
  int? _depth;
  int? parentIndex;

  NodeData({this.children, this.index, this.isRoot, this.parentIndex}) {
    if (isRoot == true) {
      parentIndex = null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! NodeData) {
      return false;
    }
    return index != null && other.index == index;
  }

  @override
  String toString() {
    return index.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['isRoot'] = isRoot;
    if (_depth != null) {
      data['depth'] = _depth;
    }
    data['parentIndex'] = parentIndex;
    return data;
  }

  NodeData.fromJson(Map<String, dynamic> json, {int depth = 0}) {
    _depth = depth;
    index = json['index'];
    if (json['children'] != null) {
      children = <NodeData>[];
      json['children'].forEach((v) {
        children!.add(NodeData.fromJson(v, depth: depth + 1));
      });
    }
    parentIndex = json['parentIndex'];
    isRoot = json['isRoot'];
  }

  Map<int, int> countPerDepth = {};
  int maxDepth = -1;

  List<NodeData> toList({bool getDepths = false}) {
    List<NodeData> list = [];
    NodeData d;
    if (_depth == null) {
      d = NodeData.fromJson(toJson());
    } else {
      d = this;
    }

    if (d.children != null) {
      for (final i in d.children!) {
        list.addAll(i.toList());
      }
    }
    list.add(d);

    if (getDepths) {
      countPerDepth.clear();
      for (final n in list) {
        if (countPerDepth.keys.contains(n.depth!)) {
          countPerDepth[n.depth!] = countPerDepth[n.depth!]! + 1;
        } else {
          countPerDepth[n.depth!] = 1;
          if (n.depth! > maxDepth) {
            maxDepth = n.depth!;
          }
        }
      }
    }

    return list;
  }

  int? get depth => _depth;

  @override
  int get hashCode => _depth.hashCode + children.hashCode;
}
