import 'dart:ui';

import 'package:flutter/material.dart';

class AButton extends StatefulWidget {
  const AButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.fontSize,
    required this.text,
    required this.radius,
    this.sColor,
    this.fontColor = Colors.white,
  });

  final void Function() onTap;
  final double width;
  final double fontSize;
  final String text;
  final Radius radius;
  final Color fontColor;
  final Color? sColor;

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

  Widget get _text => Text(
    widget.text,
    style: TextStyle(
      fontSize: widget.fontSize,
      color: widget.fontColor,
      fontWeight: FontWeight.bold,

      shadows: [
        Shadow(
          color: Colors.black87,
          offset: Tween<Offset>(begin: Offset(-3, 6), end: Offset(3, 6)).chain(CurveTween(curve: Curves.easeInOut)).evaluate(_controller),
          blurRadius: 12,
        ),
        Shadow(color: Colors.black54, offset: Offset(3, 6), blurRadius: 24),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: widget.onTap,
    child: Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: widget.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.elliptical(widget.radius.x + 1, widget.radius.y + 1)),
                  ),
                  child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), child: Container(color: Colors.black12)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: widget.width,
                margin: EdgeInsets.all(1.3),
                padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(widget.radius),
                  color: Colors.white12,
                  border: Border.all(color: Colors.white54, width: 0.2),
                  boxShadow: [
                    if (widget.sColor != null)
                      BoxShadow(
                        color: widget.sColor!,
                        offset: Tween<Offset>(
                          begin: Offset(1.5, 1.5),
                          end: Offset(-1.5, -3),
                        ).chain(CurveTween(curve: Curves.easeInOut)).evaluate(_controller),
                        blurRadius: Tween<double>(begin: 32, end: 36).chain(CurveTween(curve: Curves.easeInOutBack)).evaluate(_controller),
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
                    child: _text,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
