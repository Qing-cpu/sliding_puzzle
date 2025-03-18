import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';
import 'package:sliding_puzzle/sliding_puzzle/models/sliding_puzzle_model.dart';
import 'package:sliding_puzzle/sliding_puzzle/sliding_square.dart';

import 'models/square_model.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({
    super.key,
    this.onCompletedCallback,
    this.onBegin,
    required this.levelInfo,
    required this.width,
  });

  final LevelInfo levelInfo;

  final double width;

  final void Function(LevelData)? onCompletedCallback;

  final void Function()? onBegin;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  late final SlidingPuzzleModel slidingPuzzleModel;
  late final size = widget.levelInfo.size;
  late final double _squareWidth = widget.width / size;
  DateTime? startTime;

  bool isBegin = false;

  @override
  void initState() {
    super.initState();
    SquareModel.nullGridWidgetOffset = null;
    slidingPuzzleModel = SlidingPuzzleModel(widget.levelInfo);
    slidingPuzzleModel.shuffle();
    slidingPuzzleModel.upSquareCanMoveState();
  }

  @override
  void dispose() {
    SquareModel.nullGridWidgetOffset = null;
    super.dispose();
  }

  _onTapCallBack(int id) {
    final nullSquareIndex = slidingPuzzleModel.getNullSquareIndex();
    final tapSquareIndex = slidingPuzzleModel.getTapSquareIndex(id);
    // assert(nullSquareIndex != null && tapSquareIndex != null);

    final nullGrid =
        slidingPuzzleModel.squaresTwoDList[nullSquareIndex!.$1][nullSquareIndex
            .$2];
    slidingPuzzleModel.squaresTwoDList[nullSquareIndex.$1][nullSquareIndex.$2] =
        slidingPuzzleModel.squaresTwoDList[tapSquareIndex!.$1][tapSquareIndex
            .$2];
    slidingPuzzleModel.squaresTwoDList[tapSquareIndex.$1][tapSquareIndex.$2] =
        nullGrid;
    slidingPuzzleModel.upSquareCanMoveState();
    if (slidingPuzzleModel.isCompleted()) {
      final DateTime endTime = DateTime.now();
      final timeMil = endTime.difference(startTime!).inMilliseconds;
      final levelId = '1-1';
      final starCount = 2;

      widget.onCompletedCallback?.call(
        LevelData(levelId, starCount, timeMil, false),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.width,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 60),
        child:
            isBegin
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final squareList in slidingPuzzleModel.squaresTwoDList)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final square in squareList)
                            SlidingSquare(
                              squareModel: square,
                              onTapCallBack: _onTapCallBack,
                              squareWidth: _squareWidth,
                            ),
                        ],
                      ),
                  ],
                )
                : GestureDetector(
                  onTap: () {
                    setState(() {
                      isBegin = true;
                      startTime = DateTime.now();
                    });
                    widget.onBegin?.call();
                  },
                  child: Image.asset(slidingPuzzleModel.levelInfo.imageAssets),
                ),
      ),
    );
  }
}
