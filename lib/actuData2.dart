import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwasi_2/actuData.dart';

class ActusNews2 extends StatefulWidget {
  const ActusNews2({Key? key}) : super(key: key);

  @override
  _ActusNews2State createState() => _ActusNews2State();
}

class _ActusNews2State extends State<ActusNews2> {
  late Stream<QuerySnapshot> _actusnews2Stream;

  @override
  void initState() {
    super.initState();
    _actusnews2Stream = FirebaseFirestore.instance.collection('Actus_News').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _actusnews2Stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final actusNews2List = snapshot.data!.docs.map((document) => document.data() as Map<String, dynamic>).toList();

        return ListView(
          children: actusNews2List.map((actusNews) {
            final String date = actusNews['date'];
            final int likes = actusNews['likes'];
            final String link = actusNews['link'];
            final String name = actusNews['name'];
            final String poster = actusNews['poster'];
            final String text = actusNews['text'];

            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                builder: (context)=> ActusNews(link: link,)
                ));
              },
              child: Card(
                margin: EdgeInsets.all(8),
                elevation: 8,
                child: Expanded(
                  child: Row(
                    children: [
                      Image.network(poster,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(name,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                ),
                              ),
                              Text(date,
                              style: TextStyle(color: Colors.grey,fontSize: 12),softWrap: true)
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
