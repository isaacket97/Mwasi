import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwasi_2/projetData.dart';

class Projects2 extends StatefulWidget {
  const Projects2({Key? key}) : super(key: key);

  @override
  _Projects2State createState() => _Projects2State();
}

class _Projects2State extends State<Projects2> {
  late Stream<QuerySnapshot> _Projects2Stream;

  @override
  void initState() {
    super.initState();
    _Projects2Stream = FirebaseFirestore.instance.collection('Projects').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _Projects2Stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final Projects2List = snapshot.data!.docs.map((document) => document.data() as Map<String, dynamic>).toList();

        return ListView(
          children: Projects2List.map((projects) {
            final String date = projects['date'];
            final String email = projects['email'];
            final String name = projects['name'];
            final String poster = projects['poster'];
            final String text = projects['text'];

            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> Projects(id: name)
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
