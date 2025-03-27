import 'package:flutter/material.dart';

class StarCount extends StatelessWidget {
  const StarCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      height: 45,
      child: Row(
        children: [
          Image.asset('assets/images/star_s.png'),
          Text(
            'X$count',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black87, blurRadius: 5, offset: Offset(0.5, 1))],
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
