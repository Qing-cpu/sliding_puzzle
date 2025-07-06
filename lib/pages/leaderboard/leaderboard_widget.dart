
class GameData {
  int progress;
  String weapon;

  GameData(this.progress, this.weapon);

  factory GameData.fromJson(Map json) {
    return GameData(json["progress"], json["weapon"]);
  }

  Map toJson() => {'progress': progress, 'weapon': weapon};
}
