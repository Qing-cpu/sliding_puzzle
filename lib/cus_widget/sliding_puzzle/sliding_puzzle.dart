import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/countdown.dart';
import 'models/sliding_puzzle_model.dart';
import 'sliding_square.dart';

export 'models/sliding_puzzle_model.dart';
export 'models/square_model.dart';
export 'sliding_square.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({
    super.key,
    required this.slidingPuzzleController,
    required this.width,
    required this.height,
  });

  final SlidingPuzzleController slidingPuzzleController;

  final double width;
  final double height;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  SlidingPuzzleController get slidingPuzzleController =>
      widget.slidingPuzzleController;
  OverlayEntry? _overlayEntry;
  double fontSize = 50;

  @override
  void initState() {
    super.initState();
    slidingPuzzleController.reSet();
    slidingPuzzleController.s.addListener(_handleReSetTagChange);
    if (slidingPuzzleController.s.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showCountdown(fontSize),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).size.width > 600) {
      fontSize = 100;
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
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showCountdown(fontSize),
      );
    }
  }

  _onTapCallBack(int id) {
    slidingPuzzleController.tapSquare(
      slidingPuzzleController.getSquareIndex(id),
    );
    setState(() {});
  }

  _showCountdown(double fontSize) {
    _removeOverlayEntry();
    if (slidingPuzzleController.s.value > 0) {
      final overlay = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder:
            (BuildContext context) => Container(
              alignment: Alignment(0, -0.19),
              child: LayoutBuilder(
                builder: (context, c) {
                  double size = 80;
                  if (c.maxWidth > 600) {
                    size = 160;
                  }
                  return SizedBox(
                    width: size,
                    height: size,
                    child: Countdown(
                      fontSize: fontSize,
                      count: slidingPuzzleController.s.value,
                      overCallback: () {
                        _removeOverlayEntry();
                        slidingPuzzleController.s.value = 0;
                        slidingPuzzleController.onStart();
                      },
                    ),
                  );
                },
              ),
            ),
      );
      overlay.insert(_overlayEntry!);
    }
  }

  @override
  Widget build(BuildContext context) {
    slidingPuzzleController.width = widget.width;
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      duration: Duration(milliseconds: 320),
      curve: Curves.easeInOut,
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
