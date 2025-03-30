import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';

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

  String mil2TimeString(int mil) {
    return '${mil ~/ 60000}m, ${mil ~/ 1000 % 60}s, ${mil % 1000 ~/ 10}ms';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), child: Container(color: Colors.white54)),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                left: 21,
                right: 21
              ),
              height: 256.8,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54,
                    width: 0.1,
                  ),
                  color: Colors.white54, borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text('完成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF262626))),
                  const SizedBox(height: 14),
                  StarMax3ForCompletion(starCount: starCount),
                  const SizedBox(height: 14),
                  Text('耗时：${mil2TimeString(newDMil)}', style: TextStyle(fontSize: 16, color: const Color(0xFF5B5B5B))),
                  const SizedBox(height: 12),
                  if (oldDMil == null || oldDMil! > newDMil)
                    Text('新纪录!', style: TextStyle(fontSize: 16, color: const Color(0xFF4A7DFF), fontWeight: FontWeight.bold))
                  else
                    Text('记录：${mil2TimeString(oldDMil!)}', style: TextStyle(fontSize: 12, color: const Color(0xFF9E9E9E))),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: playAgain, child: Text('Play Again')),
                      TextButton(onPressed: next, child: Text('Next')),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
