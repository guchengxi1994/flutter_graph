import 'package:flutter/material.dart';

extension Contains on List<Offset> {
  bool strictContains(Offset off, double gap) {
    for (final i in this) {
      if ((i.dx - off.dx).abs() < gap || (i.dy - off.dy).abs() < gap) {
        return true;
      }
    }

    return false;
  }
}
