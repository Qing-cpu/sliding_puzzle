import 'package:flutter/material.dart';

class Move extends StatefulWidget {
  const Move({super.key, required this.child});

  final Widget child;

  @override
  State<Move> createState() => _MoveState();
}

class _MoveState extends State<Move> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
          position: Tween<Offset>(begin: Offset(0.05, 0.05), end: Offset(-0.05, -0.05))
              .chain(CurveTween(curve: Curves.linear))
              .animate(_controller),
          child: child,
        );
      },
      child: Transform.scale(
          scale: 1.1,
          child: widget.child),
    );
  }
}
