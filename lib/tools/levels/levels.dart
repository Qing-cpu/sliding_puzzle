import 'level_info.dart';

const d1 = [Duration(minutes: 3), Duration(minutes: 2), Duration(minutes: 1)];
const d2 = [Duration(minutes: 2), Duration(minutes: 1), Duration(seconds: 50)];
const d3 = [Duration(minutes: 1), Duration(seconds: 50), Duration(seconds: 40)];
const d4 = [
  Duration(seconds: 50),
  Duration(seconds: 40),
  Duration(seconds: 30),
];
const d5 = [
  Duration(seconds: 40),
  Duration(seconds: 30),
  Duration(seconds: 25),
];
const d6 = [
  Duration(seconds: 35),
  Duration(seconds: 25),
  Duration(seconds: 20),
];
const d7 = [Duration(minutes: 5), Duration(minutes: 3), Duration(seconds: 60)];
const d8 = [Duration(minutes: 3), Duration(minutes: 2), Duration(seconds: 50)];
const d9 = [Duration(minutes: 2), Duration(minutes: 1), Duration(seconds: 40)];
const d10 = [Duration(minutes: 10), Duration(minutes: 5), Duration(minutes: 3)];
const d11 = [Duration(minutes: 5), Duration(minutes: 4), Duration(minutes: 1)];

class Levels {
  static List<LevelInfo> levelInfos = [
    LevelInfo(
      imageAssets: 'assets/images/level/1.png',
      name: '秋·绯',
      size: 3,
      starCountTimes: d1,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/2.png',
      name: '飘浮',
      size: 3,
      starCountTimes: d2,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/3.png',
      name: 'l(-v-)l',
      size: 3,
      starCountTimes: d3,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/4.png',
      name: '朋友',
      size: 3,
      starCountTimes: d4,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/5.png',
      name: '花',
      size: 3,
      starCountTimes: d5,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/6.png',
      name: '傍晚',
      size: 3,
      starCountTimes: d6,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/7.png',
      name: '绿色城市',
      size: 4,
      starCountTimes: d7,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/8.png',
      name: '猫·画卷',
      size: 4,
      starCountTimes: d8,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/9.png',
      name: 'X·印象',
      size: 4,
      starCountTimes: d9,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/10.png',
      name: 'M·印象',
      size: 5,
      starCountTimes: d10,
    ),
    LevelInfo(
      imageAssets: 'assets/images/level/11.png',
      name: '公鸡·杂画',
      size: 5,
      starCountTimes: d11,
    ),
  ];
}
