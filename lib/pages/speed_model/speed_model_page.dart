import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/tools/tools.dart';
import 'package:sliding_puzzle/pages/speed_model/game_over_page.dart';

class SpeedModelPage extends StatefulWidget {
  const SpeedModelPage({super.key});

  @override
  State<SpeedModelPage> createState() => _SpeedModelPageState();
}

class _SpeedModelPageState extends State<SpeedModelPage> with SingleTickerProviderStateMixin {
  int levelCount = 0;
  int? oldScore;
  int mil = 23000;
  double d = 0.95;
  OverlayEntry? overlayEntry;
  int score = 0;

  late TimeProgressController _timeProgressController;

  @override
  void initState() {
    _timeProgressController = TimeProgressController(_onGameOver, vsync: this);
    oldScore = DBTools.getSpeedModelScore();
    super.initState();
  }

  @override
  void dispose() {
    _timeProgressController.dispose();
    super.dispose();
  }

  void _next() {
    _timeProgressController.duration = Duration(milliseconds: mil);
    if (d > 17000) {
      d -= 2000;
    } else if (d > 12000) {
      d -= 1000;
    } else if (d > 9000) {
      d -= 500;
    } else if (d > 6000) {
      d -= 100;
    } else {
      d -= 10;
    }
    setState(() => levelCount++);
  }

  void _onCompletion() {
    setState(() => score += 123);
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

  final List<Color> colors = [Color(0xFFC30074)];

  Widget buildNumWidget(int n) => Container(
    color: Color(0xFF00C3BD),
    child: Center(
      child: Text(
        '$n',
        style: TextStyle(
          shadows: [Shadow(color: Colors.black87, offset: Offset(2, 4), blurRadius: 12)],
          fontWeight: FontWeight.bold,
          fontSize: 52,
          color: Colors.white,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(toolbarHeight: 44, title: Text('Speed Model')),
    body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg3.png'), fit: BoxFit.cover)),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Score(
                  score: score,
                  textStyle: TextStyle(
                    fontSize: 42 + levelCount * 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent.shade200,
                    shadows: [Shadow(color: Colors.black54, offset: Offset(2, 4), blurRadius: 10)],
                  ),
                ),
              ),
            ),
            TimeProgress(
              key: Key('tp$levelCount'),
              width: 288,
              times: [Duration(milliseconds: mil)],
              timeProgressController: _timeProgressController,
            ),
            SizedBox(height: 8),
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
                width: 288,
                size: 3,
                imageAssetsList: Levels.levelInfos.first.squareImageAssets,
                onCompletedCallback: _onCompletion,
                buildNumWidget: buildNumWidget,
                seconds: 3,
                onStart: () => _timeProgressController.start(),
              ),
            ),
            Expanded(child: SizedBox(width: 1, height: 20)),
          ],
        ),
      ),
    ),
  );
}
