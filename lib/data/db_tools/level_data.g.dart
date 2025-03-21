// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelData _$LevelDataFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['levelId', 'starCount', 'timeMil', 'isPerfect'],
  );
  return LevelData(
    (json['levelId'] as num).toInt(),
    (json['starCount'] as num).toInt(),
    (json['timeMil'] as num).toInt(),
    json['isPerfect'] as bool,
  );
}

Map<String, dynamic> _$LevelDataToJson(LevelData instance) => <String, dynamic>{
  'levelId': instance.levelId,
  'starCount': instance.starCount,
  'timeMil': instance.timeMil,
  'isPerfect': instance.isPerfect,
};
