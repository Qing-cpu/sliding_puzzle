import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/pages/cus_widget/time_progress.dart';
import 'package:sliding_puzzle/pages/speed_model/game_over_page.dart';
import 'package:sliding_puzzle/sliding_puzzle/sliding_puzzle.dart';

class SpeedModelPage extends StatefulWidget {
  const SpeedModelPage({super.key});

  @override
  State<SpeedModelPage> createState() => _SpeedModelPageState();
}

class _SpeedModelPageState extends State<SpeedModelPage> {
  int levelCount = 0;
  late List<String> levelSquareImageAssetList;
  int maxDTime = 25000;
  int ddMil = 7000;
  double x = 1.8;
  bool isCompleted = false;
  OverlayEntry? overlayEntry;
  int score = 0;

  void _next() {
    maxDTime = maxDTime - ddMil;
    if (x > 0.68) {
      ddMil = (ddMil / x) ~/ 1;
      x = x * 0.95;
    } else {
      ddMil = 100;
    }
    setState(() {
      isCompleted = false;
      levelCount++;
    });
  }

  void _onCompletion(int dMil) {
    setState(() {
      isCompleted = true;
      dMil = dMil;
      score += 123;
    });
    _next();
    // Future.then((_) {
    // });
  }

  void _onTimeOutFailure() {
    final overlay = Overlay.of(context);
    overlayEntry?.remove();
    overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => GameOverPage(
            newScore: score,
            oldScore: null,
            playAgain: () {
              overlayEntry?.remove();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SpeedModelPage()));
            },
            exit: () {
              overlayEntry?.remove();
              Navigator.of(context).pop();
            },
          ),
    );

    overlay.insert(overlayEntry!);
  }

  void _onBegin() {
    setState(() {
      isCompleted = false;
      dMil = maxDTime;
    });
  }

  int dMil = 0;

  @override
  void initState() {
    levelSquareImageAssetList = Levels.levelInfos.first.squareImageAssets;
    isCompleted = false;
    super.initState();
  }

  Widget buildNumWidget(int n) => Container(color: Color(0xFFFFD6C0), child: Center(child: Text('$n', style: TextStyle(fontSize: 27))));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(toolbarHeight: 44, title: Text('Speed Model')),
    body: Center(
      child: Column(
        children: [
          Text('Score: $score'),
          TimeProgress(
            key: Key('tp$levelCount'),
            dMil: dMil,
            width: 288,
            times: [Duration(milliseconds: maxDTime)],
            isCompleted: isCompleted,
            onTimeOutFailure: _onTimeOutFailure,
          ),
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
              key: Key('$levelCount'),
              isSpeedModel: levelCount != 0,
              isOnlyNum: true,
              reSetFlag: 0,
              width: 288,
              size: 3,
              bigImageAsset: '',
              imageAssetsList: levelSquareImageAssetList,
              onBegin: _onBegin,
              onCompletedCallback: _onCompletion,
              buildNumWidget: buildNumWidget,
            ),
          ),
        ],
      ),
    ),
  );
}
