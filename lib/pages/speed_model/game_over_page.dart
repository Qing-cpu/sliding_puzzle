import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/glass_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({
    super.key,
    this.oldScore,
    required this.newScore,
    required this.playAgain,
    required this.exit,
  });

  final int? oldScore;
  final int newScore;
  final void Function() playAgain;
  final void Function() exit;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    return Scaffold(
      backgroundColor:Color(0x00000000),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: 500,
          child: GlassCard(
            colorT1: Color(0x244A0000),
            colorB1:Color(0x52000000),
            radius: Radius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.game_over,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    shadows: [
                      Shadow(
                        color: Colors.white12,
                        blurRadius: 6,
                        offset: Offset(0.5, 0.5)
                      )
                    ]
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${AppLocalizations.of(context)!.score}：$newScore',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25, color:  Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  oldScore == null || newScore > oldScore!
                      ? AppLocalizations.of(context)!.new_record
                      : '${AppLocalizations.of(context)!.record}：$oldScore',
                  style: TextStyle(fontSize: 20, color: const Color(0xFF606060)),
                ),
                SizedBox(height:56),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: playAgain,
                      child: Text(AppLocalizations.of(context)!.play_again),
                    ),
                    TextButton(
                      onPressed: exit,
                      child: Text(AppLocalizations.of(context)!.exit),
                    ),
                  ],
                ),
                SizedBox(height: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
