import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';

import '../sliding_puzzle/sliding_puzzle.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.levelInfo, required this.levelData});

  final LevelInfo levelInfo;
  final LevelData? levelData;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final _levelInfo = widget.levelInfo;
  bool isBegin = false;
  bool isCompleted = false;
  final _slidingPuzzleWidth = 288.0;
  late LevelData? _data = widget.levelData;

  _onBegin() {
    setState(() {
      isBegin = true;
      isCompleted = false;
      // dMil = _levelInfo.starCountTimes.first.inMilliseconds;
      dMil = _levelInfo.starCountTimes.first.inMilliseconds;
    });
  }

  _onCompletedCallback(LevelData data) {
    _data = data.newOrOld(_data);
    setState(() {
      isCompleted = true;
      dMil = data.timeMil;
    });
    // Navigator.pop(context, _data);
  }

  int dMil = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: _levelInfo.imageAssets,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.black54, width: 2),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x45000000),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(5, 5), // 偏移量 (x, y)
                        ),
                        BoxShadow(
                          color: Color(0x45000000),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(3, 3), // 偏移量 (x, y)
                        ),
                      ],
                    ),

                    child: Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Image.asset(
                        width: 100,
                        height: 100,
                        _levelInfo.imageAssets,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TimeProgress(
              dMil: dMil,
              times: _levelInfo.starCountTimes,
              isCompleted: isCompleted,
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12), // 内边距
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16), // 圆角
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // 深棕色阴影
                    blurRadius: 12, // 阴影模糊半径
                    offset: Offset(4, 6), // 阴影偏移
                  ),
                ],
              ),
              child: SlidingPuzzle(
                levelInfo: _levelInfo,
                width: _slidingPuzzleWidth,
                onBegin: _onBegin,
                onCompletedCallback: _onCompletedCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeProgress extends StatelessWidget {
  const TimeProgress({
    super.key,
    required this.times,
    required this.dMil,
    required this.isCompleted,
  });

  final List<Duration> times;
  final int dMil;
  final bool isCompleted;

  final height = 4.0;
  final width = 280.0;

  BoxDecoration get decoration => BoxDecoration(
    color: Color(0xAB72FF77),
    borderRadius: BorderRadius.circular(3),
    boxShadow: [],
  );

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
        Container(
          margin: const EdgeInsets.all(8),
          width: width,
          height: height,
          decoration: bDecoration,
        ),
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
                    tween: Tween<double>(begin: 1.0, end: dMil.toDouble()),
                    duration: times.first,
                    builder: (
                      BuildContext context,
                      double value,
                      Widget? child,
                    ) {
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
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(size)),
      ),
    );
  }
}
