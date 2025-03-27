import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';

class TimeOutFailurePage extends StatelessWidget {
  final VoidCallback retry;
  final VoidCallback exit;
  final int maxDMil;

  const TimeOutFailurePage({super.key, required this.retry, required this.exit,required this.maxDMil});

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
              Text('You Ran Time Of Out！', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF262626))),
              const SizedBox(height: 8),
              StarMax3(0),
              const SizedBox(height: 8),
              Text(
                '限时：${maxDMil ~/ 60000} m ${maxDMil ~/ 1000 % 60} s ${maxDMil % 1000} ms',
                style: TextStyle(fontSize: 16, color: const Color(0xFF5B5B5B)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [TextButton(onPressed: exit, child: Text('Exit')), TextButton(onPressed: retry, child: Text('Retry'))],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
