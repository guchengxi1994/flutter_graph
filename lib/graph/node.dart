import 'package:flutter/material.dart';
import 'package:flutter_graph/graph/blur_controller.dart';
import 'package:provider/provider.dart';

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

class NodeWidget extends StatelessWidget {
  NodeWidget({
    Key? key,
    this.builder,
    this.child,
    this.backgroundColor,
    required this.index,
    this.onTap,
    this.isRoot = false,
  })  : assert(builder != null || child != null),
        super(key: key);
  final Widget? child;
  final Builder? builder;
  final Color? backgroundColor;
  final bool isRoot;
  final int index;
  final VoidCallback? onTap;

  @override
  bool operator ==(Object other) {
    if (other is! NodeWidget) {
      return false;
    }
    return other.index == index;
  }

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Theme.of(context).primaryColor,
      child: MouseRegion(
        onExit: (event) {
          context.read<BlurController>().changeState(false);
        },
        onHover: (event) {
          context.read<BlurController>().changeState(true);
        },
        onEnter: (event) {
          RenderBox renderObject =
              globalKey.currentContext?.findRenderObject() as RenderBox;
          Offset off = renderObject.localToGlobal(Offset.zero);

          context.read<BlurController>().changeDetails(
              off,
              FakeNodeWidget(
                onTap: onTap ??
                    () {
                      debugPrint(index.toString());
                    },
                builder: builder,
                child: child,
              ));
        },
        child: SizedBox(
          key: globalKey,
          child: child ?? builder,
        ),
      ),
    );
  }
}

class FakeNodeWidget extends StatelessWidget {
  const FakeNodeWidget(
      {Key? key,
      this.builder,
      this.child,
      this.backgroundColor,
      required this.onTap})
      : assert(builder != null || child != null),
        super(key: key);

  final Widget? child;
  final Builder? builder;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 4,
        color: backgroundColor ?? Theme.of(context).primaryColor,
        child: MouseRegion(
            onExit: (event) {
              context.read<BlurController>().changeState(false);
            },
            onHover: (event) {
              context.read<BlurController>().changeState(true);
            },
            child: Container(
              constraints: const BoxConstraints(
                  minHeight: 1, maxHeight: 100, minWidth: 1, maxWidth: 100),
              child: InkWell(
                onTap: onTap,
                child: child ?? builder,
              ),
            )));
  }
}
