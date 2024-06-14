import 'package:flutter/material.dart';
import 'package:fruit_game/config/models.dart';

import '../config/enums.dart';
import '../config/global.dart';

class FruitTile extends StatefulWidget {
  const FruitTile({Key? key,required this.itemSize ,required this.dataSet, required this.onTap}) : super(key: key);

  final Fruit dataSet;
  final double itemSize;
  final Function(AnimationController) onTap;


  @override
  State<FruitTile> createState() => _FruitTileState();
}

class _FruitTileState extends State<FruitTile> with SingleTickerProviderStateMixin {

  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {});
    });
  }
  @override
  void didUpdateWidget(covariant FruitTile oldWidget) {
    // if (!widget.dataSet.isSelect) {
    //   _controller.stop();
    //   _controller.reset();
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var animation = Tween(begin: 1.0,end: 0.5).animate(_controller);
    return GestureDetector(onTap: () {
      widget.onTap(_controller);
    },child: Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      width: widget.itemSize,
      height: widget.itemSize,
      child: AnimatedOpacity(opacity: widget.dataSet.isSelect ? 0.7 : 1,duration: Duration(milliseconds: 300),child: _buildDismissWidget(child: Image.asset('assets/${getImage(widget.dataSet.fruitType)}')),),
    ),);
  }

  Widget _buildDismissWidget({required Widget child}) {
    return AnimatedScale(
      scale: widget.dataSet.isDismiss ? 2 : 1, duration: Global.dismissAnimDuration,child: AnimatedOpacity(
      opacity: widget.dataSet.isDismiss ? 0.0 : 1.0, duration: Global.dismissAnimDuration,child: child,
      ),
    );
  }

  String getImage(FruitType fruitType) {
    switch (fruitType) {
      case FruitType.apple:
        return 'fruit-apple.png';
      case FruitType.banana:
        return 'fruit-banana.png';
      case FruitType.grape:
        return 'fruit-grape.png';
      case FruitType.peach:
        return 'fruit-peach.png';
      case FruitType.watermelon:
        return 'fruit-watermelon.png';
    }
  }
}
