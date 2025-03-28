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
      floatingActionButton: is1 ? null : FloatingActionButton(onPressed: () => setState(() => is1 = true)),
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg2.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 开始 Start
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 320),
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child:
                      is1
                          ? AButton(
                            fontColor: Colors.white,
                            backgroundColor: Colors.orangeAccent,
                            onTap: _start,
                            width: 300,
                            fontSize: 54,
                            text: 'Start',
                            radius: Radius.circular(32),
                          )
                          : Column(
                            children: [
                              AButton(
                                onTap: () => _startModel1(context),
                                width: 300,
                                fontSize: 32,
                                text: '普通模式',
                                radius: Radius.circular(32),
                              ),
                              SizedBox( height: 32,),
                              AButton(
                                onTap: () => _startSpeedModel1(context),
                                width: 300,
                                fontSize: 32,
                                fontColor: Colors.blueAccent.shade700,
                                backgroundColor: Colors.greenAccent.shade100,
                                text: 'SpeedModel',
                                radius: Radius.circular(32),
                              ),
                            ],
                          ),
                ),
                // SizedBox(height: 53),
                // SizedBox(
                //   width: 251,
                //   height: 79,
                //   child: Row(
                //     children: [
                //       Expanded(child: SizedBox()),
                //       IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
                //       Expanded(child: SizedBox()),
                //       IconButton(onPressed: () => _setting(context), icon: Icon(Icons.settings)),
                //       Expanded(child: SizedBox()),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
