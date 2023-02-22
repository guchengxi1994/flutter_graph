import 'package:flutter/material.dart';
import 'package:flutter_graph/flutter_graph.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FlowGraphPage extends StatefulWidget {
  const FlowGraphPage({Key? key}) : super(key: key);

  @override
  State<FlowGraphPage> createState() => _HomePageState();
}

class DemoNodeWidgetData {
  String? url;
  String? name;
  int? index;

  DemoNodeWidgetData({this.url, this.name, this.index});

  DemoNodeWidgetData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['name'] = name;
    data['index'] = index;
    return data;
  }
}

class _HomePageState extends State<FlowGraphPage> {
  final names = ["壹零", "工程师", "文件A"];
  final urls = ["assets/images/file.png", "assets/images/user.png"];
  NodeData data = NodeData();
  List<DemoNodeWidgetData> nodesData = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      nodesData.add(
          DemoNodeWidgetData(index: i, url: urls[i % 2], name: names[i % 3]));
    }
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

    data.children!.add(NodeData(index: 5, children: []));
    data.children!.add(NodeData(index: 6, children: []));
    data.children!.add(NodeData(index: 7, children: []));
    data.children!.add(NodeData(index: 8, children: []));
    data.children!.add(NodeData(index: 9, children: []));
    data.children!.add(NodeData(index: 10, children: []));
    data.children!.add(NodeData(index: 11, children: []));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlowGraph(
        data: data,
        nodes: nodesData
            .map((e) => NodeWidget(
                  onTap: () {
                    SmartDialog.show(builder: (context) {
                      return Container(
                        height: 80,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(e.name!,
                            style: const TextStyle(color: Colors.white)),
                      );
                    });
                  },
                  isRoot: e.index == 0,
                  index: e.index!,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset(e.url!),
                        ),
                        Text(
                          e.name.toString(),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
