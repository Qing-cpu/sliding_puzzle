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
  final _heightBox8 = const SizedBox(height: 8);
  int _index = 0;
  final levels = Levels.levelInfos;
  late final PageController _pageController;

  LevelData? get leveData => DBTools.getLevelDataByLeveId(levels[_index].id);

  _listener() {
    final page = _pageController.page?.toInt() ?? 0;
    if (page != _index) {
      setState(() => _index = page);
    }
  }

  @override
  void initState() {
    super.initState();
    final maxId = DBTools.maxLevelId;
    _index = Levels.levelInfos.indexWhere((i) => i.id == maxId);
    _pageController = PageController(viewportFraction: 0.8, initialPage: _index);
    _pageController.addListener(_listener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    super.dispose();
  }

  void _play(BuildContext context, int levelInfoIndex) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GamePage(levelInfoIndex: levelInfoIndex, pageController: _pageController),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  void _openLevelListPage() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LevelListPage(pageController: _pageController)));

  _onPressedLeftIcon() =>
      _pageController.animateToPage(_pageController.page!.toInt() - 1, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  _onPressedRightIcon() =>
      _pageController.animateToPage(_pageController.page!.toInt() + 1, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(Icons.list,
          size: 31,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black87,
                blurRadius: 2,
                offset: Offset(1, 1),
              )
            ],
          ), onPressed: _openLevelListPage,
        ),
        GestureDetector(
            onTap: _openLevelListPage,
            child: StarCount()),
        SizedBox(
          width: 8,
        ),
      ]),
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
                        shadows: [Shadow(color: Colors.black87, blurRadius: 2, offset: Offset(1, 1))],
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Center(child: Text(Levels.levelInfos[_index].name, style: TextStyle(fontSize: 24)))),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: _onPressedRightIcon,
                      icon: Icon(
                        color: Colors.black54,
                        shadows: [Shadow(color: Colors.black87, blurRadius: 2, offset: Offset(1, 1))],
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
                            child: Hero(tag: levels[i].id, child: Image.asset(levels[i].imageAssets)),
                          )
                          : Icon(Icons.image_rounded, size: 288, color: Colors.grey),
                );
              },
            ),
          ),

          // 大小
          _heightBox8,
          LevelSizePoint(count: levels[_index].size),
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
