import 'package:flutter/material.dart';

class FinalCompletionPage extends StatelessWidget {
  const FinalCompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Congratulations! You have completed the game.'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
