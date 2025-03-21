import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/sliding_puzzle/models/sliding_puzzle_model.dart';
import 'package:sliding_puzzle/sliding_puzzle/sliding_square.dart';

import 'models/square_model.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({
    super.key,
    this.onCompletedCallback,
    this.onBegin,
    required this.levelInfoIndex,
    required this.reSetFlag,
    required this.width,
  });

  final int levelInfoIndex;

  final double width;

  final int reSetFlag;

  final void Function(LevelData)? onCompletedCallback;

  final void Function()? onBegin;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  late final SlidingPuzzleModel slidingPuzzleModel;
  late LevelInfo levelInfo = Levels.levelInfos[widget.levelInfoIndex];
  late final size = levelInfo.size;
  late final double _squareWidth = widget.width / size;
  DateTime? startTime;

  bool isBegin = false;

  @override
  void initState() {
    super.initState();
    SquareModel.nullGridWidgetOffset = null;
    slidingPuzzleModel = SlidingPuzzleModel(levelInfo);
    slidingPuzzleModel.shuffle();
    slidingPuzzleModel.upSquareCanMoveState();
  }

  @override
  void didUpdateWidget(SlidingPuzzle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reSetFlag != widget.reSetFlag) {
      slidingPuzzleModel.shuffle();
      slidingPuzzleModel.upSquareCanMoveState();
    }
  }

  @override
  void dispose() {
    SquareModel.nullGridWidgetOffset = null;
    super.dispose();
  }

  _onTapCallBack(int id) {
    final nullSquareIndex = slidingPuzzleModel.getNullSquareIndex();
    final tapSquareIndex = slidingPuzzleModel.getTapSquareIndex(id);

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
      final dMil = endTime.difference(startTime!).inMilliseconds;
      widget.onCompletedCallback?.call(
        LevelData(
          levelInfo.id,
          levelInfo.calculateStarRating(dMil),
          dMil,
          false,
        ),
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
                : CountdownTimer3Sec(
                  endCallBack: () {
                    setState(() {
                      isBegin = true;
                      startTime = DateTime.now();
                    });
                    widget.onBegin?.call();
                  },
                  image: Image.asset(slidingPuzzleModel.levelInfo.imageAssets),
                ),
      ),
    );
  }
}

class CountdownTimer3Sec extends StatefulWidget {
  const CountdownTimer3Sec({
    super.key,
    required this.endCallBack,
    required this.image,
  });

  final VoidCallback endCallBack;
  final Image image;

  @override
  State<CountdownTimer3Sec> createState() => _CountdownTimer3SecState();
}

class _CountdownTimer3SecState extends State<CountdownTimer3Sec> {
  int s = 3;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (s == 1) {
        timer.cancel();
        widget.endCallBack();
      }
      setState(() => s--);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        image: DecorationImage(image: widget.image.image),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        color: Colors.black26,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Text(
          '$s',
          style: TextStyle(
            color: Color(0xfffffffa),
            fontSize: 100,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 3, offset: Offset.zero),
            ],
          ),
        ),
      ),
    );
  }
}
