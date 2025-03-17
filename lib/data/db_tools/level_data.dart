import 'package:json_annotation/json_annotation.dart';

part 'level_data.g.dart';

@JsonSerializable()
class LevelData {
  LevelData(this.levelId, this.starCount, this.timeMil, this.isPerfect);

  @JsonKey(required: true)
  final String levelId;
  @JsonKey(required: true)
  int starCount;
  @JsonKey(required: true)
  int timeMil;
  @JsonKey(required: true)
  bool isPerfect;

  // LevelData(this.levelId, this.starCount, this.timeMil, this.isPerfect);

  factory LevelData.fromJson(Map<String, dynamic> json) =>
      _$LevelDataFromJson(json);

  Map<String, dynamic> toJson() => _$LevelDataToJson(this);
}


