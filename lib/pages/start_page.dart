import 'package:flutter/material.dart';
import 'package:sliding_puzzle/pages/setting_page.dart';

import 'model_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  void _start(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModelPage()));
  }

  void _setting(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 32),
            Container(
              width: 288,
              height: 300,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(80))),
              // clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/title.png',
                // filterQuality: FilterQuality.low, // 设置高质量滤镜
                fit: BoxFit.contain,
                // excludeFromSemantics: true,
              ),
            ),
            SizedBox(height: 53),
            // 开始 Start Button
            ElevatedButton(
              onPressed: () => _start(context),
              child: SizedBox(
                // height: ,
                width: 251,
                height: 79,
                child: Center(child: Text('Start', style: TextStyle(fontSize: 24,))),
              ),
            ),
            SizedBox(height: 53),
            SizedBox(
              width: 251,
              height: 79,
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
                  Expanded(child: SizedBox()),
                  IconButton(onPressed: () => _setting(context), icon: Icon(Icons.settings)),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
