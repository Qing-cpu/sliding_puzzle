import 'package:flutter/material.dart';

import 'level_select.dart';

class ModelPage extends StatelessWidget {
  const ModelPage({super.key});

  void _startModel1(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => LevelSelect()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('选择模式'),
        actions: [
          // Expanded(child: Container(height: 10, width: 100, color: Colors.red)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Center(
                    child: Text('普通', style: TextStyle(fontSize: 50)),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: SizedBox(
                // height: ,
                width: 251,
                height: 79,
                child: Center(
                  child: Text('Start', style: TextStyle(fontSize: 50)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: SizedBox(
                // height: ,
                width: 251,
                height: 79,
                child: Center(
                  child: Text('Start', style: TextStyle(fontSize: 50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
