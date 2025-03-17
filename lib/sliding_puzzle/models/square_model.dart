import 'dart:typed_data';
import 'dart:ui';

/// 滑块数据类
class SquareModel {
  SquareModel({required this.squareImageAsset, required this.id});

  static Offset? nullGridWidgetOffset;
  static int _nullSquareId = -1;

  final String squareImageAsset;
  final int id;

  bool get isNullSquare => _nullSquareId == id;

  static set nullSquareId(int id) => _nullSquareId = id;

  bool canMove = false;
}
