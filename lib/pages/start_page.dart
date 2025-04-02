import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/cus_widget/float_widget.dart';
import 'package:sliding_puzzle/cus_widget/float_widget_can_tap.dart';
import 'package:sliding_puzzle/pages/speed_model/speed_model_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../cus_widget/glass_card.dart';
import '../cus_widget/move.dart';
import 'normal_mode/level_select.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool is1 = true;

  // int dIndex = 0;
  // Timer? timer;

  // late final PageController _pageController = PageController();

  @override
  void initState() {
    Future(() => GameAuth.signIn());
    // Future(() {
    //   _pageController.animateTo(
    //     50000,
    //     duration: Duration(seconds: 600),
    //     curve: Curves.linear,
    //   );
    // });
    super.initState();
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

  @override
  void dispose() {
    // timer?.cancel();
    // timer = null;
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/bb${DateTime.now().hour > 19 ? 1 : 2}.webp',
              fit: BoxFit.cover,
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
                        Center(
                          child: FloatWidgetCanTap(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: GlassCard(
                                radius: Radius.circular(30),
                                child: Image.asset(
                                  'assets/images/game_name.webp',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Center(
                          child: SizedBox(
                            height: 100,
                            child: AButton(
                              fontColor: Colors.white,
                              sColor: Color(0x939CFFAC),
                              onTap: _start,
                              width: 300,
                              fontSize: 62,
                              text: AppLocalizations.of(context)!.start,
                              radius: Radius.circular(32),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    )
                    : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).padding.top,
                                  ),
                                  SizedBox(height: 50),
                                  FloatWidget(
                                    child: AButton(
                                      onTap: () => _startModel1(context),
                                      width: 280,
                                      fontSize: 50,
                                      text:
                                          AppLocalizations.of(context)!.normal,
                                      radius: Radius.circular(32),
                                      sColor: Colors.pink,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  AButton(
                                    onTap: () => _startSpeedModel1(context),
                                    sColor: Colors.orange,
                                    width: 290,
                                    fontSize: 50,
                                    fontColor: Colors.pinkAccent.shade200,
                                    text: AppLocalizations.of(context)!.racing,
                                    radius: Radius.circular(32),
                                  ),
                                  SizedBox(height: 50),
                                  AButton(
                                    onTap: () => _leaderboardWidget(context),
                                    sColor: Colors.orangeAccent,
                                    width: 318,
                                    fontSize: 50,
                                    fontColor: Colors.blueAccent.shade700,
                                    text:
                                        AppLocalizations.of(
                                          context,
                                        )!.leaderboard,
                                    radius: Radius.circular(32),
                                  ),
                                  SizedBox(height: 50),

                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).padding.bottom,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
          if ( false)
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
        ],
      ),
    );
  }
}
