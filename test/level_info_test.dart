import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';

void main() {
  testWidgets('LevelInfo class test', (WidgetTester tester) async {
    LevelInfo levelInfo = LevelInfo(
      id: '1-1',
      imageAssets: 'assets/images/level/1-1.png',
      name: '赛博自然',
      size: 3,
    );
    final res = levelInfo.squareImageAssets;
    final matcher = [
      'assets/images/level/1-1/0.png',
      'assets/images/level/1-1/1.png',
      'assets/images/level/1-1/2.png',
      'assets/images/level/1-1/3.png',
      'assets/images/level/1-1/4.png',
      'assets/images/level/1-1/5.png',
      'assets/images/level/1-1/6.png',
      'assets/images/level/1-1/7.png',
      'assets/images/level/1-1/8.png',
    ];
    expect(res, matcher);
  });
}
