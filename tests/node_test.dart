// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_graph/graph/node_data.dart';

void main(List<String> args) {
  NodeData data = NodeData();
  data.index = 0;
  data.isRoot = true;
  data.children = [];

  NodeData data1 = NodeData();
  data1.index = 1;
  data1.isRoot = false;
  data1.children = [];

  NodeData data2 = NodeData();
  data2.index = 2;
  data2.isRoot = false;
  data2.children = [];

  data.children!.add(data1);
  data.children!.add(data2);

  NodeData data3 = NodeData();
  data3.index = 3;
  data3.isRoot = false;
  data3.children = [];

  NodeData data4 = NodeData();
  data4.index = 4;
  data4.isRoot = false;
  data4.children = [];

  data1.children!.add(data3);
  data3.children!.add(data4);

  // print(data.toJson());
  final j = data.toJson();
  print(j);

  final jj = NodeData.fromJson(j);
  print(jsonEncode(jj.toJson()));

  print(jj.toList());
}
