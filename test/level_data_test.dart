import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';

void main() {
  testWidgets(r'Test [LevelData.smaller] 比较dMil 返回DMil小的', (_) async {
    final LevelData data1 = LevelData(
      '1-1',
      3,
      Duration(seconds: 18).inMilliseconds,
      false,
    );
    final LevelData data2 = LevelData(
      '1-1',
      2,
      Duration(seconds: 61).inMilliseconds,
      false,
    );
    final LevelData data3 = LevelData(
      '1-1',
      1,
      Duration(seconds: 121).inMilliseconds,
      false,
    );
    expect(data1.smaller(null), data1);
    expect(data2.smaller(data1), data1);
    expect(data2.smaller(data3), data2);
  });

  testWidgets('LevelData isChanged test', (_) async {
    final LevelData levelData1 = LevelData('1-1', 3, 15000, false);
    final LevelData levelData2 = LevelData('1-1', 3, 15000, false);
    final LevelData levelData3 = LevelData('1-1', 2, 61000, false);
    expect(levelData1.isChanged(levelData2), false);
    expect(levelData3.isChanged(levelData2), true);
  });
}
