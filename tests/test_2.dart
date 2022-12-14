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

///?????????
class CloudDemoPage extends StatefulWidget {
  @override
  _CloudDemoPageState createState() => _CloudDemoPageState();
}

class _CloudDemoPageState extends State<CloudDemoPage> {
  ///Item??????
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

          ///?????? FittedBox ?????? child
          child: SingleChildScrollView(
            child: FittedBox(
              /// Cloud ??????
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                color: Colors.brown,
                width: 500,
                height: 500,

                ///??????
                child: CloudWidget(
                  ///??????????????????
                  ratio: 1,
                  children: <Widget>[
                    for (var item in dataList)

                      ///??????????????????
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
  ///??????
  final String text;

  ///??????
  final Color color;

  ///??????
  final bool rotate;

  ///??????
  final double size;

  const CloudItemData(
    this.text,
    this.color,
    this.size,
    this.rotate,
  );
}

///CloudWidget RenderBox
///???????????? mixins  ContainerRenderObjectMixin ??? RenderBoxContainerDefaultsMixin
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

  ///??????
  double _mathPi = math.pi * 2;

  ///??????????????????
  bool _needClip = false;

  ///??????
  Clip get overflow => _overflow;
  Clip _overflow;

  set overflow(Clip value) {
    if (_overflow != value) {
      _overflow = value;
      markNeedsPaint();
    }
  }

  ///??????
  double? _ratio;

  double get ratio => _ratio!;

  set ratio(double value) {
    if (_ratio != value) {
      _ratio = value;
      markNeedsPaint();
    }
  }

  ///?????????????????????
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

  ///????????????????????????
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! RenderCloudParentData) {
      child.parentData = RenderCloudParentData();
    }
  }

  @override
  void performLayout() {
    ///?????????????????????
    _needClip = false;

    ///?????? childCount ??????
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    ///???????????????
    var recordRect = Rect.zero;
    var previousChildRect = Rect.zero;

    RenderBox? child = firstChild;

    while (child != null) {
      var curIndex = -1;

      ///????????????
      final RenderCloudParentData childParentData =
          child.parentData as RenderCloudParentData;

      child.layout(constraints, parentUsesSize: true);

      var childSize = child.size;

      ///????????????
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      do {
        ///?????? xy ????????????
        var rX = ratio >= 1 ? ratio : 1.0;
        var rY = ratio <= 1 ? ratio : 1.0;

        ///????????????
        var step = 0.02 * _mathPi;
        var rotation = 0.0;
        var angle = curIndex * step;
        var angleRadius = 5 + 5 * angle;
        var x = rX * angleRadius * math.cos(angle + rotation);
        var y = rY * angleRadius * math.sin(angle + rotation);
        var position = Offset(x, y);

        ///????????????????????????
        var childOffset = position - Alignment.center.alongSize(childSize);

        ++curIndex;

        ///???????????????
        childParentData.offset = childOffset;

        ///??????????????????
      } while (overlaps(childParentData));

      ///????????????
      previousChildRect = childParentData.content;
      recordRect = recordRect.expandToInclude(previousChildRect);

      ///?????????
      child = childParentData.nextSibling;
    }

    ///??????????????????
    size = constraints
        .tighten(
          height: recordRect.height,
          width: recordRect.width,
        )
        .smallest;

    ///??????
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

    ///???????????????
    _needClip =
        size.width < recordRect.width || size.height < recordRect.height;
  }

  ///??????????????????
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
