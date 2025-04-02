import 'package:flutter/material.dart';
import 'package:sliding_puzzle/cus_widget/glass_card.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.count, this.overCallback});

  final int count;

  final void Function()? overCallback;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int count = widget.count;

  _setCount() async {
    if (count > 0) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        --count;
      });
      if (count == 0) {
        widget.overCallback?.call();
        return;
      }
      _setCount();
    }
  }

  @override
  void initState() {
    super.initState();
    _setCount();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x00000000),
      child: GlassCard(
        radius: Radius.circular(17),
        child: SizedBox(
          width: 80,
          height: 80,
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                color: Color(0xfffffffa),
                fontSize: 50,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
