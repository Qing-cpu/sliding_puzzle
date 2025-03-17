import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';


import 'game_page.dart';

class LevelSelect extends StatefulWidget {
  const LevelSelect({super.key});

  @override
  State<LevelSelect> createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  int index = 0;

  final levels = Levels.levelInfos;
  final PageController _pageController = PageController(
    viewportFraction: 0.8, // 当前页面占屏幕宽度的 80%
  );
  final _heightBox8 = const SizedBox(height: 8);

  void _play(BuildContext context, LevelInfo levelInfo) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                GamePage(levelInfo: levelInfo),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
              opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('选图')),
      body: Column(
        children: [
          _heightBox8,
          SizedBox(
            height: 36,
            child: Text(
              Levels.levelInfos[index].name,
              style: TextStyle(fontSize: 24),
            ),
          ),
          _heightBox8,
          SizedBox(
            height: 288,
            child: PageView.builder(
              controller: _pageController,
              itemCount: levels.length,
              onPageChanged: (i) {
                setState(() => index = i);
              },
              itemBuilder: (BuildContext context, int i) {
                return Hero(
                  tag: levels[i].imageAssets,
                  child: Image.asset(
                    height: 288,
                    width: 288,
                    levels[i].imageAssets,
                  ),
                );
              },
            ),
          ),

          // 大小
          _heightBox8,
          LevelSizePoint(count: levels[index].size),
          _heightBox8,
          _heightBox8,
          StarsCount(index),
          _heightBox8,
          ElevatedButton(
            onPressed: () {
              _play(context, levels[index]);
            },
            child: Icon(Icons.play_arrow_rounded, size: 57),
          ),
          // Text('大小: ${_levelInfo.size} X ${_levelInfo.size}'),
          // Expanded(child: Container()),
        ],
      ),
    );
  }
}

class StarsCount extends StatelessWidget {
  const StarsCount(this.count, {super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 17,
        children: List.generate(
          3,
          (i) => AnimatedSwitcher(
            duration: Duration(milliseconds: 72),
            child: Container(
              key: Key('${i < count}'),
              padding: const EdgeInsets.all(4),
              margin: EdgeInsets.only(bottom: i == 1 ? 12 : 0),
              decoration: BoxDecoration(
                color:
                    i < count ? Colors.redAccent.shade200 : Color(0xFFFFE4E1),
                borderRadius: BorderRadius.circular(57),
                boxShadow: [
                  if (i < count)
                    BoxShadow(
                      color: Colors.grey, // 阴影颜色及透明度
                      spreadRadius: 1.0, // 扩散范围
                      blurRadius: 3.0, // 模糊程度
                      offset: Offset(2, 4), // 阴影偏移 (x, y)
                    ),
                  if (i < count)
                    BoxShadow(
                      color: Colors.pinkAccent.shade100, // 阴影颜色及透明度
                      spreadRadius: 1.0, // 扩散范围
                      blurRadius: 2.0, // 模糊程度
                      offset: Offset(-1, -1), // 阴影偏移 (x, y)
                    ),
                ],
              ),
              child: Icon(
                color: i < count ? Colors.yellow.shade400 : Color(0xFFE4CBC8),
                size: 46,
                Icons.star_sharp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelSizePoint extends StatelessWidget {
  final double size;
  final int count;

  const LevelSizePoint({super.key, this.size = 5, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: List<Widget>.generate(
        count,
        (_) => CircleAvatar(
          radius: size, // 半径
          backgroundColor: Color(0xFF8F8F8F),
        ),
      ),
    );
  }
}
