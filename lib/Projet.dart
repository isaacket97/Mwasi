import 'package:flutter/material.dart';
import 'package:mwasi_2/PublicationFunction.dart';
import 'package:mwasi_2/projetData2.dart';

class PROJET extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROJET',
                    style:
                    TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          TextButton(
            onPressed: () {
              showPopupDialog(context);
            },
            child: Text(
              'Publier',
              style: TextStyle(color: Color(0xFFFD79A8),
                fontSize: 17),
            ),
          ),
        ],
      ),
      body: Center(
        child: Projects2(),
      ),
    );
  }
}
