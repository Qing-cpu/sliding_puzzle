
import 'package:flutter/material.dart';

class TimeProgress extends StatelessWidget {
  const TimeProgress({
    super.key,
    required this.times,
    required this.dMil,
    required this.width,
    required this.isCompleted,
    required this.onTimeOutFailure,
  });

  final List<Duration> times;
  final int dMil;
  final double width;
  final bool isCompleted;

  final VoidCallback onTimeOutFailure;

  final height = 4.0;

  BoxDecoration get decoration => BoxDecoration(color: Color(0xAB72FF77), borderRadius: BorderRadius.circular(3), boxShadow: []);

  BoxDecoration get bDecoration => BoxDecoration(
    color: Colors.black12,
    borderRadius: BorderRadius.circular(2),
    boxShadow: [
      BoxShadow(
        color: Colors.black26, // 深棕色阴影
        blurRadius: 3, // 阴影模糊半径
        offset: Offset(2, 2), // 阴影偏移
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(margin: const EdgeInsets.all(8), width: width, height: height, decoration: bDecoration),
        Positioned(
          child:
          isCompleted
              ? Container(
            margin: const EdgeInsets.all(8),
            decoration: decoration,
            height: height,
            width: dMil / times.first.inMilliseconds * width,
          )
              : TweenAnimationBuilder(
            key: key,
            tween: Tween<double>(begin: 1.0, end: dMil.toDouble()),
            duration: times.first,
            onEnd: onTimeOutFailure,
            builder: (BuildContext context, double value, Widget? child) {
              return Container(
                margin: const EdgeInsets.all(8),
                height: height,
                width: dMil == 0 ? 0 : value / dMil * width,
                decoration: decoration,
              );
            },
          ),
        ),
        ...times.skip(1).map((t) {
          return Positioned(
            top: 8,
            left: t.inMilliseconds / times.first.inMilliseconds * width + 4,
            child: _Point(color: Colors.black38, size: 4),
          );
        }),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size / 4,
      height: size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(size))),
    );
  }
}
