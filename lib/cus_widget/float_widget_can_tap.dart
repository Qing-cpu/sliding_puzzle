import 'dart:async';

import 'package:flutter/material.dart';

class FloatWidgetCanTap extends StatefulWidget {
  const FloatWidgetCanTap({
    super.key,
    this.child,
    this.rotateZ,
    this.rotateX,
    this.rotateY,
  });

  final Widget? child;

  final Tween<double>? rotateX;
  final Tween<double>? rotateY;
  final Tween<double>? rotateZ;

  @override
  State<FloatWidgetCanTap> createState() => _FloatWidgetCanTapState();
}

class _FloatWidgetCanTapState extends State<FloatWidgetCanTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final GlobalKey _globalKey = GlobalKey();

  Offset rxy = Offset.zero;

  Timer? _timer;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this)
          ..duration = Duration(seconds: 6)
          ..repeat(reverse: true);
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      setState(() => rxy = Offset.zero);
    });
    super.initState();
  }

  void onTap(d) {
    final RenderBox? renderBox =
        _globalKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size(288, 288);
    Offset center = Offset(size.width / 2, size.height / 2);
    final l = d.localPosition;
    final df = center - l;
    var newX = rxy.dx + df.dy / size.height / -2;
    var newY = rxy.dy + df.dx / size.width / 2;
    if (newY > 1 || newY < -1) {
      newY = rxy.dy;
    }
    if (newX > 1 || newX < -1) {
      newX = rxy.dx;
    }
    setState(() => rxy = Offset(newX, newY));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      onTapDown: onTap,
      child: TweenAnimationBuilder(
        curve: Curves.easeOutBack,
        tween: Tween<Offset>(begin: Offset.zero, end: rxy),
        duration:
            rxy == Offset.zero ? Duration(seconds: 4) : Duration(seconds: 2),
        builder: (BuildContext context, Offset value, Widget? child) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(
                        value.dx +
                            (widget.rotateX ??
                                    Tween<double>(begin: 0.1, end: -0.1))
                                .chain(CurveTween(curve: Curves.easeInOutCirc))
                                .evaluate(_animationController),
                      )
                      ..rotateY(
                        value.dy +
                            (widget.rotateY ??
                                    Tween<double>(begin: -0.1, end: 0.1))
                                .chain(CurveTween(curve: Curves.easeInOut))
                                .evaluate(_animationController),
                      )
                      ..rotateZ(
                        (widget.rotateZ ??
                                Tween<double>(begin: -0.03, end: 0.03))
                            .chain(CurveTween(curve: Curves.easeInOut))
                            .evaluate(_animationController),
                      ),
                child: child,
              );
            },
            child: widget.child,
          );
        },
      ),
    );
  }
}
