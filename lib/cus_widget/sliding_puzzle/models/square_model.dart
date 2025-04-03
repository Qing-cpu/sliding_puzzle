import 'dart:ui';

import 'package:sliding_puzzle/tools/sound/sound_tools.dart';

/// 滑块数据类
class SquareModel {
  SquareModel({required this.squareImageAsset, required this.id});

  static bool hasMoving = false;

  static int nullSquareId = -1;

  final String? squareImageAsset;
  Offset? translateOffset;
  final int id;

  bool get isNullSquare => nullSquareId == id;

  bool? _squareIndexIsProper;

  // bool get squareIndexIsProper => _squareIndexIsProper ?? false;

  set squareIndexIsProper(bool b) {
    if (_squareIndexIsProper == b) {
      return;
    }
    if (_squareIndexIsProper != null && b == true && id != nullSquareId) {
      SoundTools.playN();
    }
    _squareIndexIsProper = b;
  }
}
