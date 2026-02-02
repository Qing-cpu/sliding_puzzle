import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/countdown.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import '../../tools/sound/sound_tools.dart';

export 'models/sliding_puzzle_model.dart';
export 'models/square_model.dart';

class SlidingPuzzle extends StatefulWidget {
  const SlidingPuzzle({super.key, required this.slidingPuzzleController, required this.width, required this.height});

  final SlidingPuzzleController slidingPuzzleController;

  final double width;
  final double height;

  @override
  State<SlidingPuzzle> createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> with SingleTickerProviderStateMixin {
  SlidingPuzzleController get slidingPuzzleController => widget.slidingPuzzleController;
  OverlayEntry? _overlayEntry;
  double fontSize = 50;

  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 80));

  @override
  void initState() {
    super.initState();
    slidingPuzzleController.reSet();
    slidingPuzzleController.s.addListener(_handleReSetTagChange);
    if (slidingPuzzleController.s.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCountdown(fontSize));
    }

    _animationController.addStatusListener(_animationStatusListener);
  }

  _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onEnd();
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
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.dispose();
    super.dispose();
  }

  void _handleReSetTagChange() {
    if (slidingPuzzleController.s.value == 0) {
      _removeOverlayEntry();
    }
    if (slidingPuzzleController.s.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCountdown(fontSize));
    }
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

  void _onTapSquare(SquareModel square) {
    if (slidingPuzzleController.needFind.value) {
      final targetSquares = widget.slidingPuzzleController.getFind(square.id);
      setState(() {
        targetSquares.needShow = ValueKey(targetSquares.id);
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          setState(() {
            targetSquares.needShow = null;
          });
        });
      });
      slidingPuzzleController.needFind.value = false;
      return;
    }
    if (_animationController.isAnimating || square.translateOffset == null) {
      SoundTools.playDeep();
      return;
    }
    widget.slidingPuzzleController.playSquareAni(square.id);
    SoundTools.playPop2();
    _animationController.value = 0;
    _animationController.forward();
  }

  void _onEnd() {
    widget.slidingPuzzleController.endPlay();
    setState(() => _animationController.value = 0);
  }

  Duration duration = const Duration(milliseconds: 0);

  Offset getOffset(SquareModel square) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: square.needMove == true ? square.translateOffset : Offset.zero,
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).evaluate(_animationController);
  }

  Widget buildPuzzleWidget(SquareModel square) => GestureDetector(
    key: square.needShow,
    onTapDown: (_) => _onTapSquare(square),
    child:
        square.isNullSquare
            ? SizedBox(width: slidingPuzzleController.squareWidth, height: slidingPuzzleController.squareWidth)
            : AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) => Transform.translate(offset: getOffset(square), child: child),
              child: AnimatedContainer(
                height: slidingPuzzleController.squareWidth,
                width: slidingPuzzleController.squareWidth,
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOut,
                child: slidingPuzzleController.buildSquareWidget(num: square.id + 1, isOk: square.squareIndexIsProper),
              ),
            ),
  );

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
                        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8)),
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
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...slidingPuzzleController.squaresTwoDList.map(
                    (dList) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [...dList.map(buildPuzzleWidget)]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
