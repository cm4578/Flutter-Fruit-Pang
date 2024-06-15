import 'dart:async';

import 'package:flutter/cupertino.dart';

class Global {
  static var boardRowLen = 8;
  static var boardSize = 400.0;
  static var boardPadding = 5;

  static var dismissAnimDuration = Duration(milliseconds: 500);
  static var stepAnimDuration = Duration(milliseconds: 800);


  static Timer? timer;
  static var downCount = ValueNotifier(0);
  static var countTime = 0;
  static var nickName = '';

  static var stageTimeLimit = <Duration>[
    Duration(minutes: 2),
    Duration(minutes: 1, seconds: 30),
    Duration(minutes: 1),
    Duration(seconds: 30),
    Duration(seconds: 30),
  ];
  static var targetList = <int>[
    1000,
    1500,
    2000,
    2500,
    3000,
  ];

  static var stage = 0;
  static var count = ValueNotifier(0);
  static var scoreStep = 50;


  static String getTimeString(int count) {
    var min = (count ~/ 60).toString().padLeft(2,'0');
    var sec = (count % 60).toString().padLeft(2,'0');
    return '$min:$sec';
  }

  static initTimer(StateSetter setState) {
    Global.downCount.value = Global.stageTimeLimit[Global.stage].inSeconds;
    Global.timer?.cancel();
    setState((){});
    Global.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Global.downCount.value <= 0) {
        Global.timer?.cancel();
        return;
      }
      countTime += 1;
      Global.downCount.value -= 1;
      setState((){});
    });
  }
}
