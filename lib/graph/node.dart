import 'package:flutter/material.dart';
import 'package:flutter_graph/graph/blur_controller.dart';
import 'package:provider/provider.dart';

class NodeWidget extends StatelessWidget {
  NodeWidget(
      {Key? key,
      this.builder,
      this.child,
      this.backgroundColor,
      required this.index,
      this.onTap,
      this.isRoot = false})
      : assert(builder != null || child != null),
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
            child: InkWell(
              onTap: onTap,
              child: child ?? builder,
            )));
  }
}
