import 'package:flutter/material.dart';

class PhotoFrame extends StatelessWidget {
  const PhotoFrame({super.key, required this.image, this.size  = 160});

  final Image image;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.black54, width: 2),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Color(0x45000000),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(5, 5), // 偏移量 (x, y)
          ),
          BoxShadow(
            color: Color(0x45000000),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(3, 3), // 偏移量 (x, y)
          ),
        ],
      ),

      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: image,
      ),
    );
  }
}
