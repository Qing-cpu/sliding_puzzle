import 'package:flutter/material.dart';

class AButton extends StatefulWidget {
  const AButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.fontSize,
    required this.text,
    required this.radius,
    this.backgroundColor = Colors.white,
    this.fontColor = Colors.white,
  });

  final void Function() onTap;
  final double width;
  final double fontSize;
  final String text;
  final Radius radius;
  final Color backgroundColor;
  final Color fontColor;

  @override
  State<AButton> createState() => _AButtonState();
}

class _AButtonState extends State<AButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: widget.onTap,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          alignment: Alignment.center,
          width: widget.width,
          padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(widget.radius),
            color: Colors.black26,
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor,
                offset: Tween<Offset>(
                  begin: Offset(-3, 2),
                  end: Offset(3, -2),
                ).chain(CurveTween(curve: Curves.easeInOut)).evaluate(_controller),
                blurRadius: Tween<double>(begin: 15.0, end: 10.0).evaluate(_controller),
              ),

            ],
          ),
          child: Transform.translate(
            offset: Tween<Offset>(
              begin: Offset(0.5, 1),
              end: Offset(-0.5, -1),
            ).chain(CurveTween(curve: Curves.easeInOutBack)).evaluate(_controller),
            child: Transform.rotate(
              angle: Tween<double>(begin: -0.1, end: 0.1).chain(CurveTween(curve: Curves.easeInOut)).evaluate(_controller),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.fontColor,
                  fontWeight: FontWeight.bold,

                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      offset: Tween<Offset>(
                        begin: Offset(-3, 6),
                        end: Offset(3, 6),
                      ).chain(CurveTween(curve: Curves.easeInOut)).evaluate(_controller),
                      blurRadius: 12,
                    ),
                    Shadow(color: Colors.black54, offset: Offset(3, 6), blurRadius: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
