import 'package:flutter/material.dart';
import 'package:sliding_puzzle/tools/tools.dart';
import 'package:sliding_puzzle/cus_widget/cus_widget.dart';

class LevelListPage extends StatelessWidget {
  const LevelListPage({super.key, required this.pageController});

  final PageController pageController;

  void _onTap(BuildContext context, int index) {
    Future(() => pageController.jumpToPage(index));
    Navigator.of(context).pop(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 44, actions: [StarCount(count: DBTools.allStarCount)]),
      body: ListView.builder(
        itemCount: Levels.levelInfos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => _onTap(context, index),
            child: _ItemWidget(data: DBTools.getLevelDataByLeveId(Levels.levelInfos[index].id), levelInfo: Levels.levelInfos[index]),
          );
        },
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.levelInfo, this.data});

  final LevelInfo levelInfo;
  final LevelData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, left: 4, right: 4),
      decoration: BoxDecoration(
        // color: Color(0xFFFEFEFE),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // 圆角
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // 深棕色阴影
            blurRadius: 4, // 阴影模糊半径
            offset: Offset(1, 2), // 阴影偏移
          ),
        ],
      ),
      width: double.infinity,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 16),
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: .5),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child:
                      levelInfo.id <= DBTools.maxLevelId + 1
                          ? Image.asset(levelInfo.imageAssets)
                          : Icon(Icons.image_rounded, size: 100, color: Colors.grey),
                ),
              ),
              Positioned(
                right: -6,
                bottom: -6,
                child: Container(
                  width: 28,
                  height: 28,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 3, color: Colors.black12),
                    boxShadow: [
                      BoxShadow(color: _c[levelInfo.size]!, offset: Offset(1, 2), blurRadius: 3),
                      BoxShadow(color: Colors.white, offset: Offset(-1, -2), blurRadius: 1),
                    ],
                  ),
                  child: Image.asset('assets/images/num${levelInfo.size}.png'),
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 21,),
              StarMax3(data?.starCount, maxCount: levelInfo.starsCount, size: 27),
              SizedBox(height: 12,),
              Text(levelInfo.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
                shadows: [
                  Shadow(
                    color: Colors.grey,
                    offset: Offset(1.5,1.0),
                    blurRadius: 13
                  )
                ]
              ),),
            ],
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

final _c = {3: Colors.green.shade100, 4: Colors.blue.shade100, 5: Colors.red.shade100};
