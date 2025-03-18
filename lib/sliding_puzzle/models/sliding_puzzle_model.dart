import 'dart:math';
import 'package:sliding_puzzle/data/levels/level_info.dart';
import 'square_model.dart';

class SlidingPuzzleModel {
  SlidingPuzzleModel(this.levelInfo);

  List<List<SquareModel>>? _squaresTwoDList;
  final LevelInfo levelInfo;
  late final size = levelInfo.size;

  List<List<SquareModel>> get squaresTwoDList {
    if (_squaresTwoDList == null) {
      final imageAssetsList = levelInfo.squareImageAssets;

      _squaresTwoDList = List<List<SquareModel>>.generate(
        size,
        (i) => List<SquareModel>.generate(
          size,
          (j) => SquareModel(
            squareImageAsset: imageAssetsList[i * size + j],
            id: i * size + j,
          ),
        ),
      );
      // 设置 nullSquareId 末尾是空 Square
      SquareModel.nullSquareId = squaresTwoDList.last.last.id;
    }
    return _squaresTwoDList!;
  }

  bool _isInBounds((int, int) o) {
    return o.$1 >= 0 && o.$1 < size && o.$2 >= 0 && o.$2 < size;
  }

  (int, int)? getNullSquareIndex() {
    for (final gListIndexed in squaresTwoDList.indexed) {
      for (final gIndexed in gListIndexed.$2.indexed) {
        if (gIndexed.$2.isNullSquare) {
          return (gListIndexed.$1, gIndexed.$1);
        }
      }
    }
    assert(false, 'Don\'t Hava NullGrid!');
    return null;
  }

  (int, int)? getTapSquareIndex(int id) {
    for (final gListIndexed in squaresTwoDList.indexed) {
      for (final gIndexed in gListIndexed.$2.indexed) {
        if (gIndexed.$2.id == id) {
          return (gListIndexed.$1, gIndexed.$1);
        }
      }
    }
    return null;
  }

  /// 判断是否成功复原
  ///
  /// 判断所有 id 是否正确，行数 * size + 列数 == id 则id正确，所有id正确则恢复成功。
  /// 有不正确id 直接判定失败。
  /// 成功返回 true, 失败返回 false。
  bool isCompleted() => squaresTwoDList.indexed.every(
    (gridListIndexed) => gridListIndexed.$2.indexed.every(
      (gridIndexed) =>
          gridIndexed.$2.id == gridListIndexed.$1 * size + gridIndexed.$1,
    ),
  );

  void upSquareCanMoveState() {
    for (var list in squaresTwoDList) {
      for (var g in list) {
        g.canMove = false;
      }
    }
    final nullSquareIndex = getNullSquareIndex()!;
    if (_isInBounds((nullSquareIndex.$1 + 1, nullSquareIndex.$2))) {
      squaresTwoDList[nullSquareIndex.$1 + 1][nullSquareIndex.$2].canMove =
          true;
    }
    if (_isInBounds((nullSquareIndex.$1 - 1, nullSquareIndex.$2))) {
      squaresTwoDList[nullSquareIndex.$1 - 1][nullSquareIndex.$2].canMove =
          true;
    }
    if (_isInBounds((nullSquareIndex.$1, nullSquareIndex.$2 + 1))) {
      squaresTwoDList[nullSquareIndex.$1][nullSquareIndex.$2 + 1].canMove =
          true;
    }
    if (_isInBounds((nullSquareIndex.$1, nullSquareIndex.$2 - 1))) {
      squaresTwoDList[nullSquareIndex.$1][nullSquareIndex.$2 - 1].canMove =
          true;
    }
  }

  static bool isSolvable(List<List<int>> dList) {
    int inversions = 0;
    final len = dList.length;
    final count = len * len;
    final buf = [];
    for (int i = 0; i < len; i++) {
      for (int j = 0; j < len; j++) {
        final x = dList[i][j];
        // 空格跳过判断
        if (x == count - 1) {
          continue;
        }
        if (buf.any((k) => k > x)) {
          inversions++;
        }
        buf.add(x);
      }
    }
    // (count.isOdd? inversions : inversions+1).isEven;
    return count.isOdd ? inversions.isEven : inversions.isOdd;
  }

  /// 洗牌
  shuffle() {
    final r = Random(DateTime.now().millisecondsSinceEpoch);
    for (int i = 0; i < size * size * 2; i++) {
      final y1 = r.nextInt(size);
      final x1 = r.nextInt(size);
      final y2 = r.nextInt(size);
      final x2 = r.nextInt(size);
      final grid = squaresTwoDList[y1][x1];
      squaresTwoDList[y1][x1] = squaresTwoDList[y2][x2];
      squaresTwoDList[y2][x2] = grid;
    }
    if (!isSolvable(
      squaresTwoDList.map((l) => l.map((m) => m.id).toList()).toList(),
    )) {
      shuffle();
    }
  }
}
