import 'package:flutter/material.dart';
import 'package:sliding_puzzle/data/db_tools/db_tools.dart';

class StarCount extends StatelessWidget {
  const StarCount({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      height: 45,
      child: Row(
        children: [
          Image.asset('assets/images/star_s.png'),
          Text(
            'X${DBTools.allStarCount}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 5,
                  offset: Offset(0.5,1),
                ),
              ],
            ),
          ),
          SizedBox(width: 12,),


        ],
      ),
    );
  }
}
//
// void main() {
//   DBTools.init([
//     LevelData('1-1', 3, 3000, false),
//     LevelData('1-2', 2, 66000, false),
//     LevelData('1-2', 1, 140000, false),
//   ]);
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             children: [
//               Row(children: [StarCount(), Expanded(child: SizedBox())]),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
