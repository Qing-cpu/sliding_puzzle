import 'package:flutter/cupertino.dart';

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

  ValueKey<int>? needShow;

  bool get squareIndexIsProper => id == locationID;
}
