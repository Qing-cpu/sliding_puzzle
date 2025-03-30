import 'dart:ui';

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
  OverlayEntry? overlayEntry;
  int score = 0;

  late TimeProgressController _timeProgressController;

  @override
  void initState() {
    _timeProgressController = TimeProgressController(_onGameOver, vsync: this);
    DBTools.getSpeedModelScore().then((v) => oldScore = v);
    super.initState();
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry = null;
    _timeProgressController.dispose();
    super.dispose();
  }

  void _next() {
    _timeProgressController.duration = Duration(milliseconds: mil);
    _timeProgressController.value = 0;
    if (mil > 17000) {
      mil -= 1600;
    } else if (mil > 12000) {
      mil -= 800;
    } else if (mil > 9000) {
      mil -= 400;
    } else if (mil > 6000) {
      mil -= 100;
    } else {
      mil -= 10;
    }
  }

  void _onCompletion() {
    // 避免 超时后 调用 _next()
    if (_timeProgressController.status == AnimationStatus.completed) {
      return;
    }
    setState(() => score += (1230 * ++levelCount * (1 - _timeProgressController.value)).toInt());
    _next();
  }

  void _onGameOver() {
    if (score > (oldScore ?? 0)) {
      DBTools.setSpeedModelScore(score);
    }
    final overlay = Overlay.of(context);
    overlayEntry?.remove();
    overlayEntry = null;
    overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => GameOverPage(
            newScore: score,
            oldScore: oldScore,
            playAgain: () {
              overlayEntry?.remove();
              overlayEntry = null;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SpeedModelPage()));
            },
            exit: () {
              overlayEntry?.remove();
              overlayEntry = null;
              Navigator.of(context).pop();
            },
          ),
    );
    overlay.insert(overlayEntry!);
  }

  Widget buildNumWidget(int n) => TweenAnimationBuilder(
    key: Key('$n'),
    duration: Duration(seconds: 1),
    tween: ColorTween(begin: Color(0xffffffff), end: _colors[levelCount % _colors.length]),
    builder: (BuildContext context, Color? value, Widget? child) => Container(color: value, child: child),
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
    backgroundColor: Color(0x00000000),
    body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg3.png'), fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            decoration: BoxDecoration(color: Colors.white70),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xFFF8F3F3),
                          shadows: [Shadow(color: Colors.black54, blurRadius: 3, offset: Offset(1.5, 1.5))],
                          size: 32,
                        ),
                      ),
                      Score(
                        score: score,
                        textStyle: TextStyle(
                          fontSize: 42 + levelCount * 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent.shade200,
                          shadows: [Shadow(color: Colors.black54, offset: Offset(2, 4), blurRadius: 10)],
                        ),
                      ),
                      Opacity(
                        opacity: 0,
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.arrow_back,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 3, offset: Offset(1.5, 1.5))],
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TimeProgress(
                    key: Key('tp$levelCount'),
                    width: 288,
                    times: [Duration(milliseconds: mil)],
                    timeProgressController: _timeProgressController,
                  ),
                ],
              ),
            ),
          ),

          Expanded(child: SizedBox(height:1)),
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
              reSetTag: levelCount,
              width: 288,
              size: 3,
              imageAssetsList: Levels.levelInfos.first.squareImageAssets,
              onCompletedCallback: _onCompletion,
              buildNumWidget: buildNumWidget,
              seconds: 3,
              onStart: () => _timeProgressController.start(),
            ),
          ),
          Expanded(child: SizedBox(  height: 1)),
        ],
      ),
    ),
  );
}

const List<Color> _colors = [
  Color(0xFF00C3BD),
  Color(0xFFBC0000),
  Color(0xFF4FDA70),
  Color(0xFFC30074),
  Color(0xFF8DCF26),
  Color(0xFFD8710E),
  Color(0xFFC38400),
  Color(0xFFE1D815),
];
