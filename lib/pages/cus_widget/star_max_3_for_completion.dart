import 'package:flutter/material.dart';

class StarMax3ForCompletion extends StatefulWidget {
  const StarMax3ForCompletion({super.key, required this.starCount,  this.size = 46.0});

  final int starCount;
  final double size;

  @override
  State<StarMax3ForCompletion> createState() => _StarMax3ForCompletionState();
}

class _StarMax3ForCompletionState extends State<StarMax3ForCompletion> {
  int i = 0;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() => i += 1);
    if (i < widget.starCount) {
      _next();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 17,
      children: [
        Transform.rotate(
          angle: 1,
          child: Image.asset(height: widget.size, width: widget.size, i > 0 ? 'assets/images/star_s.png' : 'assets/images/star_d.png'),
        ),

        Transform.translate(
          offset: Offset(0.0, -3.0),
          child:
              i > 1
                  ? TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.5, end: 1.0),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    builder: (BuildContext context, double? value, Widget? child) => Transform.scale(scale: value, child: child!),
                    child: Image.asset(height: widget.size, width: widget.size, 'assets/images/star_s.png'),
                  )
                  : Image.asset(height: widget.size, 'assets/images/star_d.png'),
        ),

        Transform.rotate(
          angle: -1,
          child:
              i > 2
                  ? TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.5, end: 1.0),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutBack,
                    builder: (BuildContext context, double? value, Widget? child) => Transform.scale(scale: value, child: child!),
                    child: Image.asset(height: widget.size, width: widget.size, 'assets/images/star_s.png'),
                  )
                  : Image.asset(height: widget.size, 'assets/images/star_d.png'),
        ),
      ],
    );
  }
}
//
// void main() {
//   runApp(MaterialApp(home: HomePage()));
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int count = 3;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () => setState(() => count--)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             StarMax3ForCompletion(key: Key('$count'), starCount: count, size: 100),
//             ElevatedButton(
//               onPressed: () => setState(() => count++),
//               child: SizedBox(width: 120, height: 30, child: Center(child: Text('+'))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
