import 'package:flutter/material.dart';

class StarMax3 extends StatelessWidget {
  const StarMax3(this.hasCount, {super.key, this.maxCount = 3, this.size = 46});

  final int? hasCount;

  final int maxCount;

  final double size;

  int get _count => hasCount ?? 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 17,
      children: [
        Transform.rotate(
          angle: 1,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Image.asset(
              height: size,
              width: size,
              key: Key('${0 < _count}'),
              0 < _count ? 'assets/images/star_s.png' : 'assets/images/star_d.png',
            ),
          ),
        ),

        Transform.translate(
          offset: Offset(0.0, -3.0),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Image.asset(
              height: size,
              width: size,
              key: Key('${1 < _count}'),
              1 < _count ? 'assets/images/star_s.png' : 'assets/images/star_d.png',
            ),
          ),
        ),

        Transform.rotate(
          angle: -1,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Image.asset(
              height: size,
              width: size,
              key: Key('${2 < _count}'),
              2 < _count ? 'assets/images/star_s.png' : 'assets/images/star_d.png',
            ),
          ),
        ),
      ],
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
