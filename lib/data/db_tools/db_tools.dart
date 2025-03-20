import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';

class DBTools {
  static dynamic _sharedPreferences;
  static const String _levelDataListKey = '_levelDataListKey';

  static init() async {
    if (Platform.isAndroid) {
      _sharedPreferences = SharedPreferencesAsync();
      _sharedPreferences!
          .getStringList(_levelDataListKey)
          .then(
            (List<String>? levelDataJsonStringList) =>
                _levelDataList = jsonStringListToLeveDataList(
                  levelDataJsonStringList,
                ),
          );
    } else if (Platform.isIOS) {
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();
      final List<String>? levelDataJsonStringList = _sharedPreferences
          .getStringList(_levelDataListKey);
      _levelDataList = jsonStringListToLeveDataList(levelDataJsonStringList);
    }
  }

  static List<LevelData> jsonStringListToLeveDataList(
    List<String>? jsonString,
  ) {
    return jsonString
            ?.map<LevelData>(
              (jsonString) => LevelData.fromJson(jsonDecode(jsonString)),
            )
            .toList() ??
        [];
  }

  static late final List<LevelData> _levelDataList;

  static get sharedPreferences {
    if (Platform.isAndroid) {
      return (_sharedPreferences as SharedPreferencesAsync);
    } else {
      return (_sharedPreferences as SharedPreferences);
    }
  }

  static upData() {
    final List<String> jsonStringList =
        _levelDataList.map((data) => jsonEncode(data.toJson())).toList();
    sharedPreferences!.setStringList(_levelDataListKey, jsonStringList);
  }

  static void setLevelDataByLevelId(
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

  static void setLevelDataByLeveData(LevelData data) {
    final int dataIndex = _levelDataList.indexWhere(
      (d) => d.levelId == data.levelId,
    );
    if (dataIndex == -1) {
      _levelDataList.add(data);
      upData();
      return;
    }
    if (_levelDataList[dataIndex].isChanged(data)) {
      _levelDataList.removeAt(dataIndex);
      _levelDataList.add(data);
      upData();
      return;
    }
  }

  static LevelData? getLevelDataByLeveId(String id) {
    final i = _levelDataList.indexWhere((e) => e.levelId == id);
    return i == -1 ? null : _levelDataList[i];
  }
}
