import 'package:flutter/material.dart';

class BlurController extends ChangeNotifier {
  bool shouldBlur = false;
  Offset _offset = Offset.zero;
  Offset globalOffset = Offset.zero;
  Widget child = Container();
  changeState(bool b) {
    shouldBlur = b;
    notifyListeners();
  }

  changeDetails(Offset off, Widget w) {
    _offset = Offset(off.dx - globalOffset.dx, off.dy - globalOffset.dy);
    child = w;
    notifyListeners();
  }

  changeGlobalOffset(Offset offset) {
    globalOffset = offset;
    notifyListeners();
  }

  Widget? _currentWidget() {
    if (shouldBlur) {
      return Positioned(top: _offset.dy, left: _offset.dx, child: child);
    }
    return null;
  }

  Widget? get currentWidget => _currentWidget();
}
