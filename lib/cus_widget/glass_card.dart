import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    required this.radius,
    this.lightColor,
    this.colorB1 = Colors.white12,
    this.colorT1 = Colors.white12,
  });

  final Radius radius;

  final Widget child;
  final Color? lightColor;
  final Color colorB1;
  final Color colorT1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
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
                child: Container(color: colorB1),
              ),
            ),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(1.3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(radius),
              color: colorT1,
              border: Border.all(color: Colors.white54, width: 0.2),
              boxShadow: [
                if (lightColor != null)
                  BoxShadow(
                    blurRadius: 30,
                    offset: Offset(2, 2),
                    color: lightColor!,
                  ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
