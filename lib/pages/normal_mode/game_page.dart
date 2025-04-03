import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/float_widget_can_tap.dart';
import 'package:sliding_puzzle/cus_widget/glass_card.dart';
import 'time_out_failure_page.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/tools/tools.dart';
import 'final_completion_page.dart';
import 'level_complete_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.levelInfoIndex,
    required this.pageController,
  });

  final int levelInfoIndex;
  final PageController pageController;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final DBTools dbTools = DBTools();
  OverlayEntry? overlayEntry;

  late final TimeProgressController _timeProgressController =
      TimeProgressController(_onTimeOutFailure, vsync: this);
  late int _levelInfoIndex = widget.levelInfoIndex;

  late final SlidingPuzzleController _slidingPuzzleController =
      SlidingPuzzleController(
        buildSquareWidget: _buildSquareWidget,
        onStart: _timeProgressController.start,
        width: 288.0,
        levelIndex: _levelInfoIndex,
        onCompletedCallback: _onCompletedCallback,
      );

  LevelData? get _data => DBTools.getLevelDataByLeveId(_levelInfo.id);

  LevelInfo get _levelInfo => Levels.levelInfos[_levelInfoIndex];

  Widget _buildSquareWidget(int index) =>
      Image.asset(_levelInfo.squareImageAssets[index]);

  @override
  void initState() {
    super.initState();
    Future(() => widget.pageController.jumpToPage(_levelInfoIndex));
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry = null;
    _timeProgressController.dispose();
    _slidingPuzzleController.dispose();
    super.dispose();
  }

  void showGameCompletedDialog(LevelData? newData, LevelData? oldData) {
    final overlay = Overlay.of(context);
    overlayEntry?.remove();
    overlayEntry = null;
    if (newData != null) {
      overlayEntry = OverlayEntry(
        builder:
            (BuildContext context) => LevelCompletePage(
              oldDMil: oldData?.timeMil,
              newDMil: newData.timeMil,
              starCount: newData.starCount,
              playAgain: _playAgain,
              next: _next,
            ),
      );
    } else {
      overlayEntry = OverlayEntry(
        builder:
            (BuildContext context) => TimeOutFailurePage(
              retry: _playAgain,
              exit: _back,
              maxDMil: _levelInfo.starCountTimes.first.inMilliseconds,
            ),
      );
    }
    overlay.insert(overlayEntry!);
  }

  void _back() {
    overlayEntry?.remove();
    overlayEntry = null;
    _slidingPuzzleController.s.value = 0;
    Navigator.pop(context);
  }

  void _next() {
    overlayEntry?.remove();
    overlayEntry = null;
    _timeProgressController.value = 0;
    if (_levelInfoIndex + 1 < Levels.levelInfos.length) {
      setState(() {
        _levelInfoIndex++;
      });
      _slidingPuzzleController.s.value = 0;
      _slidingPuzzleController.s.value = 3;
      _timeProgressController.duration = _levelInfo.starCountTimes.first;
      _slidingPuzzleController.next();
      Future(() => widget.pageController.jumpToPage(_levelInfoIndex));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => FinalCompletionPage(),
        ),
      );
    }
  }

  void _playAgain() {
    overlayEntry?.remove();
    overlayEntry = null;
    _timeProgressController.value = 0;
    _slidingPuzzleController.s.value = 3;
    _slidingPuzzleController.reSet();
  }

  _onCompletedCallback() {
    final Duration duration = Tween<Duration>(
      begin: const Duration(),
      end: _levelInfo.starCountTimes.first,
    ).evaluate(_timeProgressController);

    _timeProgressController.stop();

    final LevelData newData = _levelInfo.getLevelData(duration.inMilliseconds);
    showGameCompletedDialog(newData, _data);
    DBTools.setLevelDataByLeveData(newData.smaller(_data));
  }

  _onTimeOutFailure() {
    showGameCompletedDialog(null, _data);
  }

  final box8H = SizedBox(height: 8);
  final box16H = SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        _slidingPuzzleController.s.value = 0;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  if (_levelInfoIndex != Levels.levelInfos.length - 1 &&
                      _levelInfo.id <= DBTools.maxLevelId)
                    PopupMenuItem(onTap: _next, child: Text('Next')),
                  PopupMenuItem(onTap: _playAgain, child: Text('Restart')),
                ];
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              box8H,
              FloatWidgetCanTap(
                child: Hero(
                  tag: _levelInfo.id,
                  child: PhotoFrame(image: Image.asset(_levelInfo.imageAssets)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(child: SizedBox(width: 1, height: 1)),
              ),
              TimeProgress(
                key: Key(_levelInfo.imageAssets),
                width: 288,
                times: _levelInfo.starCountTimes,
                timeProgressController: _timeProgressController,
              ),
              box8H,
              Container(
                width: 291,
                height: 291,
                clipBehavior: Clip.hardEdge,

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_levelInfo.imageAssets),
                  ),
                  borderRadius: BorderRadius.circular(16), // 圆角
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54, // 深棕色阴影
                      blurRadius: 12, // 阴影模糊半径
                      offset: Offset(1, 1), // 阴影偏移
                    ),
                  ],
                ),
                child: GlassCard(
                  // colorB1: Color(0x4D000000),
                  // colorT1: Color(0x00000000),
                  sigma: 30,
                  radius: Radius.circular(16),
                  child: SlidingPuzzle(
                    slidingPuzzleController: _slidingPuzzleController,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(child: SizedBox(width: 1, height: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
