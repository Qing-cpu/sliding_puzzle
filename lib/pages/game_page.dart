import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';

import '../sliding_puzzle/sliding_puzzle.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.levelInfo});

  final LevelInfo levelInfo;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final _levelInfo = widget.levelInfo;
  bool isBegin = false;
  final _slidingPuzzleWidth = 288.0;

  _onBegin() {
    setState(() {
      isBegin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16,),
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
                          spreadRadius:2,
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
            Container(
              padding: EdgeInsets.all(12), // 内边距
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16), // 圆角
                // border: Border.all(
                //   color: Color(0xFF8E8888), // 深棕色边框
                //   width: 1, // 边框宽度
                // ),
                // border: Border(
                //   top: BorderSide(width: 4.0, color: Colors.lightBlueAccent), // 左上高亮
                //   left: BorderSide(width: 4.0, color: Colors.lightBlueAccent), // 左上高亮
                //   bottom: BorderSide(width: 4.0, color: Colors.grey), // 右下阴影
                //   right: BorderSide(width: 4.0, color: Colors.grey), // 右下阴影
                // ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
