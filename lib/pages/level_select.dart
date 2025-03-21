import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/db_tools.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/pages/level_list_page.dart';

import 'cus_widget/star_count.dart';
import 'cus_widget/stars_count.dart';
import 'cus_widget/start_box.dart';
import 'game_page.dart';

class LevelSelect extends StatefulWidget {
  const LevelSelect({super.key});

  @override
  State<LevelSelect> createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  int index = 0;

  final levels = Levels.levelInfos;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final _heightBox8 = const SizedBox(height: 8);

  bool _isAnim = false;

  LevelData? get leveData => DBTools.getLevelDataByLeveId(levels[index].id);

  void _play(BuildContext context, int levelInfoIndex) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                GamePage(levelInfoIndex: levelInfoIndex,pageController: _pageController),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  void _openLevelListPage() async {
    final levelInfosIndex = await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => LevelListPage()),
    );
    if (levelInfosIndex != null) {
      setState(() {
        _isAnim = true;
      });
      _pageController
          .animateToPage(
            levelInfosIndex,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOutQuart,
          )
          .then((_) {
            setState(() {
              _isAnim = false;
            });
          });
    }
  }

  _onPressedLeftIcon() => _pageController.animateToPage(
    _pageController.page!.toInt() - 1,
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
  );

  _onPressedRightIcon() => _pageController.animateToPage(
    _pageController.page!.toInt() + 1,
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
  );


  @override
  void didUpdateWidget(LevelSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openLevelListPage,
        child: Icon(Icons.list),
      ),
      appBar: AppBar(actions: [StarCount()]),
      body: Column(
        children: [
          _heightBox8,
          SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: _onPressedLeftIcon,
                      icon: Icon(
                        Icons.chevron_left,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child:
                        _isAnim
                            ? null
                            : Text(
                              Levels.levelInfos[index].name,
                              style: TextStyle(fontSize: 24),
                            ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: _onPressedRightIcon,
                      icon: Icon(
                        color: Colors.black54,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                        Icons.chevron_right,
                      ),
                    ),
                  ),
                ),
              ],
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
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:
                      i <= DBTools.maxLevelId + 1
                          ? StartBox(
                            onTap: () => _play(context, i),
                            height: 288,
                            width: 288,
                            // onTap: () => _play(context, i),
                            child: Hero(
                              tag: levels[i].id,
                              child: Image.asset(levels[i].imageAssets),
                            ),
                          )
                          : Icon(
                            Icons.image_rounded,
                            size: 288,
                            color: Colors.grey,
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
          StarsCount(leveData?.starCount),
          // Text('大小: ${_levelInfo.size} X ${_levelInfo.size}'),
          // Expanded(child: Container()),
        ],
      ),
    );
  }
}
