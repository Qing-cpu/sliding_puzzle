import 'package:flutter/material.dart';

class FloatWidget extends StatefulWidget {
  const FloatWidget({super.key, this.child});

  final Widget? child;

  @override
  State<FloatWidget> createState() => _FloatWidgetState();
}

class _FloatWidgetState extends State<FloatWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final GlobalKey _globalKey = GlobalKey();

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

  Offset rxy = Offset(0, 0);

  void onTap(d) {
    final RenderBox? renderBox =
        _globalKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size(288, 288);
    Offset center = Offset(size.width / 2, size.height / 2);
    final l = d.localPosition;
    final df = center - l;
    setState(() {
      var newX = rxy.dx + df.dy / size.height / -10;
      var newY = rxy.dy + df.dx / size.width / 10;
      rxy = Offset(newX, newY);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      onDoubleTapDown: onTap,
      child: TweenAnimationBuilder(
        curve: Curves.easeOutBack,
        tween: Tween<Offset>(begin: Offset.zero, end: rxy),
        duration: Duration(seconds: 2),
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
                            Tween<double>(begin: 0.1, end: -0.1)
                                .chain(CurveTween(curve: Curves.easeInOutCirc))
                                .evaluate(_animationController),
                      )
                      ..rotateY(
                        value.dy +
                            Tween<double>(begin: -0.1, end: 0.1)
                                .chain(CurveTween(curve: Curves.easeInOut))
                                .evaluate(_animationController),
                      )
                      ..rotateZ(
                        Tween<double>(begin: -0.01, end: 0.01)
                            .chain(CurveTween(curve: Curves.easeInOut))
                            .evaluate(_animationController),
                      ),
                child: child,
              );
            },
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
