import 'dart:ui';

import 'package:sliding_puzzle/tools/sound/sound_tools.dart';

/// 滑块数据类
class SquareModel {
  SquareModel({required this.squareImageAsset, required this.id});

  static bool hasMoving = false;

  static Offset? nullGridWidgetOffset;
  static int _nullSquareId = -1;

  final String squareImageAsset;
  final int id;

  bool get isNullSquare => _nullSquareId == id;

  static set nullSquareId(int id) => _nullSquareId = id;

  bool canMove = false;
  bool _squareIndexIsProper = false;

  bool get squareIndexIsProper => _squareIndexIsProper;

  set squareIndexIsProper(bool b) {
    if (_squareIndexIsProper == b) {
      return;
    }
    if (b == true) {
      SoundTools.playCheck();
    }
    _squareIndexIsProper = b;
  }
}
