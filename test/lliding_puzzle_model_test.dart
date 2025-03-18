import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_puzzle/data/levels/levels.dart';
import 'package:sliding_puzzle/sliding_puzzle/models/sliding_puzzle_model.dart';

void main() {
  testWidgets('SlidingPuzzleModel.isSolvable Test', (WidgetTester test) async {
    final testData1 = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
    ];
    final matcher1 = true;
    expect(SlidingPuzzleModel.isSolvable(testData1), matcher1);

    final testData2 = [
      [2, 0, 1],
      [3, 8, 5],
      [6, 7, 4],
    ];
    final matcher2 = true;
    expect(SlidingPuzzleModel.isSolvable(testData2), matcher2);

    final testData3 = [
      [0, 1, 2],
      [5, 8, 3],
      [6, 7, 4],
    ];
    final matcher3 = false;
    expect(SlidingPuzzleModel.isSolvable(testData3), matcher3);
  });
}
