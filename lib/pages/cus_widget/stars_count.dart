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
            duration: Duration(milliseconds: 300),
            child:
            Image.asset(
              height: size,
                width: size,
                key: Key('${i < _count}'),
                i < _count ? 'assets/images/star_s.png' : 'assets/images/star_d.png'),
            // Icon(
            //   color: i < _count ? Colors.yellow.shade400 : Color(0xFFE4CBC8),
            //   size: size,
            //   Icons.star_sharp,
            // ),
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
