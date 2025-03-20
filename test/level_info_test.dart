import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_puzzle/data/levels/level_info.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';

void main() {
  testWidgets(r'Test [LevelInfo.calculateStarRating()] 星数计算', (_) async {
    const x = [
      Duration(minutes: 3),
      Duration(minutes: 2),
      Duration(minutes: 1),
    ];
    final levelInfo = Levels.levelInfos.first;
    expect(
      levelInfo.calculateStarRating(Duration(seconds: 3).inMilliseconds),
      3,
    );
    expect(
      levelInfo.calculateStarRating(Duration(seconds: 61).inMilliseconds),
      2,
    );
    expect(
      levelInfo.calculateStarRating(Duration(seconds: 121).inMilliseconds),
      1,
    );
     expect(
      levelInfo.calculateStarRating(Duration(seconds: 181).inMilliseconds),
      0,
    );
  });
}
