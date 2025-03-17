import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';

class DBTools {
  static SharedPreferences? _sharedPreferences;
  static const String _levelDataListKey = '_levelDataListKey';

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  final List<LevelData> levelDataList;

  DBTools._(this.levelDataList);

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
        levelDataList.map((data) => jsonEncode(data.toJson())).toList();
    _sharedPreferences!.setStringList(_levelDataListKey, jsonStringList);
  }
}
