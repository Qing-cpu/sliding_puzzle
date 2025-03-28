import 'package:flutter/material.dart';

class TimeProgress extends StatefulWidget {
  const TimeProgress({super.key, required this.times, required this.width, required this.timeProgressController});

  final List<Duration> times;
  final double width;
  final TimeProgressController timeProgressController;

  @override
  State<TimeProgress> createState() => _TimeProgressState();
}

class _TimeProgressState extends State<TimeProgress> {
  final height = 4.0;

  BoxDecoration get _decoration => BoxDecoration(color: Color(0xAB72FF77), borderRadius: BorderRadius.circular(3), boxShadow: []);

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

  void _statusListener(AnimationStatus state) {
    if (state == AnimationStatus.completed) {
      widget.timeProgressController.onEnd();
    }
  }

  @override
  void initState() {
    widget.timeProgressController.addStatusListener(_statusListener);
    widget.timeProgressController.duration = widget.times.first;
    super.initState();
  }

  @override
  void dispose() {
    widget.timeProgressController.removeStatusListener(_statusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(margin: const EdgeInsets.all(8), width: widget.width, height: height, decoration: bDecoration),
        Positioned(
          child: AnimatedBuilder(
            animation: widget.timeProgressController,
            builder: (BuildContext context, Widget? child) {
              return Container(
                margin: const EdgeInsets.all(8),
                height: height,
                width: Tween<double>(begin: 0, end: widget.width).evaluate(widget.timeProgressController),
                decoration: _decoration,
              );
            },
          ),
        ),
        ...widget.times.skip(1).map((t) {
          return Positioned(
            top: 8,
            left: t.inMilliseconds / widget.times.first.inMilliseconds * widget.width + 4,
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

class TimeProgressController extends AnimationController {
  TimeProgressController(this.onEnd, {required super.vsync});

  final VoidCallback onEnd;

  void stopProgress() => stop();

  void reSet() => value = 0;

  void start() => forward();
}
