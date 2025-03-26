import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/db_tools.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/pages/cus_widget/score.dart';
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
  int? oldScore;
  late List<String> levelSquareImageAssetList;
  int maxDTime = 23000;
  int ddMil = 1000;
  bool isCompleted = false;
  OverlayEntry? overlayEntry;
  int score = 0;

  @override
  void initState() {
    levelSquareImageAssetList = Levels.levelInfos.first.squareImageAssets;
    isCompleted = false;
    oldScore = DBTools.getSpeedModelScore();
    super.initState();
  }

  void _next() {
    dMil = 0;
    maxDTime = maxDTime - ddMil;
    if (maxDTime < 15000) {
      ddMil = 400;
    }
    if (maxDTime < 10000) {
      ddMil = 100;
    }
    if (maxDTime < 9000) {
      ddMil = 50;
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
  }

  void _onGameOver() {
    if (score > (oldScore ?? 0)) {
      DBTools.setSpeedModelScore(score);
    }
    final overlay = Overlay.of(context);
    overlayEntry?.remove();
    overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => GameOverPage(
            newScore: score,
            oldScore: oldScore,
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

  final List<Color> colors = [
    Color(0xFFC30074),

  ];

  Widget buildNumWidget(int n) =>

      Container(color: Color(0xFF00C3BD), child: Center(child:
      Text('$n', style: TextStyle(
        shadows: [
          Shadow(
            color: Colors.black87,
            offset: Offset(2, 4),
            blurRadius: 12
          )
        ],
        fontWeight: FontWeight.bold,
          fontSize: 52,color: Colors.white))));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(toolbarHeight: 44, title: Text('Speed Model')),
    body: Center(
      child: Column(
        children: [
          Expanded(child: Center(child: Score(score: score, fontSize: 48))),
          TimeProgress(
            key: Key('tp$levelCount'),
            dMil: dMil,
            width: 288,
            times: [Duration(milliseconds: maxDTime)],
            isCompleted: isCompleted,
            onTimeOutFailure: _onGameOver,
          ),
          SizedBox(height: 8,),
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
              isSpeedModel: false,
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
          Expanded(child: SizedBox(width: 1,height: 20,)),
        ],
      ),
    ),
  );
}
