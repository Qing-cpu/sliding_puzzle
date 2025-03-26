import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  const Score({super.key, required this.score, required this.fontSize});

  final int score;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: Key('$score'),
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutBack,
      builder: (BuildContext context, double value, Widget? child) =>Transform.scale(
          scale: value,
          child: child!),
      child: Text('$score',style: TextStyle(fontSize: fontSize),),
    );
  }
}
