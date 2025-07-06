import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart' as gs;
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/cus_widget/float_widget.dart';
import 'package:sliding_puzzle/pages/copyright_notice_page.dart';
import 'package:sliding_puzzle/pages/sky_ladder/sky_ladder_page.dart';
import 'package:sliding_puzzle/pages/speed_model/speed_model_page.dart';
import '/l10n/app_localizations.dart';
import 'package:sliding_puzzle/tools/db_tools/db_tools.dart';
import 'package:sliding_puzzle/tools/sound/sound_tools.dart';

import '../cus_widget/glass_card.dart';
import 'normal_mode/level_select.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with WidgetsBindingObserver {
  bool is1 = true;
  ImageProvider? backgroundImage;

  int? skyLadderCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    DBTools.getSkyLadderCount().then((count) => skyLadderCount=count);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SoundTools.init();
    }
  }

  void _start() {
    setState(() => is1 = !is1);
  }

  void _startModel1() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LevelSelect()));
  }

  void _startSpeedModel1() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeedModelPage()));
  }
  Future<bool> isSignedIn() async {
    return await gs.GamesServices.isSignedIn;
  }
  void _leaderboardWidget() {
    if(Platform.isAndroid){
      // 检查是否已登录
      isSignedIn().then(print);
      gs.Leaderboards.showLeaderboards();
    }else{
      gs.Leaderboards.showLeaderboards();
    }
  }

  void _skyLadder() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SkyLadderPage(skyLadderCount: skyLadderCount ?? 1);
        },
      ),
    );
    skyLadderCount = await DBTools.getSkyLadderCount();
  }

  void _openCopyrightNoticePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return CopyrightNoticePage();
        },
      ),
    );
  }

  Widget animatedContainer({double? width, double? height, Widget? child}) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/nb1.png'), fit: BoxFit.cover),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 160),
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.ease,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child:
                is1
                    ? Center(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          double fontSize = 62;
                          double width = 300;
                          double height = 100;
                          Radius radius = Radius.circular(32);
                          if (constraints.maxWidth > 600) {
                            fontSize = 80;
                            width = 450;
                            height = 140;
                            radius = Radius.circular(40);
                          }
                          return Center(
                            child: animatedContainer(
                              height: height,
                              width: width,
                              child: AButton(
                                fontColor: Colors.white,
                                sColor: Color(0xEFFF3D3D),
                                onTap: _start,
                                width: width,
                                fontSize: fontSize,
                                text: AppLocalizations.of(context)!.start,
                                radius: radius,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    : LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        var sizedBoxH = animatedContainer(height: 50);
                        double fontSize = 50;
                        double width = 300;
                        double height = 90;
                        final dw = MediaQuery.of(context).size.width;
                        final dh = MediaQuery.of(context).size.height;
                        if (dw > 800) {
                          fontSize = 80;
                          width = 550;
                          height = 150;
                          if (dh > 800) {
                            sizedBoxH = animatedContainer(height: 120);
                          } else {
                            sizedBoxH = animatedContainer(height: 90);
                          }
                        } else if (dw > 600) {
                          sizedBoxH = animatedContainer(height: 60);
                          fontSize = 60;
                          width = 500;
                          height = 120;
                        }
                        return Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: SizedBox(),
                            ),
                            ListView(
                              physics: BouncingScrollPhysics(),
                              children: [
                                SizedBox(height: MediaQuery.of(context).padding.top),
                                sizedBoxH,
                                animatedContainer(
                                  width: width,
                                  height: height,
                                  child: AButton(
                                    onTap: () => _skyLadder(),
                                    sColor: Color(0xF50057F1),
                                    width: width,
                                    fontSize: fontSize,
                                    fontColor: Color(0xFFFFCE08),
                                    text: AppLocalizations.of(context)!.number,
                                    radius: Radius.circular(32),
                                  ),
                                ),
                                sizedBoxH,
                                animatedContainer(
                                  width: width,
                                  height: height,
                                  child: AButton(
                                    onTap: () => _startSpeedModel1(),
                                    sColor: Color(0xFAFFD609),
                                    width: width,
                                    fontSize: fontSize,
                                    fontColor: Colors.pinkAccent.shade200,
                                    text: AppLocalizations.of(context)!.racing,
                                    radius: Radius.circular(32),
                                  ),
                                ),
                                sizedBoxH,
                                animatedContainer(
                                  width: width,
                                  height: height,
                                  child: FloatWidget(
                                    child: AButton(
                                      onTap: () => _startModel1(),
                                      width: width,
                                      fontSize: fontSize,
                                      text: AppLocalizations.of(context)!.image,
                                      radius: Radius.circular(32),
                                      sColor: Colors.pink,
                                    ),
                                  ),
                                ),
                                sizedBoxH,
                                animatedContainer(
                                  width: width,
                                  height: height,
                                  child: AButton(
                                    onTap: () => _leaderboardWidget(),
                                    sColor: Color(0xFFFFFFFF),
                                    width: width,
                                    fontSize: fontSize,
                                    fontColor: Color(0xFC00F462),
                                    text: AppLocalizations.of(context)!.leaderboard,
                                    radius: Radius.circular(32),
                                  ),
                                ),
                                sizedBoxH,
                                SizedBox(height: MediaQuery.of(context).padding.bottom),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
          ),
          if (is1 == false)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 12,
              left: 50,
              child: SizedBox(
                width: 80,
                height: 80,
                child: Center(
                  child: FloatWidget(
                    child: GlassCard(
                      colorB1: Colors.white12,
                      colorT1: Colors.white24,
                      lightColor: Colors.green,
                      radius: Radius.circular(50),
                      child: SizedBox(
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: IconButton(
                            onPressed: () => setState(() => is1 = true),
                            icon: Icon(
                              Icons.exit_to_app,
                              size: 41,
                              color: Color(0xE2FFF5B7),
                              shadows: [
                                Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(1, 3)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // if (is1 == false)
          if (false)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 12,
              right: 50,
              child: SizedBox(
                width: 100,
                height: 100,
                child: FloatWidget(
                  rotateX: Tween<double>(begin: 0.1, end: -0.1),
                  rotateY: Tween<double>(begin: -0.1, end: 0.1),
                  child: GlassCard(
                    colorB1: Colors.white12,
                    colorT1: Colors.white24,
                    lightColor: Colors.yellowAccent,
                    radius: Radius.circular(50),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: TextButton(
                          onPressed: () => setState(() => is1 = true),
                          child: Image.asset('assets/images/chest_l.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (is1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              right: 16,
              child: SizedBox(
                width: 43,
                height: 43,
                child: FloatWidget(
                  rotateX: Tween<double>(begin: 0.1, end: -0.1),
                  rotateY: Tween<double>(begin: -0.1, end: 0.1),
                  child: GlassCard(
                    colorB1: Colors.white12,
                    colorT1: Colors.white24,
                    lightColor: Colors.blue,
                    radius: Radius.circular(50),
                    child: IconButton(
                      onPressed: _openCopyrightNoticePage,
                      icon: Icon(Icons.info_outline),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
