import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruit_game/component/fruit_tile.dart';
import 'package:fruit_game/config/color_ext.dart';
import 'package:fruit_game/config/models.dart';
import '../config/enums.dart';
import '../config/global.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  List<List<Fruit>> dataList = [];

  var temp = <Fruit>[];
  var boardWidgetList = <FruitTile>[];
  var canSelect = false;

  Fruit? selectFruitData;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < Global.boardRowLen; ++i) {
      var dataSet = <Fruit>[];
      for (var j = 0; j < Global.boardRowLen; ++j) {
        var index = Random().nextInt(FruitType.values.length);
        dataSet.add(Fruit(UniqueKey().toString(), i, j, FruitType.values[index]));
      }
      dataList.add(dataSet);
    }
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await check();
      Global.initTimer(setState);
    });

    Global.count.addListener(() {
      if (Global.count.value >= Global.targetList[Global.stage]) {
        Global.stage += 1;
        setState(() {});
      }
    });

    Global.downCount.addListener(() {
      if (Global.downCount.value <= 0) {
        // 處理時間超過的問題
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fruit Pang',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            Text('Score: ${Global.count.value}',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(width: 15,),
            Text(Global.getTimeString(),style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(width: 15,),
            Text('Stage: ${Global.stage + 1}',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ],),
        ),
        Expanded(child: Center(
          child: RawKeyboardListener(onKey: (event) {
            if (selectFruit == null) return;
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                move(selectFruitData!.x,selectFruitData!.y,'u');
              }
              else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                move(selectFruitData!.x,selectFruitData!.y,'d');
              }
              else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                move(selectFruitData!.x,selectFruitData!.y,'l');
              }
              else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                move(selectFruitData!.x,selectFruitData!.y,'r');
              }
            }
          }, focusNode: FocusNode(), autofocus: true,
              child: Stack(
                children: [
                  Container(
                    width: Global.boardSize,
                    height: Global.boardSize,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: ColorExt.boardBgColor,
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Stack(children: [
                      Stack(
                        children: List.generate(Global.boardRowLen * Global.boardRowLen, (index) {
                          var row = index ~/ Global.boardRowLen;
                          var col = index % Global.boardRowLen;

                          return Positioned(
                            top: (getItemSize() + Global.boardPadding) * row,
                            left: (getItemSize() + Global.boardPadding) * col,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorExt.boardItemColor,
                              ),
                              width: getItemSize(),
                              height: getItemSize(),
                            ),
                          );
                        }),
                      ),
                      Stack(
                        children: List.generate(Global.boardRowLen * Global.boardRowLen, (index) {
                          var row = index ~/ Global.boardRowLen;
                          var col = index % Global.boardRowLen;

                          return AnimatedPositioned(
                            key: ValueKey(dataList[row][col].id),
                            curve: Curves.bounceOut,
                            duration: Global.stepAnimDuration,
                            top: (getItemSize() + Global.boardPadding) * dataList[row][col].y,
                            left: (getItemSize() + Global.boardPadding) * dataList[row][col].x,
                            child: FruitTile(itemSize: getItemSize(), dataSet: dataList[row][col], onTap: (controller) {
                              selectFruit(row, col);
                              selectFruitData = dataList[row][col];
                              setState(() {});

                            }),
                          );
                        }),
                      )
                    ],),)
                ],
              )),
        )),
      ],),
    );
  }

  double getItemSize() {
    // 調整每個容器的大小以考慮間距
    return ((Global.boardSize - 16) - (Global.boardPadding * (Global.boardRowLen - 1))) / Global.boardRowLen;
  }

  void move(int row,int col,String arrow,{bool isReverse = false}) {
    if (arrow == 'l' && row - 1 >= 0) {
      dataList[row][col].isSelect = false;
      swap(row,col,row -1,col,arrow,isReverse: isReverse);
    }
    if (arrow == 'r' && row + 1 <= Global.boardRowLen - 1) {
      dataList[row][col].isSelect = false;
      swap(row,col,row+1,col,arrow,isReverse: isReverse);
    }
    if (arrow == 'u' && col - 1 >= 0) {
      dataList[row][col].isSelect = false;
      swap(row, col, row, col - 1,arrow,isReverse: isReverse);
    }
    if (arrow == 'd' && col + 1 < Global.boardRowLen) {
      dataList[row][col].isSelect = false;
      swap(row, col, row, col+1,arrow,isReverse: isReverse);
    }
    setState(() {});
  }
  swap(int row,int col,int newRow,int newCol,String arrow,{bool isReverse = false}) async {
    var temp = dataList[row][col];
    var tempX = dataList[row][col].x;
    var tempY = dataList[row][col].y;
    dataList[row][col].x = dataList[newRow][newCol].x;
    dataList[newRow][newCol].x = tempX;

    dataList[row][col].y = dataList[newRow][newCol].y;
    dataList[newRow][newCol].y = tempY;

    dataList[row][col] = dataList[newRow][newCol];
    dataList[newRow][newCol] = temp;
    setState(() {});
    if (isReverse) return;
    await Future.delayed(Global.stepAnimDuration);
    for (var i = 0; i < dataList.length; ++i) {
      for (var j = 0; j < dataList[i].length; ++j) {
        findPang(i, j, dataList, [], '');
      }
    }
    if (dataList.expand((e) => e).every((e) => !e.isDismiss)) {
      move(row, col, arrow,isReverse: true);
      return;
    }
    check();
  }

  void findPang(int row, int col, List<List<Fruit>> board, List<Fruit> arr, String direction) {
    arr.add(board[row][col]);

    var directions = {
      'horizontal': [0, 1],
      'vertical': [1, 0]
    };

    bool isNext = false;

    // 遍歷方向
    if (direction == '') {
      directions.forEach((dir, offset) {
        int newRow = row + offset[0];
        int newCol = col + offset[1];
        if (newRow >= 0 && newRow < Global.boardRowLen && newCol >= 0 && newCol < Global.boardRowLen) {
          if (!board[newRow][newCol].isDismiss && board[newRow][newCol].fruitType == board[row][col].fruitType) {
            findPang(newRow, newCol, board, List.from(arr), dir);
            isNext = true;
          }
        }
      });
    } else {
      int newRow = row + directions[direction]![0];
      int newCol = col + directions[direction]![1];
      if (newRow >= 0 && newRow < Global.boardRowLen && newCol >= 0 && newCol < Global.boardRowLen) {
        if (!board[newRow][newCol].isDismiss && board[newRow][newCol].fruitType == board[row][col].fruitType) {
          findPang(newRow, newCol, board, List.from(arr), direction);
          isNext = true;
        }
      }
    }

    if (!isNext && arr.length >= 3) {
      for (var fruit in arr) {
        fruit.isDismiss = true;
      }
    }
  }

  Future check() async {
    canSelect = false;
    for (var row = 0; row < Global.boardRowLen; ++row) {
      for (var col = 0; col < Global.boardRowLen; ++col) {
        dataList[row][col].isDismiss = false;
      }
    }
    for (var row = 0; row < Global.boardRowLen; ++row) {
      for (var col = 0; col < Global.boardRowLen; ++col) {
        findPang(row, col, dataList, [], '');
      }
    }

    if (dataList.expand((e) => e).map((e) => e.isDismiss).every((e) => !e)) {
      canSelect = true;
      return;
    }

    await Future.delayed(Global.dismissAnimDuration);
    for (var row = 0; row < Global.boardRowLen; ++row) {
      for (var col = 0; col < Global.boardRowLen; ++col) {
        if (dataList[row][col].isDismiss) {
          for (var k = 0; k < col; k++) {
            dataList[row][k].y += 1;
          }
        }
      }
    }
    setState(() {});
    await Future.delayed(Global.stepAnimDuration);

    int score = 0;
    for (var e in dataList) {
      score += e.where((e) => e.isDismiss).length;
      e.removeWhere((e1) => e1.isDismiss);
    }
    Global.count.value += score;

    for (var row = 0; row < Global.boardRowLen; ++row) {
      int missingCount = Global.boardRowLen - dataList[row].length;
      for (var col = 0; col < missingCount; ++col) {
        dataList[row].insert(0, Fruit(UniqueKey().toString(), row, -1 + -col, FruitType.values[Random().nextInt(FruitType.values.length)]));
      }
    }
    setState(() {});
    await Future.delayed(Duration(milliseconds: 300));
    for (var row = 0; row < Global.boardRowLen; ++row) {
      for (var col = 0; col < dataList[row].length; ++col) {
        dataList[row][col].y = col;
      }
    }
    setState(() {});
    await Future.delayed(Global.dismissAnimDuration);
    check();
  }
  void selectFruit(int row, int col) {
    for (var i = 0; i < Global.boardRowLen; ++i) {
      for (var j = 0; j < Global.boardRowLen; ++j) {
        dataList[i][j].isSelect = false;
      }
    }
    dataList[row][col].isSelect = true;
  }
}


class Position {
  late double left;
  late double top;

  Position({required this.left, required this.top});

}
