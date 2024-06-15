import 'package:flutter/material.dart';
import 'package:fruit_game/page/start_page.dart';

import '../config/global.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center,children: [
        Image.asset('assets/bg3.jpg',width: double.infinity,height: double.infinity,alignment: Alignment.bottomLeft,fit: BoxFit.cover,),
        Stack(children: [
          Image.asset('assets/result.png',width: 500,height: 500,fit: BoxFit.cover,),
          Positioned(left: 0,right: 0,top: 500 / 1.76,child: Row(children: [
            Expanded(flex: 5,child: SizedBox()),
            Text(Global.nickName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            Expanded(flex: 4,child: SizedBox()),
          ],)),
          Positioned(right: 0,left: 0,top: 500 / 1.57,child: Row(children: [
            Expanded(flex: 5,child: SizedBox()),
            Text(Global.count.value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            Expanded(flex: 4,child: SizedBox()),
          ],)),
          Positioned(right: 0,left: 0,top: 500 / 1.42,child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Expanded(flex: 5,child: SizedBox()),
            Text(Global.getTimeString(Global.countTime),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            Expanded(flex: 4,child: SizedBox()),
          ],)),
          Positioned(bottom: MediaQuery.of(context).size.width / 9,left: 0,right: 0,child: GestureDetector(onTap: () {
            Global.stage = 0;
            Global.count.value = 0;
            Global.downCount.value = 0;
            Global.countTime = 0;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartPage()));
          },child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Image.asset('assets/restart_game.png'),
          ),))
        ],)
      ],),
    );
  }
}
