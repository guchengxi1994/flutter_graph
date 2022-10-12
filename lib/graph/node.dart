import 'package:flutter/material.dart';

class NodeDelegate extends MultiChildLayoutDelegate {
  final List<int> customLayoutId;
  Size? childSize;

  NodeDelegate({required this.customLayoutId, this.childSize});

  @override
  void performLayout(Size size) {
    Offset startPoint = const Offset(100, 100);
    childSize ??= const Size(100, 100);
    for (final i in customLayoutId) {
      if (hasChild(i)) {
        var x = startPoint.dx + i * 150;
        var y = startPoint.dy + i * 100;

        layoutChild(i, BoxConstraints.loose(childSize!));

        var result = Offset(x, y);
        positionChild(i, result);
      }
    }
  }

  @override
  bool shouldRelayout(covariant NodeDelegate oldDelegate) {
    return customLayoutId.length != oldDelegate.customLayoutId.length;
  }
}

class NodeWidget extends StatelessWidget {
  const NodeWidget(
      {Key? key,
      this.builder,
      this.child,
      this.backgroundColor,
      required this.index,
      this.isRoot = false})
      : assert(builder != null || child != null),
        super(key: key);
  final Widget? child;
  final Builder? builder;
  final Color? backgroundColor;
  final bool isRoot;
  final int index;

  @override
  bool operator ==(Object other) {
    if (other is! NodeWidget) {
      return false;
    }
    return other.index == index;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
          debugPrint(index.toString());
        },
        child: child ?? builder,
      ),
    );
  }
}
