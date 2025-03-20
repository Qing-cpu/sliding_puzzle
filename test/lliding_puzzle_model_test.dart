import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_puzzle/sliding_puzzle/models/sliding_puzzle_model.dart';

void main() {
  testWidgets('SlidingPuzzleModel.isSolvable Test', (WidgetTester test) async {
    // 已解状态（逆序数=0，偶）
    final testData1 = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
    ];
    expect(SlidingPuzzleModel.isSolvable(testData1), true);
    // 修复 testData2：将右下角值改为8，其他位置调整
    final validTestData2 = [
      [2, 0, 1],
      [3, 4, 5],
      [6, 7, 8], // 空白块正确位置
    ];
    expect(SlidingPuzzleModel.isSolvable(validTestData2), true);

    // 不可解状态（逆序数=1，奇）
    final testData3 = [
      [1, 0, 2], // 逆序数=1
      [3, 4, 5],
      [6, 7, 8],
    ];
    expect(SlidingPuzzleModel.isSolvable(testData3), false);
  });
}
