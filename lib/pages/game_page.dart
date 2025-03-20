import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/db_tools.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/pages/cus_widget/photo_frame.dart';

import '../sliding_puzzle/sliding_puzzle.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.levelInfoIndex});

  final int levelInfoIndex;

  // final LevelData? levelData;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final _levelInfo = Levels.levelInfos[widget.levelInfoIndex];
  bool isBegin = false;
  bool isCompleted = false;
  int reSetFlag = 1;
  int dMil = 0;
  final _slidingPuzzleWidth = 288.0;
  final DBTools dbTools = DBTools();

  LevelData? get _data => DBTools.getLevelDataByLeveId(_levelInfo.id);

  _onBegin() {
    setState(() {
      isBegin = true;
      isCompleted = false;
      // dMil = _levelInfo.starCountTimes.first.inMilliseconds;
      dMil = _levelInfo.starCountTimes.first.inMilliseconds;
    });
  }

  void showGameCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('完成！'),
          content: Text('  用时: ${Duration(milliseconds: dMil).inSeconds}s'),
          actions: [
            TextButton(onPressed: _playAgain, child: Text('Play Again')),
            TextButton(onPressed: _next, child: Text('Next!')),
          ],
        );
      },
    );
  }

  void _back() {
    Navigator.pop(context);
    // Navigator.pop(context, _data);
  }

  void _next() {
    Navigator.pop(context);
    Navigator.pushReplacement(
       context,
      CupertinoPageRoute(
        builder:
            (BuildContext context) =>
                GamePage(levelInfoIndex: widget.levelInfoIndex + 1),
      ),
    );
  }

  void _playAgain() {
    Navigator.of(context).pop();
    reSetFlag++;
    _onBegin();
  }

  _onCompletedCallback(LevelData newData) {
    setState(() {
      isCompleted = true;
      dMil = newData.timeMil;
    });
    DBTools.setLevelDataByLeveData(newData.newOrOld(_data));

    showGameCompletedDialog();
  }

  final box8H = SizedBox(height: 8);
  final box16H = SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _back();
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            box16H,
            Hero(
              tag: _levelInfo.id,
              child: PhotoFrame(image: Image.asset(_levelInfo.imageAssets)),
            ),
            Expanded(child: SizedBox()),
            TimeProgress(
              key: Key('$reSetFlag'),
              dMil: dMil,
              width: 288,
              times: _levelInfo.starCountTimes,
              isCompleted: isCompleted,
            ),
            box8H,
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
                reSetFlag: reSetFlag,
                levelInfoIndex: widget.levelInfoIndex,
                width: _slidingPuzzleWidth,
                onBegin: _onBegin,
                onCompletedCallback: _onCompletedCallback,
              ),
            ),
            Expanded(child: SizedBox()),
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
    required this.width,
    required this.isCompleted,
  });

  final List<Duration> times;
  final int dMil;
  final double width;
  final bool isCompleted;

  final height = 4.0;

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
                    key: key,
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
