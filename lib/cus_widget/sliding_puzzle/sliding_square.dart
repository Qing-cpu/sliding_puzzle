import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'models/square_model.dart';

class SlidingSquare extends StatefulWidget {
  const SlidingSquare({super.key, required this.squareModel, required this.onTapCallBack, this.buildNumWidget, required this.width});

  final Widget Function(int)? buildNumWidget;

  final void Function(int) onTapCallBack;
  final SquareModel squareModel;
  final double width;

  @override
  State<SlidingSquare> createState() => _SlidingSquareState();
}

class _SlidingSquareState extends State<SlidingSquare> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<Offset> _animation;

  void _statusListener(state) {
    if (state == AnimationStatus.completed) {
      SquareModel.hasMoving = false;
      _animationController.value = 0;
      widget.onTapCallBack(widget.squareModel.id);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this)
          ..duration = const Duration(milliseconds: 80)
          ..addStatusListener(_statusListener);
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_statusListener);
    _animationController.dispose();
    super.dispose();
  }

  _onTapDown(d) {
    if (SquareModel.hasMoving || widget.squareModel.translateOffset == null) {
      return;
    }

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.squareModel.translateOffset,
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(_animationController)..addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _animationController.stop();
      }
    });
    SquareModel.hasMoving = true;
    _animationController.forward();
  }

  Widget _buildAnimatedChild() {
    if (widget.squareModel.isNullSquare) {
      return Opacity(
        opacity: 0,
        child: widget.buildNumWidget?.call(widget.squareModel.id + 1) ?? Image.asset(widget.squareModel.squareImageAsset),
      );
    } else {
      return Opacity(
        opacity: widget.squareModel.isNullSquare ? 0 : 1,
        child: Container(
          color: Colors.white,
          child: widget.buildNumWidget?.call(widget.squareModel.id + 1) ?? Image.asset(widget.squareModel.squareImageAsset),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.squareModel.isNullSquare ? null : _onTapDown,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) => Transform.translate(offset: _animation.value, child: child),
        child: SizedBox(height: widget.width, width: widget.width, child: _buildAnimatedChild()),
      ),
    );
  }
}
