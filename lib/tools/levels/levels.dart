import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'level_info.dart';
import '/l10n/app_localizations.dart';

const d1 = [Duration(minutes: 3), Duration(minutes: 2), Duration(minutes: 1)];
const d2 = [Duration(minutes: 2), Duration(minutes: 1), Duration(seconds: 50)];
const d3 = [Duration(minutes: 1), Duration(seconds: 50), Duration(seconds: 40)];
const d4 = [Duration(seconds: 50), Duration(seconds: 40), Duration(seconds: 30)];
const d5 = [Duration(seconds: 40), Duration(seconds: 30), Duration(seconds: 25)];
const d6 = [Duration(seconds: 35), Duration(seconds: 25), Duration(seconds: 20)];
const d7 = [Duration(minutes: 5), Duration(minutes: 3), Duration(seconds: 60)];
const d8 = [Duration(minutes: 3), Duration(minutes: 2), Duration(seconds: 50)];
const d9 = [Duration(minutes: 2), Duration(minutes: 1), Duration(seconds: 40)];
const d10 = [Duration(minutes: 10), Duration(minutes: 5), Duration(minutes: 3)];
const d11 = [Duration(minutes: 5), Duration(minutes: 4), Duration(minutes: 1)];

class Levels {
  static void init(BuildContext context) {
    if (_levelInfos != null) {
      return;
    }
    _levelInfos = [
      LevelInfo(
        imageAssets: 'assets/images/level/1.png',
        name: AppLocalizations.of(context)!.autumn_scarlet,
        size: 3,
        starCountTimes: d1,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/2.png',
        name: AppLocalizations.of(context)!.floating_islands,
        size: 3,
        starCountTimes: d2,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/3.png',
        name: AppLocalizations.of(context)!.emoji,
        size: 3,
        starCountTimes: d3,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/4.png',
        name: AppLocalizations.of(context)!.friends_gathering,
        size: 3,
        starCountTimes: d4,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/5.png',
        name: AppLocalizations.of(context)!.floral_bloom,
        size: 3,
        starCountTimes: d5,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/6.png',
        name: AppLocalizations.of(context)!.twilight_hues,
        size: 3,
        starCountTimes: d6,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/7.png',
        name: AppLocalizations.of(context)!.emerald_city,
        size: 4,
        starCountTimes: d7,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/8.png',
        name: AppLocalizations.of(context)!.cat_scroll,
        size: 4,
        starCountTimes: d8,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/9.png',
        name: AppLocalizations.of(context)!.x_impression,
        size: 4,
        starCountTimes: d9,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/10.png',
        name: AppLocalizations.of(context)!.m_impression,
        size: 5,
        starCountTimes: d10,
      ),
      LevelInfo(
        imageAssets: 'assets/images/level/11.png',
        name: AppLocalizations.of(context)!.rooster_doodle,
        size: 5,
        starCountTimes: d11,
      ),
    ];
  }

  static List<LevelInfo>? _levelInfos;

  static List<LevelInfo> get levelInfos => _levelInfos!;
}
