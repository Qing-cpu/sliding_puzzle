import 'package:flutter/material.dart';

class StartBox extends StatefulWidget {
  const StartBox({
    super.key,
    required this.child,
    required this.height,
    required this.width,
    required this.onTap,
  });

  final double height;
  final double width;

  final Widget child;

  final void Function()? onTap;

  @override
  State<StartBox> createState() => _StartBoxState();
}

class _StartBoxState extends State<StartBox> {
  bool isTapStart = false;

  onTap() {
    setState(() {
      isTapStart = true;
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.child,
              Positioned(
                top: 83,
                left: 87,
                right: 76,
                bottom: 79,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 32),
                  child:
                      isTapStart
                          ? null
                          : Image.asset(
                            'assets/images/start_button_image_s.png',
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
