import 'package:flutter/material.dart';
import 'models/square_model.dart';

class SlidingSquare extends StatefulWidget {
  const SlidingSquare({super.key, required this.squareModel, required this.onTapCallBack, required this.squareWidth, this.buildNumWidget});

  final double squareWidth;
  final Widget Function(int)? buildNumWidget;

  final void Function(int) onTapCallBack;
  final SquareModel squareModel;

  @override
  State<SlidingSquare> createState() => _SlidingSquareState();
}

class _SlidingSquareState extends State<SlidingSquare> with SingleTickerProviderStateMixin {
  static final GlobalKey _globalKey = GlobalKey();

  late final AnimationController _animationController;
  late Animation<Offset> _animation;
  Offset _translateOffset = Offset.zero;
  late final _squareWidth = widget.squareWidth;

  void upNullWidgetOffset() {
    if (SquareModel.nullGridWidgetOffset == null) {
      final RenderBox? renderObject = _globalKey.currentContext?.findAncestorRenderObjectOfType() as RenderBox?;
      SquareModel.nullGridWidgetOffset = renderObject?.localToGlobal(Offset.zero);
    }
  }

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
    if (SquareModel.hasMoving || widget.squareModel.canMove == false) {
      return;
    }

    // 判断 空白格子屏幕坐标是否为空
    if (SquareModel.nullGridWidgetOffset == null) {
      // 获取空白格子屏幕坐标
      upNullWidgetOffset();
    }
    final selfOffset = d.globalPosition - d.localPosition;
    _translateOffset = SquareModel.nullGridWidgetOffset! - selfOffset;
    SquareModel.nullGridWidgetOffset = selfOffset;
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: _translateOffset,
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(_animationController)..addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _animationController.stop();
      }
    });
    SquareModel.hasMoving = true;
    _animationController.forward();
  }

  Widget _buildAnimatedChild() {
    if (SquareModel.nullGridWidgetOffset == null && widget.squareModel.isNullSquare) {
      return Opacity(
        opacity: 0,
        key: _globalKey,
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
        child: SizedBox(height: _squareWidth, width: _squareWidth, child: _buildAnimatedChild()),
      ),
    );
  }
}
