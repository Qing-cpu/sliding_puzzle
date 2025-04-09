import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';
import 'package:sliding_puzzle/tools/db_tools/db_tools.dart';

import '../../cus_widget/glass_card.dart';

class SkyLadderPage extends StatefulWidget {
  const SkyLadderPage({super.key, required this.skyLadderCount});

  final int skyLadderCount;

  @override
  State<SkyLadderPage> createState() => _SkyLadderPageState();
}

class _SkyLadderPageState extends State<SkyLadderPage> with SingleTickerProviderStateMixin {
  late int skyLadderCount = widget.skyLadderCount;
  late final PageController _controller = PageController(initialPage: skyLadderCount - 1);

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 50),
  );

  void _onCompletedCallback() {
    _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    setState(() {
      skyLadderCount++;
    });
    DBTools.setSkyLadderCount(skyLadderCount);
  }

  @override
  void initState() {
    super.initState();
    _animationController.repeat(reverse: false);
  }

  final _colors2 = [
    const Color(0x00000000),
    const Color(0xe82bffd5),
    const Color(0x00000000),
    const Color(0xe800d0ff),
    const Color(0x00000000),
    // Color(0x00000000),
  ];

  final _colors = [
    const Color(0x00000000),
    const Color(0xe8ff1164),
    const Color(0x00000000),
    const Color(0xe8ff1616),
    const Color(0x00000000),
    // Color(0x00000000),
  ];

  late final animate = Tween<double>(begin: 0, end: 6.1).animate(_animationController);

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget bgC1(double r) => AnimatedBuilder(
    builder: (BuildContext context, Widget? child) {
      return AnimatedContainer(
        width: r,
        height: r,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 2000),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              _colors[animate.value.toInt() % _colors.length],
              _colors[(animate.value.toInt() + 1) % _colors.length],
              _colors[(animate.value.toInt() + 2) % _colors.length],
              _colors[(animate.value.toInt() + 3) % _colors.length],
              Color(0x00000000),
            ],
          ),
        ),
        child: child,
      );
    },
    animation: _animationController,
  );

  Widget bgC2(double r) => AnimatedBuilder(
    builder: (BuildContext context, Widget? child) {
      return AnimatedContainer(
        width: r,
        height: r,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 2000),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              _colors2[animate.value.toInt() % _colors.length],
              _colors2[(animate.value.toInt() + 1) % _colors.length],
              _colors2[(animate.value.toInt() + 2) % _colors.length],
              _colors2[(animate.value.toInt() + 3) % _colors.length],
              Color(0x00000000),
            ],
          ),
        ),
        child: child,
      );
    },
    animation: _animationController,
  );

  double diagonal(double width, double height) {
    return math.sqrt(width * width + height * height);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xe80d003a), Color(0xff000000), Color(0xFF240039)],
          ),
        ),
        child: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            final x = size.width;
            final y = size.height;
            final double r = diagonal(x, y);
            return Stack(
              children: [
                Positioned(
                  top: -y / 4,
                  left: -x / 4,
                  child: Container(alignment: Alignment.center, child: bgC2(r * 0.5)),
                ),
                Positioned(
                  bottom: -y / 2,
                  right: -x / 2,
                  child: Container(alignment: Alignment.center, child: bgC1(r)),
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 100,
                      color: Colors.black38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back),
                            color: Colors.white38,
                          ),
                          Score(
                            score: skyLadderCount,
                            textStyle: TextStyle(
                              color: Color(0xCBFFFFFF),
                              fontSize: 60,
                              shadows: [
                                Shadow(
                                  color: Colors.greenAccent,
                                  blurRadius: 40,
                                  offset: Offset(1, 1),
                                ),
                              ],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Opacity(
                            opacity: 0,
                            child: IconButton(onPressed: null, icon: Icon(Icons.arrow_back)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        itemCount: 100,
                        itemBuilder:
                            (BuildContext context, int index) => PageViewItemWidget(
                              size: index ~/ 10 + 3,
                              onCompletedCallback: _onCompletedCallback,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PageViewItemWidget extends StatefulWidget {
  const PageViewItemWidget({super.key, required this.size, required this.onCompletedCallback});

  final int size;

  final VoidCallback onCompletedCallback;

  @override
  State<PageViewItemWidget> createState() => _PageViewItemWidgetState();
}

class _PageViewItemWidgetState extends State<PageViewItemWidget> {
  late final SlidingPuzzleController _slidingPuzzleController = SlidingPuzzleController(
    buildSquareWidget: buildNumWidget,
    onCompletedCallback: widget.onCompletedCallback,
    onStart: () {},
    width: 300,
    size: widget.size,
  )..s.value = 0;

  @override
  void dispose() {
    _slidingPuzzleController.dispose();
    super.dispose(); //
  }

  Widget buildNumWidget({required int num, bool? isOk, bool? hasTweenColor}) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 1),
      tween: ColorTween(begin: Color(0x00ff0000), end: Color(0x3D404040)),
      builder:
          (BuildContext context, Color? value, Widget? child) => Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: value,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12, width: 1.3),
            ),
            child: child,
          ),
      child: LayoutBuilder(
        builder: (context, c) {
          final fontSize = num > 99 ? c.maxWidth / 3 : c.maxWidth / 2;
          return Text(
            '$num',
            textAlign: TextAlign.center,
            style: TextStyle(
              shadows: [
                Shadow(
                  color: isOk ?? false ? Color(0xF5FF4470) : Colors.black87,
                  offset: Offset(1, 1),
                  blurRadius: 16,
                ),
              ],
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      sigma: 16,
      colorB1: Colors.black12,
      // colorB1: Color(0x00000000),
      colorT1: Color(0x0fffffff),
      radius: Radius.circular(16),
      child: Container(
        padding: EdgeInsets.all(12), // 内边距
        child: Builder(
          builder: (context) {
            final dw = MediaQuery.of(context).size.width;
            final dy = MediaQuery.of(context).size.height;
            double size = 288;
            if (dw > 600 && dy > 900) {
              size = 550;
            }
            return SlidingPuzzle(
              width: size,
              height: size,
              slidingPuzzleController: _slidingPuzzleController,
            );
          },
        ),
      ),
    );
  }
}
