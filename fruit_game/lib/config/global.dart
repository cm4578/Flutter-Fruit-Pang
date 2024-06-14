import 'dart:async';

import 'package:flutter/cupertino.dart';

class Global {
  static var boardRowLen = 8;
  static var boardSize = 400.0;
  static var boardPadding = 5;

  static var dismissAnimDuration = Duration(milliseconds: 600);
  static var stepAnimDuration = Duration(milliseconds: 900);


  static late Timer timer;
  static var downCount = ValueNotifier(0);

  static var stageTimeLimit = <Duration>[
    Duration(minutes: 5),
    Duration(minutes: 4, seconds: 30),
    Duration(minutes: 4),
    Duration(minutes: 3, seconds: 30),
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


  static String getTimeString() {
    var min = (Global.downCount.value ~/ 60).toString().padLeft(2,'0');
    var sec = (Global.downCount.value % 60).toString().padLeft(2,'0');
    return '$min:$sec';
  }

  static initTimer(StateSetter setState) {
    Global.downCount.value = Global.stageTimeLimit[Global.stage].inSeconds;
    Global.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Global.downCount.value <= 0) {
        Global.timer.cancel();
        return;
      }
      Global.downCount.value -= 1;
      setState((){});
    });
  }
}
