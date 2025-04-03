import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/float_widget.dart';
import 'package:sliding_puzzle/tools/tools.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'level_list_page.dart';
import 'game_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if (maxId != -1) {
      _index = Levels.levelInfos.indexWhere((i) => i.id == maxId);
      if (++_index == Levels.levelInfos.length) {
        _index--;
      }
    }

    _pageController = PageController(
      initialPage: _index,
      viewportFraction: 0.8,
    );
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
        pageBuilder:
            (context, animation, secondaryAnimation) => GamePage(
              levelInfoIndex: levelInfoIndex,
              pageController: _pageController,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 360),
      ),
    ).then((_) => setState(() {}));
  }

  void _openLevelListPage() => Navigator.of(context).push(
    CupertinoPageRoute(
      builder:
          (BuildContext context) =>
              LevelListPage(pageController: _pageController, index: _index),
    ),
  );

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

  String mil2TimeString(int mil) {
    return '${mil ~/ 60000}m, ${mil ~/ 1000 % 60}s, ${mil % 1000 ~/ 10}ms';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 88,
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(
                key: Key('$_index'),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(levels[_index].imageAssets),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.white54),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                // margin: EdgeInsets.only(right: 16, left: 16),
                height: 44,
                decoration: BoxDecoration(
                  // color: Color(0xEEFFFFFF),
                  // borderRadius: BorderRadius.all(Radius.circular(4)),
                  // image: DecorationImage(image: AssetImage('assets/images/b.png'), fit: BoxFit.cover),
                  // color: Colors.white,
                  gradient: LinearGradient(
                    // 渐变起始点（左上角）
                    begin: Alignment.topCenter,
                    // 渐变结束点（右下角）
                    end: Alignment.bottomCenter,
                    // 定义渐变颜色列表
                    colors: [Color(0x00FFFFFF), Color(0xEFFFFFFF)],
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 0.2),
                  ),
                  // boxShadow: [
                  //   BoxShadow(color: Colors.black12, offset: Offset(2, 2)),
                  //   BoxShadow(color: Colors.grey, offset: Offset(5, 5), blurRadius: 10),
                  // ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1.5, 1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: _openLevelListPage,
                      child: StarCount(count: DBTools.allStarCount),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // < icon, level 序列, > icon
                SizedBox(height: 54),
                SizedBox(
                  height: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: _onPressedLeftIcon,
                          icon: Icon(
                            Icons.chevron_left,
                            color: const Color(0xFF1D2129),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: _openLevelListPage,
                          child: Center(
                            child: Text(
                              '${_index + 1} / ${Levels.levelInfos.length}',

                              style: TextStyle(
                                color: const Color(0xFF7D8285),
                                fontSize: 19,
                                // shadows: [Shadow(color: Colors.grey, offset: Offset(0.6, 1.5), blurRadius: 13)],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: _onPressedRightIcon,
                          icon: Icon(
                            color: const Color(0xFF1D2129),
                            Icons.chevron_right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // level page view
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double height = 330;
                    double size = 288;
                    if(constraints.maxWidth > 600){
                      height = 660;
                      size = 500;
                    }
                  return  SizedBox(
                      height: height,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: levels.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Center(
                            child:
                                i <= DBTools.maxLevelId + 1
                                    ? Container(
                                      width: size,
                                      height: size,
                                      padding: EdgeInsets.all(23),
                                      margin: EdgeInsets.only(
                                        top: 5,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFBFFFAFA),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(21),
                                        ),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54,
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                          ),
                                          // BoxShadow(color: Colors.grey, offset: Offset(5, 5), blurRadius: 10),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () => _play(context, i),
                                        child: Hero(
                                          tag: levels[i].id,
                                          child: FloatWidget(
                                            rotateZ: Tween<double>(
                                              begin: -0.02,
                                              end: 0.02,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(3),
                                                ),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 16,
                                                ),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    levels[i].imageAssets,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(1, 1),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
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
                    );
                  },
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    // width: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      gradient: LinearGradient(
                        // 渐变起始点（左上角）
                        begin: Alignment.topCenter,
                        // 渐变结束点（右下角）
                        end: Alignment.bottomCenter,
                        // 定义渐变颜色列表
                        colors: [
                          Color(0x00FFFFFF),
                          Color(0x88FFFFFF),
                          Color(0x00FFFFFF),
                        ],
                      ),
                      // border: Border(top: BorderSide(color: Colors.black54, width: 0.2)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            Levels.levelInfos[_index].name,
                            style: TextStyle(
                              fontSize: 23,
                              shadows: [
                                Shadow(
                                  color: Colors.grey,
                                  offset: Offset(0.6, 1.5),
                                  blurRadius: 16,
                                ),
                              ],
                              color: Color(0xEE1D2129),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 28),
                          // 星星
                          StarMax3(leveData?.starCount, size: 72),
                          const SizedBox(height: 16),
                          // 记录
                          if (leveData != null)
                            Text(
                              '${AppLocalizations.of(context)!.record}：${mil2TimeString(leveData!.timeMil)}',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: null,
                                color: Color(0xd5445468),
                              ),
                            ),

                          // Expanded(child: SizedBox(height: 8,)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
