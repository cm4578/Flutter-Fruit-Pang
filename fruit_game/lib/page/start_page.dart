import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fruit_game/config/global.dart';
import 'package:fruit_game/page/game_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {


  var isScale = false;
  var imageList = [
    'apple.png',
    'banana.png',
    'grape.png',
    'peach.png',
    'watermelon.png'
  ];

  List<Animation> fruitAnimList = [];
  late AnimationController controller;

  final nickNameCon = TextEditingController();
  String? errorString;

  late Animation<double> cloudyAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 1));
    fruitAnimList = List.generate(imageList.length, (index) {
      var begin = ((imageList.length - 1) - index) / imageList.length;
      print(begin);
      return Tween(begin: 0.0,end: 10.0).animate(CurvedAnimation(parent: controller, curve: Interval(begin, 1.0,curve: Curves.easeInToLinear)));
    });

    cloudyAnimation = Tween(begin: .0,end: 1.0).animate(controller);


    controller.repeat(reverse: true);
    controller.addListener(() {
      setState(() {});
    });
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      isScale = true;
      setState(() {});
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(alignment: Alignment.center,children: [
        Image.asset('assets/bg1.jpg',height: double.infinity,width: double.infinity,fit: BoxFit.cover,),
        Positioned(bottom: MediaQuery.of(context).size.height / 3,child: AnimatedScale(
          scale: isScale ? 1.1 : 1, duration: const Duration(seconds: 2),
          alignment: Alignment.center,
          curve: const Interval(.3, 1,curve: Curves.easeInOut),
          onEnd: () => setState(() { isScale = !isScale; }),child: Image.asset('assets/start.png',width: 400,),
        )),
        Positioned(left: 15 + (cloudyAnimation.value * 16),child: Image.asset('assets/cloud-2.png',width: 70,)),
        Positioned(right: 15 + (cloudyAnimation.value * 16),bottom: MediaQuery.of(context).size.height / 2.5,child: Image.asset('assets/cloud-2.png',width: 100,)),
        Positioned(right: 60 + ((1 - cloudyAnimation.value) * 16),bottom: MediaQuery.of(context).size.height / 2.5,child: Stack(children: [
          Opacity(opacity: .2,child: Image.asset('assets/download.png',width: 40,color: Colors.black,),),
          Image.asset('assets/cloud-1.png',width: 40,)
        ],)),

        Positioned(top: MediaQuery.of(context).size.height / 2,left: 0,right: 0,child: Column(mainAxisSize: MainAxisSize.min,children: [
          const SizedBox(height: 40,),
          GestureDetector(onTap: () {
            if (nickNameCon.text.isEmpty) {
              errorString = 'nick name field required';
              setState(() {});
              return;
            }
            Global.nickName = nickNameCon.text;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GamePage()));
          },child: Image.asset('assets/btn-start.png',width: 160,),),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(controller: nickNameCon,style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13
            ),onChanged: (value) {
              if (value.isEmpty) return;
              errorString = null;
              setState(() {});
            },decoration: InputDecoration(
              errorText: errorString,
              contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              hintText: 'NICKNAME',
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(999),borderSide: BorderSide(width: 0,color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999),borderSide: BorderSide(width: 0,color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999),borderSide: BorderSide(width: 0,color: Colors.transparent)),
            ),),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: List.generate(5, (index) {
              return Transform.translate(offset: Offset(0,fruitAnimList[index].value),child: Image.asset('assets/${imageList[index]}',height: 60,));
            }),),
          )
        ],))
      ],),
    );
  }
}
