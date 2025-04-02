import 'package:flutter/material.dart';

class Move2 extends StatefulWidget {
  const Move2({super.key, required this.child});

  final Widget child;

  @override
  State<Move2> createState() => _Move2State();
}

class _Move2State extends State<Move2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0.005, 0.005), end: Offset(-0.005, -0.005))
              .chain(CurveTween(curve: Curves.easeInOutCubic))
              .animate(_controller),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
