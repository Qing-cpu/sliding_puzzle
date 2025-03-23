import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_puzzle/data/db_tools/level_data.dart';

class DBTools {
  static dynamic _sharedPreferences;
  static const String _levelDataListKey = '_levelDataListKey';
  static late final List<LevelData> _levelDataList;
  static int _maxLevelId = 0;

  static int get allStarCount => _levelDataList.fold(
    0,
    (previousValue, element) => previousValue + element.starCount,
  );

  static int get maxLevelId {
    if (_maxLevelId == 0) {
      _maxLevelId = _levelDataList.fold(
        0,
        (p, d) => d.levelId > p ? d.levelId : p,
      );
    }
    return _maxLevelId;
  }

  static set maxLevelId(int value) {
    if (value > maxLevelId) {
      _maxLevelId = value;
    }
  }

  static void upMaxLevelId(LevelData data) {
    maxLevelId = data.levelId;
  }

  static init(List<LevelData>? list) async {
    if (list != null) {
      _levelDataList = list;
      return;
    }
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

  static void setLevelDataByLeveData(LevelData data) {
    upMaxLevelId(data);
    final int dataIndex = _levelDataList.indexWhere(
      (d) => d.levelId == data.levelId,
    );
    if (dataIndex == -1) {
      _levelDataList.add(data);
      upData();
      return;
    } else if (_levelDataList[dataIndex].isChanged(data)) {
      _levelDataList.removeAt(dataIndex);
      _levelDataList.add(data);
      upData();
      return;
    }
  }

  static LevelData? getLevelDataByLeveId(int id) {
    final i = _levelDataList.indexWhere((e) => e.levelId == id);
    return i == -1 ? null : _levelDataList[i];
  }
}
