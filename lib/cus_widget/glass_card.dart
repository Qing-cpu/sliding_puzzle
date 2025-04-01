import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    required this.radius,
    this.lightColor,
  });

  final Radius radius;

  final Widget child;
  final Color? lightColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1.5),
              borderRadius: BorderRadius.all(
                Radius.elliptical(radius.x + 1, radius.y + 1),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black12),
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          margin: EdgeInsets.all(1.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(radius),
            color: Colors.white12,
            border: Border.all(color: Colors.white54, width: 0.2),
          ),
          child: child,
        ),
      ],
    );
  }
}
