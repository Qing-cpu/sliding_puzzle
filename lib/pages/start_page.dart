import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/cus_widget/float_widget.dart';
import 'package:sliding_puzzle/cus_widget/float_widget_can_tap.dart';
import 'package:sliding_puzzle/pages/copyright_notice_page.dart';
import 'package:sliding_puzzle/pages/speed_model/speed_model_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  void _startModel1(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => LevelSelect()));
  }

  void _startSpeedModel1(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => SpeedModelPage()));
  }

  void _leaderboardWidget(BuildContext context) {
    Leaderboards.showLeaderboards(
      androidLeaderboardID: '',
      iOSLeaderboardID: 'speed_model',
    );
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

  int get _hour => DateTime.now().hour;

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
              image: DecorationImage(
                image: AssetImage('assets/images/bb${_hour > 19 ? 1 : 2}.webp'),
                fit: BoxFit.cover,
              ),
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
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        SizedBox(height: 16),
                        FloatWidgetCanTap(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: GlassCard(
                              radius: Radius.circular(30),
                              child: LayoutBuilder(
                                builder: (
                                  BuildContext context,
                                  BoxConstraints constraints,
                                ) {
                                  double size = 0;
                                  if (constraints.maxWidth > 650) {
                                    size = 600;
                                  } else if (constraints.maxWidth > 450) {
                                    size = 400;
                                  } else if (constraints.maxWidth > 320) {
                                    size = 300;
                                  } else {
                                    return Image.asset(
                                      'assets/images/game_name.webp',
                                      fit: BoxFit.cover,
                                    );
                                  }
                                  return SizedBox(
                                    width: size,
                                    height: size,
                                    child: Image.asset(
                                      'assets/images/game_name.webp',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        LayoutBuilder(
                          builder: (
                            BuildContext context,
                            BoxConstraints constraints,
                          ) {
                            double fontSize = 62;
                            double width = 300;
                            double height = 100;
                            Radius radius = Radius.circular(32);
                            if (constraints.maxWidth > 600) {
                              fontSize = 80;
                              width = 450;
                              height = 140;
                              radius =  Radius.circular(40);
                            }
                            return Center(
                              child: SizedBox(
                                height: height,
                                child: AButton(
                                  fontColor: Colors.white,
                                  sColor: Color(0x939CFFAC),
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
                        Expanded(child: SizedBox()),
                      ],
                    )
                    : LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints constraints,
                      ) {
                        SizedBox sizedBoxH = SizedBox(height: 50);
                        double fontSize = 50;
                        double width = 300;
                        if (constraints.maxWidth > 600) {
                          sizedBoxH = SizedBox(height: 120);
                          fontSize = 80;
                          width = 550;
                        }
                        return Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: SizedBox(),
                            ),
                            ListView(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).padding.top,
                                ),
                                sizedBoxH,

                                FloatWidget(
                                  child: AButton(
                                    onTap: () => _startModel1(context),
                                    width: width,
                                    fontSize: fontSize,
                                    text: AppLocalizations.of(context)!.normal,
                                    radius: Radius.circular(32),
                                    sColor:
                                        _hour < 19
                                            ? Colors.pink
                                            : Color(0xE000FF15),
                                  ),
                                ),
                                sizedBoxH,
                                AButton(
                                  onTap: () => _startSpeedModel1(context),
                                  sColor:
                                      _hour < 19
                                          ? Colors.orange
                                          : Color(0xB8FF0000),
                                  width: width,
                                  fontSize: fontSize,
                                  fontColor: Colors.pinkAccent.shade200,
                                  text: AppLocalizations.of(context)!.racing,
                                  radius: Radius.circular(32),
                                ),
                                SizedBox(height: fontSize),
                                AButton(
                                  onTap: () => _leaderboardWidget(context),
                                  sColor:
                                      _hour < 19
                                          ? Colors.orangeAccent
                                          : Colors.cyanAccent,
                                  width: width,
                                  fontSize: fontSize > 50 ? fontSize : 40,
                                  fontColor:
                                      _hour < 19
                                          ? Colors.blueAccent.shade700
                                          : Color(0xF43804DD),
                                  text:
                                      AppLocalizations.of(context)!.leaderboard,
                                  radius: Radius.circular(32),
                                ),
                                sizedBoxH,

                                SizedBox(
                                  height: MediaQuery.of(context).padding.bottom,
                                ),
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
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(1, 3),
                                ),
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
