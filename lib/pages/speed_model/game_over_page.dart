import 'package:flutter/material.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key, this.oldScore, required this.newScore, required this.playAgain, required this.exit});

  final int? oldScore;
  final int newScore;
  final void Function() playAgain;
  final void Function() exit;

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
              Text('Game Over', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF262626))),
              const SizedBox(height: 8),
              Text('成绩：$newScore', style: TextStyle(fontSize: 16, color: const Color(0xFF5B5B5B))),
              const SizedBox(height: 4),
              Text(
                oldScore == null || oldScore! > newScore ? '新纪录' : '记录：$oldScore',
                style: TextStyle(fontSize: 10, color: const Color(0xFF9E9E9E)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [TextButton(onPressed: playAgain, child: Text('Play Again')), TextButton(onPressed: exit, child: Text('Exit'))],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
