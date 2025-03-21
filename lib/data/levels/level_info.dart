class LevelInfo {
  const LevelInfo._({
    required this.imageAssets,
    required this.name,
    required this.size,
    required this.starCountTimes,
    required this.id,
    this.starsCount = 3,
  });

  factory LevelInfo({
    required String imageAssets,
    required String name,
    required int size,
    required List<Duration> starCountTimes,
    int starsCount = 3,
  }) {
    return LevelInfo._(
      imageAssets: imageAssets,
      name: name,
      size: size,
      starCountTimes: starCountTimes,
      id: _newId,
      starsCount: starsCount,
    );
  }

  static int _count = 0;

  static int get _newId => _count++;

  final String imageAssets;
  final int id;
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

  int calculateStarRating(int dMil) {
    int res = 0;
    for (final d in starCountTimes) {
      if (d.inMilliseconds > dMil) {
        res++;
      }
    }
    return res;
  }

  @override
  String toString() {
    return 'LevelInfo:    (imageAssets: $imageAssets,id: $id,name: $name,size: $size,starsCount: $starsCount)';
  }
}
