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
              const SizedBox(height: 20),
              Text('完成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF262626))),
              const SizedBox(height: 8),
              StarsCount(newData.starCount),
              const SizedBox(height: 8),
              Text(
                '耗时：${newData.timeMil ~/ 60000} m ${newData.timeMil ~/ 1000 % 60} s ${newData.timeMil % 1000} ms',
                style: TextStyle(fontSize: 16, color: const Color(0xFF5B5B5B)),
              ),
              const SizedBox(height: 4),
              Text(
                oldData == null || oldData!.timeMil > newData.timeMil
                    ? '新纪录'
                    : '记录：${oldData!.timeMil ~/ 60000} m ${oldData!.timeMil ~/ 1000 % 60} s ${oldData!.timeMil % 1000} ms',
                style: TextStyle(fontSize: 10, color: const Color(0xFF9E9E9E)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
