class LevelInfo {
  const LevelInfo({
    required this.id,
    required this.imageAssets,
    required this.name,
    required this.size,
    required this.starCountTimes,
    this.starsCount = 3,
  });

  final String imageAssets;
  final String id;
  final String name;
  final int size;
  final int starsCount;
  final List<Duration> starCountTimes;

  List<String> get squareImageAssets {
    final res = <String>[];
    final dirPath = imageAssets.substring(0, imageAssets.length - 4);
    final len = size * size;
    for (int i = 0; i < len; i++) {
      res.add('$dirPath/$i.png');
    }
    return res;
  }
}
