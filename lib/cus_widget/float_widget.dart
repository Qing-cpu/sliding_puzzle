import 'package:flutter/material.dart';

class FloatWidget extends StatefulWidget {
  const FloatWidget({
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
  State<FloatWidget> createState() => _FloatWidgetState();
}

class _FloatWidgetState extends State<FloatWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this)
          ..duration = Duration(seconds: 6)
          ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(
                  (widget.rotateX ?? Tween<double>(begin: 0.1, end: -0.1))
                      .chain(CurveTween(curve: Curves.easeInOutCirc))
                      .evaluate(_animationController),
                )
                ..rotateY(
                  (widget.rotateY ?? Tween<double>(begin: -0.1, end: 0.1))
                      .chain(CurveTween(curve: Curves.easeInOut))
                      .evaluate(_animationController),
                )
                ..rotateZ(
                  (widget.rotateZ ?? Tween<double>(begin: -0.03, end: 0.03))
                      .chain(CurveTween(curve: Curves.easeInOut))
                      .evaluate(_animationController),
                ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// void onTap(d) {
//   final RenderBox? renderBox =
//       _globalKey.currentContext?.findRenderObject() as RenderBox?;
//   final size = renderBox?.size ?? Size(288, 288);
//   Offset center = Offset(size.width / 2, size.height / 2);
//   final l = d.localPosition;
//   final df = center - l;
//   setState(() {
//     var newX = rxy.dx + df.dy / size.height / -10;
//     var newY = rxy.dy + df.dx / size.width / 10;
//     rxy = Offset(newX, newY);
//   });
// }
