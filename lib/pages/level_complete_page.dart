import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';

import 'cus_widget/stars_count.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({super.key, required this.oldData, required this.newData, required this.playAgain, required this.next});

  final LevelData? oldData;
  final LevelData newData;

  final VoidCallback playAgain;
  final VoidCallback next;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarsCount(newData.starCount),
              if (oldData == null) Text('新纪录'),
              if (oldData != null && newData.timeMil < oldData!.timeMil) Text('恭喜，新纪录'),
              Text('用时：${newData.timeMil ~/ 60000} m ${newData.timeMil ~/ 1000 % 60} s ${newData.timeMil % 1000} ms'),
              if (oldData != null) Text('历史：${oldData!.timeMil ~/ 60000} m ${oldData!.timeMil ~/ 1000 % 60} s ${oldData!.timeMil % 1000} ms'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [TextButton(onPressed: playAgain, child: Text('Play Again')), TextButton(onPressed: next, child: Text('Next'))],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
