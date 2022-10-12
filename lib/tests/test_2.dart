// // ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

// class CustomLayoutParentData extends ContainerBoxParentData<RenderBox> {}

// // ignore: must_be_immutable
// class ScrollableRenderObjectWidget extends MultiChildRenderObjectWidget {
//   ScrollableRenderObjectWidget({Key? key, required this.nodes})
//       : super(key: key);
//   List<int> nodes;

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return _RenderObjectWidget(context: context, nodes: nodes);
//   }

//   @override
//   void updateRenderObject(
//       BuildContext context, covariant _RenderObjectWidget renderObject) {
//     renderObject.nodes = nodes;
//   }
// }

// class _RenderObjectWidget extends RenderBox
//     with
//         ContainerRenderObjectMixin<RenderBox, CustomLayoutParentData>,
//         RenderBoxContainerDefaultsMixin<RenderBox, CustomLayoutParentData> {
//   final BuildContext context;
//   List<int> nodes;

//   _RenderObjectWidget({required this.context, required this.nodes}){
//     addAll(children)
//   }

//   @override
//   double computeMinIntrinsicWidth(double height) {
//     return _getIntrinsicWidth(
//         (RenderBox child) => child.getMinIntrinsicWidth(height));
//   }

//   @override
//   double computeMaxIntrinsicWidth(double height) {
//     return _getIntrinsicWidth(
//         (RenderBox child) => child.getMaxIntrinsicWidth(height));
//   }

//   @override
//   double computeMinIntrinsicHeight(double width) {
//     return _getIntrinsicHeight(
//         (RenderBox child) => child.getMinIntrinsicHeight(width));
//   }

//   @override
//   double computeMaxIntrinsicHeight(double width) {
//     return _getIntrinsicHeight(
//         (RenderBox child) => child.getMaxIntrinsicHeight(width));
//   }

//   double _getIntrinsicWidth(double Function(RenderBox child) childSize) {
//     double maxSpace = 0.0;
//     RenderBox? child = firstChild;
//     while (child != null) {
//       maxSpace = math.max(maxSpace, childSize(child));
//       final FlexParentData childParentData = child.parentData as FlexParentData;
//       child = childParentData.nextSibling;
//     }
//     return maxSpace;
//   }

//   double _getIntrinsicHeight(double Function(RenderBox child) childSize) {
//     double inflexibleSpace = 0.0;
//     RenderBox? child = firstChild;
//     while (child != null) {
//       inflexibleSpace += childSize(child);
//       final FlexParentData childParentData = child.parentData as FlexParentData;
//       child = childParentData.nextSibling;
//     }
//     return inflexibleSpace;
//   }

//   @override
//   void performLayout() {
//     if (childCount == 0) {
//       return;
//     }

//     double width = constraints.maxWidth;
//     double height = 0;

//     RenderBox? child = firstChild;
//     var index = 0;
//     while (child != null) {
//       final CustomLayoutParentData childParentData =
//           child.parentData as CustomLayoutParentData;
//       child.layout(BoxConstraints.loose(constraints.biggest),
//           parentUsesSize: true);
//       var childSize = child.size;
//       var element = nodes.elementAt(index);

//       child = childParentData.nextSibling;
//       index++;
//     }
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     defaultPaint(context, offset);
//   }

//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
//       defaultHitTestChildren(result, position: position);

//   @override
//   void setupParentData(covariant RenderObject child) {
//     if (child.parentData is! CustomLayoutParentData) {
//       child.parentData = CustomLayoutParentData();
//     }
//   }
// }

///云词图
class CloudDemoPage extends StatefulWidget {
  @override
  _CloudDemoPageState createState() => _CloudDemoPageState();
}

class _CloudDemoPageState extends State<CloudDemoPage> {
  ///Item数据
  List<CloudItemData> dataList = const <CloudItemData>[
    CloudItemData('CloudGSY11111', Colors.amberAccent, 10, false),
    CloudItemData('CloudGSY3333333T', Colors.limeAccent, 16, false),
    CloudItemData('CloudGSYXXXXXXX', Colors.black, 14, true),
    CloudItemData('CloudGSY55', Colors.black87, 33, false),
    CloudItemData('CloudGSYAA', Colors.blueAccent, 15, false),
    CloudItemData('CloudGSY44', Colors.indigoAccent, 16, false),
    CloudItemData('CloudGSYBWWWWWW', Colors.deepOrange, 12, true),
    CloudItemData('CloudGSY<<<', Colors.blue, 20, true),
    CloudItemData('FFFFFFFFFFFFFF', Colors.blue, 12, false),
    CloudItemData('BBBBBBBBBBB', Colors.deepPurpleAccent, 14, false),
    CloudItemData('CloudGSY%%%%', Colors.orange, 20, true),
    CloudItemData('CloudGSY%%%%%%%', Colors.blue, 12, false),
    CloudItemData('CloudGSY&&&&', Colors.indigoAccent, 10, false),
    CloudItemData('CloudGSYCCCC', Colors.yellow, 14, true),
    CloudItemData('CloudGSY****', Colors.blueAccent, 13, false),
    CloudItemData('CloudGSYRRRR', Colors.redAccent, 12, true),
    CloudItemData('CloudGSYFFFFF', Colors.blue, 12, false),
    CloudItemData('CloudGSYBBBBBBB', Colors.cyanAccent, 15, false),
    CloudItemData('CloudGSY222222', Colors.blue, 16, false),
    CloudItemData('CloudGSY1111111111111111', Colors.tealAccent, 19, false),
    CloudItemData('CloudGSY####', Colors.black54, 12, false),
    CloudItemData('CloudGSYFDWE', Colors.purpleAccent, 14, true),
    CloudItemData('CloudGSY22222', Colors.indigoAccent, 19, false),
    CloudItemData('CloudGSY44444', Colors.yellowAccent, 18, true),
    CloudItemData('CloudGSY33333', Colors.lightBlueAccent, 17, false),
    CloudItemData('CloudGSYXXXXXXXX', Colors.blue, 16, true),
    CloudItemData('CloudGSYFFFFFFFF', Colors.black26, 14, false),
    CloudItemData('CloudGSYZUuzzuuu', Colors.blue, 16, true),
    CloudItemData('CloudGSYVVVVVVVVV', Colors.orange, 12, false),
    CloudItemData('CloudGSY222223', Colors.black26, 13, true),
    CloudItemData('CloudGSYGFD', Colors.yellow, 14, true),
    CloudItemData('GGGGGGGGGG', Colors.deepPurpleAccent, 14, false),
    CloudItemData('CloudGSYFFFFFF', Colors.blueAccent, 10, true),
    CloudItemData('CloudGSY222', Colors.limeAccent, 12, false),
    CloudItemData('CloudGSY6666', Colors.blue, 20, true),
    CloudItemData('CloudGSY33333', Colors.teal, 14, false),
    CloudItemData('YYYYYYYYYYYYYY', Colors.deepPurpleAccent, 14, false),
    CloudItemData('CloudGSY  3  ', Colors.blue, 10, false),
    CloudItemData('CloudGSYYYYYY', Colors.black54, 17, true),
    CloudItemData('CloudGSYCC', Colors.lightBlueAccent, 11, false),
    CloudItemData('CloudGSYGGGGG', Colors.deepPurpleAccent, 10, false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("CloudDemoPage"),
      ),
      body: new Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,

          ///利用 FittedBox 约束 child
          child: SingleChildScrollView(
            child: FittedBox(
              /// Cloud 布局
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                color: Colors.brown,
                width: 500,
                height: 500,

                ///布局
                child: CloudWidget(
                  ///容器宽高比例
                  ratio: 1,
                  children: <Widget>[
                    for (var item in dataList)

                      ///判断是否旋转
                      RotatedBox(
                        quarterTurns: item.rotate ? 1 : 0,
                        child: Text(
                          item.text,
                          style: new TextStyle(
                            fontSize: item.size,
                            color: item.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CloudItemData {
  ///文本
  final String text;

  ///颜色
  final Color color;

  ///旋转
  final bool rotate;

  ///大小
  final double size;

  const CloudItemData(
    this.text,
    this.color,
    this.size,
    this.rotate,
  );
}

///CloudWidget RenderBox
///默认都会 mixins  ContainerRenderObjectMixin 和 RenderBoxContainerDefaultsMixin
class RenderCloudWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, RenderCloudParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, RenderCloudParentData> {
  RenderCloudWidget({
    List<RenderBox>? children,
    Clip overflow = Clip.none,
    double? ratio,
  })  : _ratio = ratio,
        _overflow = overflow {
    addAll(children);
  }

  ///圆周
  double _mathPi = math.pi * 2;

  ///是否需要裁剪
  bool _needClip = false;

  ///溢出
  Clip get overflow => _overflow;
  Clip _overflow;

  set overflow(Clip value) {
    if (_overflow != value) {
      _overflow = value;
      markNeedsPaint();
    }
  }

  ///比例
  double? _ratio;

  double get ratio => _ratio!;

  set ratio(double value) {
    if (_ratio != value) {
      _ratio = value;
      markNeedsPaint();
    }
  }

  ///是否重复区域了
  bool overlaps(RenderCloudParentData data) {
    Rect rect = data.content;

    RenderBox? child = data.previousSibling;

    if (child == null) {
      return false;
    }

    do {
      RenderCloudParentData childParentData =
          child!.parentData as RenderCloudParentData;
      if (rect.overlaps(childParentData.content)) {
        return true;
      }
      child = childParentData.previousSibling;
    } while (child != null);
    return false;
  }

  ///设置为我们的数据
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! RenderCloudParentData) {
      child.parentData = RenderCloudParentData();
    }
  }

  @override
  void performLayout() {
    ///默认不需要裁剪
    _needClip = false;

    ///没有 childCount 不玩
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    ///初始化区域
    var recordRect = Rect.zero;
    var previousChildRect = Rect.zero;

    RenderBox? child = firstChild;

    while (child != null) {
      var curIndex = -1;

      ///提出数据
      final RenderCloudParentData childParentData =
          child.parentData as RenderCloudParentData;

      child.layout(constraints, parentUsesSize: true);

      var childSize = child.size;

      ///记录大小
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      do {
        ///设置 xy 轴的比例
        var rX = ratio >= 1 ? ratio : 1.0;
        var rY = ratio <= 1 ? ratio : 1.0;

        ///调整位置
        var step = 0.02 * _mathPi;
        var rotation = 0.0;
        var angle = curIndex * step;
        var angleRadius = 5 + 5 * angle;
        var x = rX * angleRadius * math.cos(angle + rotation);
        var y = rY * angleRadius * math.sin(angle + rotation);
        var position = Offset(x, y);

        ///计算得到绝对偏移
        var childOffset = position - Alignment.center.alongSize(childSize);

        ++curIndex;

        ///设置为遏制
        childParentData.offset = childOffset;

        ///判处是否交叠
      } while (overlaps(childParentData));

      ///记录区域
      previousChildRect = childParentData.content;
      recordRect = recordRect.expandToInclude(previousChildRect);

      ///下一个
      child = childParentData.nextSibling;
    }

    ///调整布局大小
    size = constraints
        .tighten(
          height: recordRect.height,
          width: recordRect.width,
        )
        .smallest;

    ///居中
    var contentCenter = size.center(Offset.zero);
    var recordRectCenter = recordRect.center;
    var transCenter = contentCenter - recordRectCenter;
    child = firstChild;
    while (child != null) {
      final RenderCloudParentData childParentData =
          child.parentData as RenderCloudParentData;
      childParentData.offset += transCenter;
      child = childParentData.nextSibling;
    }

    ///超过了嘛？
    _needClip =
        size.width < recordRect.width || size.height < recordRect.height;
  }

  ///设置绘制默认
  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_needClip || _overflow == Clip.none) {
      defaultPaint(context, offset);
    } else {
      context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        defaultPaint,
      );
    }
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result as BoxHitTestResult,
        position: position);
  }
}

/// CloudParentData
class RenderCloudParentData extends ContainerBoxParentData<RenderBox> {
  late double width;
  late double height;

  Rect get content => Rect.fromLTWH(
        offset.dx,
        offset.dy,
        width,
        height,
      );
}

class CloudWidget extends MultiChildRenderObjectWidget {
  final Clip overflow;
  final double ratio;

  CloudWidget({
    Key? key,
    this.ratio = 1,
    this.overflow = Clip.none,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCloudWidget(
      ratio: ratio,
      overflow: overflow,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCloudWidget renderObject) {
    renderObject
      ..ratio = ratio
      ..overflow = overflow;
  }
}
