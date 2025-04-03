import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart' as gs;
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/cus_widget/glass_card.dart';
import 'package:sliding_puzzle/tools/tools.dart';
import 'package:sliding_puzzle/pages/speed_model/game_over_page.dart';

class SpeedModelPage extends StatefulWidget {
  const SpeedModelPage({super.key});

  @override
  State<SpeedModelPage> createState() => _SpeedModelPageState();
}

class _SpeedModelPageState extends State<SpeedModelPage>
    with SingleTickerProviderStateMixin {
  int levelCount = 0;
  int? oldScore;
  int mil = 23000;
  OverlayEntry? overlayEntry;
  int score = 0;

  late final _timeProgressController = TimeProgressController(
    _onGameOver,
    vsync: this,
  );
  late final _slidingPuzzleController = SlidingPuzzleController(
    onStart: _timeProgressController.start,
    width: 288,
    buildSquareWidget: buildNumWidget,
    onCompletedCallback: _onCompletion,
    size: 3,
  );

  @override
  void initState() {
    DBTools.getSpeedModelScore().then((v) => oldScore = v);
    super.initState();
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry = null;
    _slidingPuzzleController.dispose();
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
    _slidingPuzzleController.reSet();
  }

  void _onCompletion() {
    // 避免 超时后 调用 _next()
    if (_timeProgressController.status == AnimationStatus.completed) {
      return;
    }
    setState(
      () =>
          score +=
              (1230 * ++levelCount * (1 - _timeProgressController.value))
                  .toInt(),
    );
    _next();
  }

  void _onGameOver() {
    () async {
      await gs.Leaderboards.submitScore(
        score: gs.Score(
          androidLeaderboardID: '',
          iOSLeaderboardID: 'speed_model',
          value: score,
        ),
      );
    }();
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SpeedModelPage(),
                ),
              );
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
    duration: Duration(seconds: 1),
    tween: ColorTween(
      begin: Color(0xffffffff),
      end: _colors[levelCount % _colors.length],
    ),
    builder:
        (BuildContext context, Color? value, Widget? child) =>
            Container(color: value, alignment: Alignment.center, child: child),
    child: Text(
      '${n + 1}',
      textAlign: TextAlign.center,
      style: TextStyle(
        shadows: [
          Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 12),
        ],
        fontWeight: FontWeight.bold,
        fontSize: 52,
        color: Colors.white,
      ),
    ),
  );

  int get _hour => DateTime.now().hour;

  // int get _hour => 1;

  int get l {
    if (_hour > 19) {
      return 3;
    } else if (_hour > 11) {
      return 2;
    } else {
      return 1;
    }
  }

  List<Color> get _colors =>
      _hour < 19
          ? [
            Color(0x3D12B639),
            Color(0x3D009513),
            Color(0x3D008029),
            Color(0x3D006A51),
            Color(0x3D005A80),
            Color(0x3DD69300),
            Color(0x3DD67200),
            Color(0x3DEC7513),
            Color(0x3DFF0365),
            Color(0x3DFF0365),
            Color(0x3DBC0000),
            Color(0x3D470068),
            Color(0x3D27004C),
            Color(0x3D6E6E6E),
            Color(0x3D000000),
          ]
          : [
            Color(0x3DFF0365),
            Color(0x66672B00),
            Color(0x1B00FFEE),
            Color(0x3C00FFEA),
            Color(0x52FF00C2),
            Color(0x529900FF),
            Color(0x3DFF004D),
            Color(0x520800FF),
            Color(0x3D005A80),
            Color(0x3DD69300),
            Color(0x3DD67200),
            Color(0x3DEC7513),
            Color(0x3DFF0365),
            Color(0x3DFF0365),
            Color(0x3DBC0000),
            Color(0x3D470068),
            Color(0x3D27004C),
            Color(0x3D6E6E6E),
            Color(0xFF000000),
          ];

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: true,
    onPopInvokedWithResult: (_, _) {
      _slidingPuzzleController.s.value = 0;
    },
    child: Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg$l.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top,
                ),
                decoration: BoxDecoration(
                  color: _hour < 19 ? Colors.white70 : Colors.black12,
                ),
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
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 3,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                              size: 32,
                            ),
                          ),
                          Score(
                            score: score,
                            textStyle: TextStyle(
                              fontSize: 42 + levelCount * 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent.shade200,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(2, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0,
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.arrow_back,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 3,
                                    offset: Offset(1.5, 1.5),
                                  ),
                                ],
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

              Expanded(child: SizedBox(height: 1)),
              GlassCard(
                colorB1: _hour < 19 ? Colors.white12 : Color(0x00000000),
                colorT1: _hour < 19 ? Colors.white12 : Color(0x00000000),
                radius: Radius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(12), // 内边距
                  child: SlidingPuzzle(
                    slidingPuzzleController: _slidingPuzzleController,
                  ),
                ),
              ),
              Expanded(child: SizedBox(height: 1)),
            ],
          ),
        ],
      ),
    ),
  );
}

class ShadowTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  ShadowTextPainter({required this.text, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle.copyWith(
          color: Colors.black87, // 阴影颜色
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // 先绘制阴影
    canvas.save();
    canvas.translate(4, 4); // 偏移阴影位置
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();

    // 再绘制正常文字
    textPainter.text = TextSpan(text: text, style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShadowTextWidget extends StatelessWidget {
  const ShadowTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 50), // 设置绘制区域大小
      painter: ShadowTextPainter(
        text: 'Custom Shadow',
        textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
