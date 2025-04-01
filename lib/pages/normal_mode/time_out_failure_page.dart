import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeOutFailurePage extends StatelessWidget {
  final VoidCallback retry;
  final VoidCallback exit;
  final int maxDMil;

  const TimeOutFailurePage({super.key, required this.retry, required this.exit, required this.maxDMil});

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
              child: Container(
                margin: EdgeInsets.all(15.6),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 0.1),
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 27, sigmaY: 27), child: Container(color: Colors.white12)),
              ),
            ),
            Container(
              margin: EdgeInsets.all(17),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.1),
                color: Colors.white24,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.you_ran_out_of_time,
                    style: TextStyle(
                      shadows: [
                        Shadow(color: Color(0xD31B1E55), offset: Offset(1, 1), blurRadius: 6),
                        Shadow(color: Color(0x9E6A0303), offset: Offset(-0.1, -0.1), blurRadius: 1),
                      ],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262626),
                    ),
                  ),
                  const SizedBox(height: 8),
                  StarMax3(0),
                  const SizedBox(height: 8),
                  Text('${AppLocalizations.of(context)!}：${mil2TimeString(maxDMil)}', style: TextStyle(fontSize: 16, color: const Color(0xFF5B5B5B))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [TextButton(onPressed: exit, child: Text(AppLocalizations.of(context)!.exit)), TextButton(onPressed: retry, child: Text(AppLocalizations.of(context)!.try_again))],
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
