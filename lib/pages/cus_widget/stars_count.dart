import 'package:flutter/material.dart';

class StarsCount extends StatelessWidget {
  const StarsCount(this.hasCount, {super.key,this.maxCount = 3,this.size = 46});

  final int? hasCount;

  final int maxCount;

  final double size;

  int get _count => hasCount ?? 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 17,
        children: List.generate(
          3,
              (i) => AnimatedSwitcher(
            duration: Duration(milliseconds: 72),
            child: Container(
              key: Key('${i < _count}'),
              padding: const EdgeInsets.all(4),
              margin: EdgeInsets.only(bottom: i == 1 ? 12 : 0),
              decoration: BoxDecoration(
                color:
                i < _count ? Colors.redAccent.shade200 : Color(0xFFFFE4E1),
                borderRadius: BorderRadius.circular(57),
                boxShadow: [
                  if (i < _count)
                    BoxShadow(
                      color: Colors.grey, // 阴影颜色及透明度
                      spreadRadius: 1.0, // 扩散范围
                      blurRadius: 3.0, // 模糊程度
                      offset: Offset(2, 4), // 阴影偏移 (x, y)
                    ),
                  if (i < _count)
                    BoxShadow(
                      color: Colors.pinkAccent.shade100, // 阴影颜色及透明度
                      spreadRadius: 1.0, // 扩散范围
                      blurRadius: 2.0, // 模糊程度
                      offset: Offset(-1, -1), // 阴影偏移 (x, y)
                    ),
                ],
              ),
              child: Icon(
                color: i < _count ? Colors.yellow.shade400 : Color(0xFFE4CBC8),
                size: size,
                Icons.star_sharp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelSizePoint extends StatelessWidget {
  final double size;
  final int count;

  const LevelSizePoint({super.key, this.size = 5, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: List<Widget>.generate(
        count,
            (_) => CircleAvatar(
          radius: size, // 半径
          backgroundColor: Color(0xFF8F8F8F),
        ),
      ),
    );
  }
}
