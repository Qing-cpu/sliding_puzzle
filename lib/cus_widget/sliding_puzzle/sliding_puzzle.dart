import 'dart:ui';

import 'package:flutter/material.dart';
import 'models/sliding_puzzle_model.dart';
import 'sliding_square.dart';

export 'models/sliding_puzzle_model.dart';
export 'models/square_model.dart';
export 'sliding_square.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({super.key, required this.slidingPuzzleController});

  final SlidingPuzzleController slidingPuzzleController;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  SlidingPuzzleController get slidingPuzzleController =>
      widget.slidingPuzzleController;

  @override
  void initState() {
    super.initState();
    slidingPuzzleController.reSet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onTapCallBack(int id) {
    slidingPuzzleController.tapSquare(
      slidingPuzzleController.getSquareIndex(id),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: slidingPuzzleController.width,
      height: slidingPuzzleController.width,
      child: ValueListenableBuilder(
        valueListenable: slidingPuzzleController.reSetTag,
        builder: (_, int value, _) {
          return ValueListenableBuilder(
            valueListenable: slidingPuzzleController.s,
            builder: (BuildContext context, int s, Widget? child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  child!,
                  if (s > 0)
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          color: Colors.black26,
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                  if (s > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: -72,
                      child: Center(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  if (s > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: -72,
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white54,
                              width: 0.72,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                          child: Text(
                            '$s',
                            style: TextStyle(
                              color: Color(0xfffffffa),
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 3,
                                  offset: Offset.zero,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...slidingPuzzleController.squaresTwoDList.map(
                  (dList) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...dList.map(
                        (square) => SlidingSquare(
                          width: slidingPuzzleController.squareWidth,
                          buildSquareWidget:
                              slidingPuzzleController.buildSquareWidget,
                          squareModel: square,
                          onTapCallBack: _onTapCallBack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
