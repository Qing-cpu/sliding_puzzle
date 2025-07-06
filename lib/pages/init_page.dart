import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:sliding_puzzle/cus_widget/glass_card.dart';
import 'package:sliding_puzzle/pages/start_page.dart';

import '../tools/db_tools/db_tools.dart';
import '../tools/levels/levels.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Levels.init(context);
    lodeImage;
  }

  late final lodeImage = _initImage();

  // 尝试登录 (可以在游戏启动时调用)
  Future<void> signIn() async {
    try {
      await GamesServices.signIn();
      // 登录成功，可以解锁成就、提交分数等
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      // 处理登录失败或用户取消
    }
  }



  _initImage() async {
    signIn();
    final maxLevelId = DBTools.maxLevelId;
    int index = 0;
    if (maxLevelId != -1) {
      index = Levels.levelInfos.indexWhere((i) => i.id == maxLevelId);
    }
    final levelInfo = Levels.levelInfos[index];
    precacheImage(AssetImage('assets/images/nb1.png'), context);
    precacheImage(AssetImage('assets/images/game_name.webp'), context);
    precacheImage(AssetImage('assets/images/bg1.webp'), context);
    precacheImage(AssetImage('assets/images/bg2.webp'), context);
    precacheImage(AssetImage('assets/images/bg3.webp'), context);
    precacheImage(AssetImage(levelInfo.imageAssets), context);
  }

  void _toStartPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StartPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: TweenAnimationBuilder(
          onEnd: _toStartPage,
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: 2),
          curve: Curves.easeInQuart,
          builder: (BuildContext context, double value, Widget? child) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.shade700,
                        blurRadius: 6,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: GlassCard(
                    radius: Radius.circular(6),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          // 渐变起始点
                          end: Alignment.bottomRight,
                          // 渐变结束点
                          colors: [Color(0xF7FFEDED), Color(0x00000000)],
                          // 可选参数：
                          stops: [value, value + 0.001],
                          // 颜色停止点 (0.0 表示开始，1.0 表示结束)
                          tileMode: TileMode.clamp, // 渐变超出范围时的平铺模式
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
