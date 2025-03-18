import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';

class DBTools {
  static SharedPreferences? _sharedPreferences;
  static const String _levelDataListKey = '_levelDataListKey';

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  final List<LevelData> _levelDataList;

  DBTools._(this._levelDataList);

  factory DBTools.getInstance() {
    final List<LevelData> res = [];
    final List<String>? levelDataJsonStringList = _sharedPreferences!
        .getStringList(_levelDataListKey);
    if (levelDataJsonStringList == null) {
      return DBTools._(res);
    }
    levelDataJsonStringList.map(
      (jsonString) => LevelData.fromJson(jsonDecode(jsonString)),
    );

    return DBTools._(res);
  }

  upData() {
    final List<String> jsonStringList =
        _levelDataList.map((data) => jsonEncode(data.toJson())).toList();
    _sharedPreferences!.setStringList(_levelDataListKey, jsonStringList);
  }

  void setLevelDataByLevelId(
    String levelId, {
    int? starCount,
    int? timeMil,
    bool isPerfect = false,
  }) {
    final int dataIndex = _levelDataList.indexWhere(
      (d) => d.levelId == levelId,
    );
    if (dataIndex != -1) {
      final data = _levelDataList[dataIndex];
      data.isPerfect = isPerfect;
      data.timeMil = timeMil ?? data.timeMil;
      data.starCount = starCount ?? data.starCount;
    } else {
      final data = LevelData(levelId, starCount!, timeMil!, isPerfect);
      _levelDataList.add(data);
    }
    upData();
  }

  void setLevelDataByLeveData(LevelData data) {
    setLevelDataByLevelId(
      data.levelId,
      starCount: data.starCount,
      timeMil: data.starCount,
      isPerfect: data.isPerfect,
    );
  }

  LevelData? getLevelDataByLeveId(String id) {
    final i = _levelDataList.indexWhere((e) => e.levelId == id);
    return i == -1 ? null : _levelDataList[i];
  }
}
