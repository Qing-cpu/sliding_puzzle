import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/countdown.dart';
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
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    slidingPuzzleController.reSet();
    slidingPuzzleController.s.addListener(_handleReSetTagChange);
    if (slidingPuzzleController.s.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCountdown());
    }
  }

  void _removeOverlayEntry() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _removeOverlayEntry();
    slidingPuzzleController.s.removeListener(_handleReSetTagChange);
    super.dispose();
  }

  void _handleReSetTagChange() {
    if (slidingPuzzleController.s.value == 0) {
      _removeOverlayEntry();
    }
    if (slidingPuzzleController.s.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCountdown());
    }
  }

  _onTapCallBack(int id) {
    slidingPuzzleController.tapSquare(
      slidingPuzzleController.getSquareIndex(id),
    );
    setState(() {});
  }

  _showCountdown() {
    _removeOverlayEntry();
    if (slidingPuzzleController.s.value > 0) {
      final overlay = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder:
            (BuildContext context) => Container(
              alignment: Alignment(0,-0.19),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Countdown(
                  count: slidingPuzzleController.s.value,
                  overCallback: () {
                    _removeOverlayEntry();
                    slidingPuzzleController.s.value = 0;
                    slidingPuzzleController.onStart();
                  },
                ),
              ),
            ),
      );
      overlay.insert(_overlayEntry!);
    }
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
