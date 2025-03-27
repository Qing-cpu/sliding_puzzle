import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_puzzle/pages/speed_model/speed_model_page.dart';

import 'normal_mode/level_select.dart';

class ModelPage extends StatelessWidget {
  const ModelPage({super.key});

  void _startModel1(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LevelSelect()));
  }

  void _startSpeedModel1(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeedModelPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 40,
            children: [
              // SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _startModel1(context),
                  child: SizedBox(
                    // height: ,
                    width: 251,
                    height: 79,
                    child: Center(child: Text('普通', style: TextStyle(fontSize: 50))),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _startSpeedModel1(context),
                child: SizedBox(
                  // height: ,
                  width: 251,
                  height: 79,
                  child: Center(child: Text('极速模式', style: TextStyle(fontSize: 50))),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: SizedBox(
                  // height: ,
                  width: 251,
                  height: 79,
                  child: Center(child: Text('天梯模式', style: TextStyle(fontSize: 50))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
