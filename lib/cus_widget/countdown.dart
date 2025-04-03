import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/glass_card.dart';
import 'package:sliding_puzzle/tools/sound/sound_tools.dart';

class Countdown extends StatefulWidget {
  const Countdown({
    super.key,
    required this.count,
    required this.overCallback,
    required this.fontSize,
  });

  final int count;
  final double fontSize;

  final void Function() overCallback;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int count = widget.count;
  Timer? _timer;
  double end = 1;

  @override
  void initState() {
    super.initState();
    assert(count > 0);
    SoundTools.playCountdown();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (--count == 0) {
        end = 0;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    SoundTools.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      onEnd: () {
        widget.overCallback();
      },
      tween: Tween<double>(begin: 1, end: end),
      duration: const Duration(milliseconds: 320),
      curve: Curves.fastOutSlowIn,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GlassCard(
        radius: Radius.circular(17),
        child: Center(
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              '$count',
              style: TextStyle(
                color: Color(0xfffffffa),
                fontSize: 50,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
