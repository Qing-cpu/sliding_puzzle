import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/sliding_puzzle/models/sliding_puzzle_model.dart';
import 'package:sliding_puzzle/sliding_puzzle/sliding_square.dart';

import 'models/square_model.dart';

export 'models/sliding_puzzle_model.dart';
export 'models/square_model.dart';
export 'sliding_square.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({
    super.key,
    this.onCompletedCallback,
    this.onBegin,
    required this.reSetFlag,
    required this.width,
    required this.size,
    required this.bigImageAsset,
    required this.imageAssetsList,
    this.isSpeedModel = false,
    this.isOnlyNum = false,
    this.buildNumWidget,
  });

  final bool isSpeedModel;
  final bool isOnlyNum;
  final double width;

  final int reSetFlag;

  final Widget Function(int)? buildNumWidget;

  final int size;
  final List<String> imageAssetsList;
  final String bigImageAsset;

  final void Function(int)? onCompletedCallback;

  final void Function()? onBegin;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  late final SlidingPuzzleModel slidingPuzzleModel;
  late final size = widget.size;
  late final double _squareWidth = widget.width / size;
  DateTime? startTime;

  bool isBegin = false;

  @override
  void initState() {
    super.initState();
    SquareModel.nullGridWidgetOffset = null;
    slidingPuzzleModel = SlidingPuzzleModel(size: size, imageAssetsList: widget.imageAssetsList);
    slidingPuzzleModel.shuffle();
    slidingPuzzleModel.upSquareCanMoveState();
    if (widget.isSpeedModel) {
      startTime = DateTime.now();
    }
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

    final nullGrid = slidingPuzzleModel.squaresTwoDList[nullSquareIndex!.$1][nullSquareIndex.$2];
    slidingPuzzleModel.squaresTwoDList[nullSquareIndex.$1][nullSquareIndex.$2] =
        slidingPuzzleModel.squaresTwoDList[tapSquareIndex!.$1][tapSquareIndex.$2];
    slidingPuzzleModel.squaresTwoDList[tapSquareIndex.$1][tapSquareIndex.$2] = nullGrid;
    slidingPuzzleModel.upSquareCanMoveState();
    if (slidingPuzzleModel.isCompleted()) {
      final DateTime endTime = DateTime.now();
      final dMil = endTime.difference(startTime!).inMilliseconds;
      widget.onCompletedCallback?.call(dMil);
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
            widget.isSpeedModel || isBegin
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...slidingPuzzleModel.squaresTwoDList.map(
                      (dList) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...dList.map(
                            (square) => SlidingSquare(
                              buildNumWidget: widget.buildNumWidget,
                              isOnlyNum: widget.isOnlyNum,
                              squareModel: square,
                              onTapCallBack: _onTapCallBack,
                              squareWidth: _squareWidth,
                            ),
                          ),
                        ],
                      ),
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
                  image: widget.isOnlyNum ? null : Image.asset(widget.bigImageAsset),
                ),
      ),
    );
  }
}

class CountdownTimer3Sec extends StatefulWidget {
  const CountdownTimer3Sec({super.key, required this.endCallBack, required this.image});

  final VoidCallback endCallBack;
  final Image? image;

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
