import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/db_tools.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/pages/level_list_page.dart';

import 'cus_widget/stars_count.dart';
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
  final DBTools dbTools = DBTools.getInstance();

  bool _isAnim = false;

  LevelData? get leveData => dbTools.getLevelDataByLeveId(levels[index].id);

  void upLeveData(LevelData newLevelData) {
    dbTools.setLevelDataByLeveData(newLevelData.newOrOld(leveData));
  }

  void _play(BuildContext context, int levelInfoIndex) async {
    final LevelData? data = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                GamePage(levelInfoIndex: levelInfoIndex),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
    if (data != null) {
      upLeveData(data);
      setState(() {});
    }
  }

  void _openLevelListPage() async {
    final levelInfosIndex = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) => LevelListPage(dbTools: dbTools),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openLevelListPage,
        child: Icon(Icons.list),
      ),
      appBar: AppBar(title: Text('选图')),
      body: Column(
        children: [
          _heightBox8,
          SizedBox(
            height: 36,
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
                  tag: levels[i].id,
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
          StarsCount(leveData?.starCount),
          _heightBox8,
          ElevatedButton(
            onPressed: () {
              _play(context, index);
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
