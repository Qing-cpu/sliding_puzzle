import 'package:flutter/material.dart';

import '../cus_widget/stars_count.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({
    super.key,
    required this.oldDMil,
    required this.newDMil,
    required this.starCount,
    required this.playAgain,
    required this.next,
  });

  final int? oldDMil;
  final int newDMil;
  final int starCount;

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
              StarsCount(starCount),
              const SizedBox(height: 8),
              Text(
                '耗时：${newDMil ~/ 60000} m ${newDMil ~/ 1000 % 60} s ${newDMil % 1000} ms',
                style: TextStyle(fontSize: 16, color: const Color(0xFF5B5B5B)),
              ),
              const SizedBox(height: 4),
              Text(
                oldDMil == null || oldDMil! > newDMil
                    ? '新纪录'
                    : '记录：${oldDMil! ~/ 60000} m ${oldDMil! ~/ 1000 % 60} s ${oldDMil! % 1000} ms',
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
