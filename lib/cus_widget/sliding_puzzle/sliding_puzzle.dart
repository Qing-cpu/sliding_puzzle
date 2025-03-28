import 'dart:async';

import 'package:flutter/material.dart';
import 'models/sliding_puzzle_model.dart';
import 'sliding_square.dart';
import 'models/square_model.dart';

export 'models/sliding_puzzle_model.dart';
export 'models/square_model.dart';
export 'sliding_square.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({
    super.key,
    this.onCompletedCallback,
    required this.width,
    required this.size,
    this.image,
    required this.imageAssetsList,
    this.buildNumWidget,
    required this.seconds,
    required this.onStart,
  });

  final double width;
  final int seconds;

  final Widget Function(int)? buildNumWidget;
  final VoidCallback onStart;

  final int size;
  final List<String> imageAssetsList;
  final Image? image;

  final void Function()? onCompletedCallback;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  late final SlidingPuzzleModel slidingPuzzleModel;
  late final size = widget.size;
  late final double _squareWidth = widget.width / size;

  @override
  void initState() {
    super.initState();

    SquareModel.nullGridWidgetOffset = null;
    slidingPuzzleModel = SlidingPuzzleModel(size: size, imageAssetsList: widget.imageAssetsList);
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
    final tapSquareIndex = slidingPuzzleModel.getSquareIndex(id);

    final nullGrid = slidingPuzzleModel.squaresTwoDList[nullSquareIndex!.$1][nullSquareIndex.$2];
    slidingPuzzleModel.squaresTwoDList[nullSquareIndex.$1][nullSquareIndex.$2] =
        slidingPuzzleModel.squaresTwoDList[tapSquareIndex!.$1][tapSquareIndex.$2];
    slidingPuzzleModel.squaresTwoDList[tapSquareIndex.$1][tapSquareIndex.$2] = nullGrid;
    slidingPuzzleModel.upSquareCanMoveState();
    slidingPuzzleModel.upDataSquareIndexIsProper();
    if (slidingPuzzleModel.isCompleted()) {
      widget.onCompletedCallback?.call();
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
        child: CountdownTimerSec(
          onEnd: widget.onStart,
          image: widget.image,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...slidingPuzzleModel.squaresTwoDList.map(
                (dList) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...dList.map(
                      (square) => SlidingSquare(
                        buildNumWidget: widget.buildNumWidget,
                        squareModel: square,
                        onTapCallBack: _onTapCallBack,
                        squareWidth: _squareWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownTimerSec extends StatefulWidget {
  const CountdownTimerSec({super.key, required this.image, this.seconds = 3, required this.child, required this.onEnd});

  final Image? image;
  final int seconds;
  final Widget child;
  final VoidCallback onEnd;

  @override
  State<CountdownTimerSec> createState() => _CountdownTimerSecState();
}

class _CountdownTimerSecState extends State<CountdownTimerSec> {
  Timer? _timer;
  late int s = widget.seconds;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => s--);
      if (s <= 0) {
        widget.onEnd.call();
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return s <= 0
        ? widget.child
        : Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            image: widget.image == null ? null : DecorationImage(image: widget.image!.image),
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
                shadows: [Shadow(color: Colors.black, blurRadius: 3, offset: Offset.zero)],
              ),
            ),
          ),
        );
  }
}
