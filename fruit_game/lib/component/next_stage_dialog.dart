import 'package:flutter/material.dart';

import '../config/global.dart';

class NextStageDialog extends StatefulWidget {
  const NextStageDialog({Key? key}) : super(key: key);

  @override
  State<NextStageDialog> createState() => _NextStageDialogState();
}

class _NextStageDialogState extends State<NextStageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text('stage clear!'.toUpperCase()),actions: [
      TextButton(onPressed: () {
        Global.initTimer(setState);
        Navigator.pop(context);
      }, child: const Text('NEXT STAGE'))
    ],);
  }
}
