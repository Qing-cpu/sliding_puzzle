import 'package:flutter/material.dart';

class TimeOutFailurePage extends StatelessWidget {
  final VoidCallback retry;
  final VoidCallback exit;

  const TimeOutFailurePage({super.key, required this.retry, required this.exit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Up!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Oops! You ran out of time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Text('Don’t worry, you can try again!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black45)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: retry, child: Text('Retry')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: exit, child: Text('Exit')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
