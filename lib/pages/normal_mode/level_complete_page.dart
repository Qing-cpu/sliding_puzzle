import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 21, right: 21),
                height: 256.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.1),
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(1, 2),
                      // c
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.complete,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF262626),
                      ),
                    ),
                    const SizedBox(height: 14),
                    StarMax3ForCompletion(starCount: starCount),
                    const SizedBox(height: 14),
                    Text(
                      '${AppLocalizations.of(context)!.result}：${mil2TimeString(newDMil)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF5B5B5B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (oldDMil == null || oldDMil! > newDMil)
                      Text(
                        '${AppLocalizations.of(context)!.new_record}!',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF4A7DFF),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        '${AppLocalizations.of(context)!.record}：${mil2TimeString(oldDMil!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: playAgain,
                          child: Text(AppLocalizations.of(context)!.play_again),
                        ),
                        TextButton(
                          onPressed: next,
                          child: Text(AppLocalizations.of(context)!.next_level),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
