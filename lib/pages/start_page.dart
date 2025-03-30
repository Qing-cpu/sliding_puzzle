import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/pages/speed_model/speed_model_page.dart';

import 'normal_mode/level_select.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool is1 = true;

  void _start() {
    setState(() => is1 = !is1);
  }

  void _startModel1(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LevelSelect()));
  }

  void _startSpeedModel1(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeedModelPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          is1 ? null : FloatingActionButton(child: Icon(Icons.exit_to_app_rounded), onPressed: () => setState(() => is1 = true)),
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg2.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 160),
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.ease,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child:
                is1
                    ? Center(
                      child: SizedBox(
                        // width: 3,
                        height: 100,
                        child: AButton(
                          fontColor: Colors.white,
                          sColor: Color(0x939CFFAC),
                          onTap: _start,
                          width: 300,
                          fontSize: 62,
                          text: 'Start',
                          radius: Radius.circular(32),
                        ),
                      ),
                    )
                    : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            color: Colors.white38,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  AButton(
                                    onTap: () => _startModel1(context),
                                    width: 318,
                                    fontSize: 50,
                                    text: '普通模式',
                                    radius: Radius.circular(32),
                                    sColor: Colors.pink,
                                  ),
                                  SizedBox(height: 50),
                                  AButton(
                                    onTap: () => _startSpeedModel1(context),
                                    sColor: Colors.orangeAccent,
                                    width: 318,
                                    fontSize: 50,
                                    fontColor: Colors.blueAccent.shade700,
                                    text: 'Speed\nModel',
                                    radius: Radius.circular(32),

                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
