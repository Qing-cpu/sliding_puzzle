import 'package:flutter/cupertino.dart';
import 'package:sliding_puzzle/tools/sound/sound_tools.dart';

/// 滑块数据类
class SquareModel {
  SquareModel({required this.squareImageAsset, required this.id});

  bool? needMove;

  static int nullSquareId = -1;

  final String? squareImageAsset;
  Offset? translateOffset;

  final int id;
  late int locationID = id;

  bool get isNullSquare => nullSquareId == id;

  bool? _squareIndexIsProper;

  ValueKey<int>? needShow;

  bool get squareIndexIsProper => id == locationID;

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
