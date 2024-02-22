import 'package:flutter/material.dart';
import 'package:mwasi_2/actuData2.dart';

class ACTU extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ACTUS",
                      style:
                      TextStyle(fontWeight: FontWeight.bold,),
      ),),
      body: Center(
        child: ActusNews2(),
      ),
    );
  }
}

