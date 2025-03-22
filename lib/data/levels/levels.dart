import 'package:sliding_puzzle/data/levels/level_info.dart';

const x = [Duration(minutes: 3), Duration(minutes: 2), Duration(minutes: 1)];
const s = [Duration(seconds: 5), Duration(seconds: 4), Duration(seconds: 3)];

class Levels {

  static List<LevelInfo> levelInfos = [
    LevelInfo(
      imageAssets: 'assets/images/level/1-1.png',
      name: '赛博自然',
      size: 3,
      starCountTimes: x,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/1-2.png',
      name: '农场·杂画s',
      size: 3,
      starCountTimes: s,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/1-3.png',
      name: '秋·印象',
      size: 3,
      starCountTimes: x,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/1-1.png',
      name: '赛博自然',
      size: 4,
      starCountTimes: x,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/1-2.png',
      name: '农场·杂画',
      size: 4,
      starCountTimes: x,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/1-3.png',
      name: '秋·印象',
      size: 4,
      starCountTimes: x,
    ),
  ];
}
