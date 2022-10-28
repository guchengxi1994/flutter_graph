import 'dart:ui';

import 'package:flow_graph_example/tree_graph_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'flow_graph_demo.dart';
import 'sun_graph_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
      // home: const PushTO(),
      routes: Routers.routers,
      initialRoute: Routers.pageMain,
    );
  }
}

class Routers {
  static const pageMain = "/pageMain";
  static const pageGraph = "/pageGraph";
  static const pageSun = "/pageSun";
  static const pageTree = "/pageTree";

  static Map<String, WidgetBuilder> routers = {
    pageMain: (context) => const PushTO(),
    pageGraph: (context) => const FlowGraphPage(),
    pageSun: (context) => const SunGraphPage(),
    pageTree: (context) => const TreeGraphDemo()
  };
}

class PushTO extends StatelessWidget {
  const PushTO({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routers.pageGraph);
                },
                child: const Text("flow")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routers.pageSun);
                },
                child: const Text("sun")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routers.pageTree);
                },
                child: const Text("tree")),
          ],
        ),
      ),
    );
  }
}
