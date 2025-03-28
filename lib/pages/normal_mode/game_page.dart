import 'dart:io';

import 'package:flutter/material.dart';
import 'time_out_failure_page.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/tools/tools.dart';
import 'final_completion_page.dart';
import 'level_complete_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.levelInfoIndex, required this.pageController});

  final int levelInfoIndex;
  final PageController pageController;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late final _levelInfo = Levels.levelInfos[widget.levelInfoIndex];
  final _slidingPuzzleWidth = 288.0;
  final DBTools dbTools = DBTools();
  late final TimeProgressController _timeProgressController;

  LevelData? get _data => DBTools.getLevelDataByLeveId(_levelInfo.id);

  OverlayEntry? overlayEntry;

  int reSetFlag = 0;

  @override
  void initState() {
    super.initState();
    _timeProgressController = TimeProgressController(_onTimeOutFailure, vsync: this);
    Future(() {
      widget.pageController.jumpToPage(widget.levelInfoIndex);
    });
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    _timeProgressController.dispose();
    super.dispose();
  }

  void showGameCompletedDialog(LevelData? newData, LevelData? oldData) {
    final overlay = Overlay.of(context);
    overlayEntry?.remove();
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
            (BuildContext context) =>
                TimeOutFailurePage(retry: _playAgain, exit: _back, maxDMil: _levelInfo.starCountTimes.first.inMilliseconds),
      );
    }
    overlay.insert(overlayEntry!);
  }

  void _back() {
    overlayEntry?.remove();
    overlayEntry = null;
    Navigator.pop(context);
  }

  void _next() {
    overlayEntry?.remove();
    overlayEntry = null;
    if (widget.levelInfoIndex + 1 < Levels.levelInfos.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GamePage(levelInfoIndex: widget.levelInfoIndex + 1, pageController: widget.pageController),
        ),
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FinalCompletionPage()));
    }
  }

  void _playAgain() {
    overlayEntry?.remove();
    setState(() => reSetFlag++);
    _timeProgressController.value = 0;
    overlayEntry = null;
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(onTap: _next, child: Text('next')),
                PopupMenuItem(onTap: _back, child: Text('返回')),
                PopupMenuItem(
                  child: Text('showD'),
                  onTap: () {
                    showGameCompletedDialog(LevelData(1, 2, 3, false), _data);
                  },
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Platform.isAndroid ? null : FloatingActionButton(onPressed: _back, child: Icon(Icons.exit_to_app)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            box8H,
            Hero(tag: _levelInfo.id, child: PhotoFrame(image: Image.asset(_levelInfo.imageAssets))),
            Expanded(flex: 1, child: Center(child: SizedBox(width: 1, height: 1))),
            TimeProgress(width: 288, times: _levelInfo.starCountTimes, timeProgressController: _timeProgressController),
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
                key: Key('$reSetFlag'),
                size: _levelInfo.size,
                imageAssetsList: _levelInfo.squareImageAssets,
                image: Image.asset(_levelInfo.imageAssets),
                width: _slidingPuzzleWidth,
                onCompletedCallback: _onCompletedCallback,
                seconds: 3,
                onStart: () {
                  _timeProgressController.start();
                },
              ),
            ),
            Expanded(flex: 3, child: Center(child: SizedBox(width: 1, height: 1))),
          ],
        ),
      ),
    );
  }
}
