import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/sliding_puzzle/models/square_model.dart';
import 'package:sliding_puzzle/tools/levels/level_info.dart';
import 'package:sliding_puzzle/tools/levels/levels.dart';

import '../../../tools/sound/sound_tools.dart';
typedef BuildSquareWidgetCallback = Widget Function({required int num, bool? isOk, bool? hasTweenColor});
class SlidingPuzzleController {
  SlidingPuzzleController({
    this.levelIndex,
    this.size,
    required this.buildSquareWidget,
    required this.onCompletedCallback,
    required this.onStart,
    required this.width,
  });

  double width;
  final BuildSquareWidgetCallback buildSquareWidget;
  final void Function()? onCompletedCallback;
  final VoidCallback onStart;
  int? size;

  static int? _level;

  static int get level {
    final res = _level ?? 1;
    _level = null;
    return res;
  }

  static set level(int l) {
    _level = l;
  }

  Timer? _timer;

  ValueNotifier<int> s = ValueNotifier(3);

  LevelInfo? get levelInfo => levelIndex == null ? null : Levels.levelInfos[levelIndex!];

  List<String>? get imageAssetsList => levelInfo?.squareImageAssets;

  int get _size => size ?? levelInfo!.size;

  int? levelIndex;
  final ValueNotifier<int> reSetTag = ValueNotifier(0);

  double get squareWidth => width / _size;

  List<List<SquareModel>>? _squaresTwoDList;

  /// 生成2维数组
  List<List<SquareModel>> get squaresTwoDList {
    if (_squaresTwoDList == null) {
      _squaresTwoDList = List<List<SquareModel>>.generate(
        _size,
        (i) => List<SquareModel>.generate(
          _size,
          (j) => SquareModel(squareImageAsset: imageAssetsList?[i * _size + j], id: i * _size + j),
        ),
      );
      // 设置 nullSquareId 末尾是空 Square
      SquareModel.nullSquareId = squaresTwoDList.last.last.id;
    }
    return _squaresTwoDList!;
  }

  bool _isInBounds((int, int) o) {
    return o.$1 >= 0 && o.$1 < _size && o.$2 >= 0 && o.$2 < _size;
  }

  /// 返回空白 Square 的位置
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

  /// 返回 Square 的位置
  (int, int)? getSquareIndex(int id) {
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
      (gridIndexed) => gridIndexed.$2.id == gridListIndexed.$1 * _size + gridIndexed.$1,
    ),
  );

  void upSquareTranslateOffset() {
    final nullSquareIndex = getNullSquareIndex()!;
    final nY = nullSquareIndex.$1;
    final nX = nullSquareIndex.$2;

    for (var listIndexed in squaresTwoDList.indexed) {
      for (var gIndexed in listIndexed.$2.indexed) {
        final x = gIndexed.$1;
        final y = listIndexed.$1;
        if (x == nX) {
          if (y > nY) {
            // 在 NQ 下面, 可以上移动
            gIndexed.$2.translateOffset = Offset(0, -squareWidth);
          } else {
            gIndexed.$2.translateOffset = Offset(0, squareWidth);
          }
        }
        if (y == nY) {
          if (x > nX) {
            // 在 NQ 右面, 可以左移动
            gIndexed.$2.translateOffset = Offset(-squareWidth, 0);
          } else {
            gIndexed.$2.translateOffset = Offset(squareWidth, 0);
          }
        }
      }
    }
  }

  /// 判断是否有解
  static bool isSolvable(List<List<int>> dList) {
    int n = dList.length;
    int m = dList[0].length;
    List<int> flattened = [];
    int blankRowFromBottom = 0;

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        int val = dList[i][j];
        if (val == n * m - 1) {
          blankRowFromBottom = n - i; // 从下往上的行数
        } else {
          flattened.add(val);
        }
      }
    }

    int inversions = 0;
    for (int i = 0; i < flattened.length; i++) {
      for (int j = i + 1; j < flattened.length; j++) {
        if (flattened[i] > flattened[j]) {
          inversions++;
        }
      }
    }

    if (m % 2 == 1) {
      // 列数为奇数
      return inversions % 2 == 0;
    } else {
      // 列数为偶数
      return (inversions + blankRowFromBottom) % 2 == 0;
    }
  }

  /// 洗牌
  shuffle() {
    final r = Random(DateTime.now().millisecond);
    var yx = getNullSquareIndex() ?? (_size - 1, _size - 1);
    (int, int) random() {
      late (int, int) res;
      switch (r.nextInt(4)) {
        case 0:
          res = (yx.$1, yx.$2 + 1);
          break;
        case 1:
          res = (yx.$1, yx.$2 - 1);
          break;
        case 2:
          res = (yx.$1 + 1, yx.$2);
          break;
        case 3:
          res = (yx.$1 - 1, yx.$2);
          break;
      }
      if (!_isInBounds(res)) {
        res = random();
      }
      return res;
    }

    for (int i = 0; i < _size * _size * 10 * level; i++) {
      var newYX = random();
      var gridX = squaresTwoDList[newYX.$1][newYX.$2];
      squaresTwoDList[newYX.$1][newYX.$2] = squaresTwoDList[yx.$1][yx.$2];
      squaresTwoDList[yx.$1][yx.$2] = gridX;
      yx = newYX;
    }

    upDataSquareIndexIsProper();
  }

  /// 检查所有 Square 位置是否正确，并保存结果
  void upDataSquareIndexIsProper() {
    for (var list in squaresTwoDList.indexed) {
      for (var qI in list.$2.indexed) {
        qI.$2.squareIndexIsProper = qI.$2.id == list.$1 * _size + qI.$1;
      }
    }
  }

  void dispose() {
    s.value = 0;
    _timer?.cancel();
    reSetTag.dispose(); // 记得在不再使用时释放资源
  }

  void reSet() {
    if ((_squaresTwoDList?.length ?? 0) < _size * _size) {
      _squaresTwoDList = null;
    }
    shuffle();
    upSquareTranslateOffset();
    reSetTag.value++;
    if (s.value <= 0) {
      onStart();
    }
  }

  void next() {
    levelIndex = levelIndex! + 1;
    _squaresTwoDList = null;
    reSet();
  }

  void _switch(int x1, int y1, int x2, int y2) {
    final list = squaresTwoDList;
    final x = list[y1][x1];
    list[y1][x1] = list[y2][x2];
    list[y2][x2] = x;
  }

  void updateSquare((int, int)? tapSquareIndex) {
    final x = tapSquareIndex!.$2;
    final y = tapSquareIndex.$1;

    final nullSquareIndex = getNullSquareIndex();
    final nx = nullSquareIndex!.$2;
    final ny = nullSquareIndex.$1;

    int dx = nx - x;
    int dy = ny - y;

    while (dx != 0) {
      if (dx > 0) {
        _switch(x + dx - 1, y, x + dx, y);
        dx--;
      } else {
        _switch(x + dx + 1, y, x + dx, y);
        dx++;
      }
    }

    while (dy != 0) {
      if (dy > 0) {
        _switch(x, y + dy - 1, x, y + dy);
        dy--;
      } else {
        _switch(x, y + dy + 1, x, y + dy);
        dy++;
      }
    }
    upSquareTranslateOffset();
    upDataSquareIndexIsProper();
    if (isCompleted()) {
      SoundTools.playCompleted();
      onCompletedCallback?.call();
    }
  }

  //
  // void leftMove() {
  //   final yx = getNullSquareIndex()!;
  //   final ny = yx.$1;
  //   final nx = yx.$2 + 1;
  //   if (nx < _size) {
  //     updateSquare((ny, nx));
  //   }
  // }
  //
  // void rightMove() {
  //   final yx = getNullSquareIndex()!;
  //   final ny = yx.$1;
  //   final nx = yx.$2 - 1;
  //   if (nx >= 0) {
  //     updateSquare((ny, nx));
  //   }
  // }
  //
  // void topMove() {
  //   final yx = getNullSquareIndex()!;
  //   final ny = yx.$1 + 1;
  //   final nx = yx.$2;
  //   if (ny < _size) {
  //     updateSquare((ny, nx));
  //   }
  // }
  //
  // void bottomMove() {
  //   final yx = getNullSquareIndex()!;
  //   final ny = yx.$1 - 1;
  //   final nx = yx.$2;
  //   if (ny >= 0) {
  //     updateSquare((ny, nx));
  //   }
  // }

  int? _id;

  void playSquareAni(int id) {
    _id = id;
    final si = getSquareIndex(id);
    var y = si!.$1;
    var x = si.$2;
    final ni = getNullSquareIndex();
    var ny = ni!.$1;
    var nx = ni.$2;
    var dx = nx - x;
    var dy = ny - y;
    while (dx != 0) {
      squaresTwoDList[y][nx - dx].needMove = true;
      if (dx > 0) {
        dx--;
      } else {
        dx++;
      }
    }

    while (dy != 0) {
      squaresTwoDList[ny - dy][x].needMove = true;
      if (dy > 0) {
        dy--;
      } else {
        dy++;
      }
    }
  }

  bool get needMove => squaresTwoDList.any((list) => list.any((s) => s.needMove == true));

  void endPlay() {
    if (_id != null) {
      for (var list in squaresTwoDList) {
        for (var value in list) {
          value.translateOffset = null;
          value.needMove = null;
        }
      }
      updateSquare(getSquareIndex(_id!));
      _id = null;
    }
  }
}

typedef SetStateCallBack = void Function();
