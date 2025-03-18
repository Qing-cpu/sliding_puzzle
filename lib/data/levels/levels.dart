import 'package:sliding_puzzle/data/levels/level_info.dart';

const x = [Duration(minutes: 3), Duration(minutes: 2), Duration(minutes: 1)];

class Levels {
  static const List<LevelInfo> levelInfos = [
    LevelInfo(
      id: '1-1',
      imageAssets: 'assets/images/level/1-1.png',
      name: '赛博自然',
      size: 3,
      starCountTimes: x,
    ),
    LevelInfo(
      id: '1-2',
      imageAssets: 'assets/images/level/1-2.png',
      name: '农场·杂画',
      size: 4,
      starCountTimes: x,
    ),
    LevelInfo(
      id: '1-3',
      imageAssets: 'assets/images/level/1-3.png',
      name: '秋·印象',
      size: 5,
      starCountTimes: x,
    ),
  ];
}
