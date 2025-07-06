import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class FinalCompletionPage extends StatelessWidget {
  const FinalCompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.complete)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.congratulations_game_completed),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.exit),
            ),
          ],
        ),
      ),
    );
  }
}
