import 'package:flutter/cupertino.dart';
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
    _pageController = PageController(initialPage: _index);
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
      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => LevelListPage(pageController: _pageController)));

  _onPressedLeftIcon() =>
      _pageController.animateToPage(_pageController.page!.toInt() - 1, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  _onPressedRightIcon() =>
      _pageController.animateToPage(_pageController.page!.toInt() + 1, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

  String mil2TimeString(int mil) {
    return '${mil ~/ 60000} m ${mil ~/ 1000 % 60} s ${mil % 1000 ~/ 10} ms';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 44, actions: [GestureDetector(onTap: _openLevelListPage, child: StarCount()), SizedBox(width: 8)]),
      body: Column(
        children: [
          // < icon, level 序列, > icon
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: IconButton(onPressed: _onPressedLeftIcon, icon: Icon(Icons.chevron_left, color: const Color(0xFF1D2129)))),
                Expanded(
                  child: Center(
                    child: Text('${_index+1} / ${Levels.levelInfos.length}', style: TextStyle(color: const Color(0xFF1D2129), fontSize: 18)),
                  ),
                ),
                Expanded(
                  child: IconButton(onPressed: _onPressedRightIcon, icon: Icon(color: const Color(0xFF1D2129), Icons.chevron_right)),
                ),
              ],
            ),
          ),
          // level page view
          SizedBox(
            height: 288,
            child: PageView.builder(
              controller: _pageController,
              itemCount: levels.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
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
          const SizedBox(height: 8),
          // level name
          Text(Levels.levelInfos[_index].name, style: TextStyle(fontSize: 21, fontWeight: FontWeight.normal, color: Color(0xff1D2129))),
          const SizedBox(height: 8),
          // 星星
          StarsCount(leveData?.starCount),
          const SizedBox(height: 8),
          // 记录
          if (leveData != null)
            Text(
              '记录：${mil2TimeString(leveData!.timeMil)}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xff7d8aa1)),
            ),
        ],
      ),
    );
  }
}
