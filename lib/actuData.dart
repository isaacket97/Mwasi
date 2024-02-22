import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ActusNews extends StatefulWidget {
  final String link; // Ajoutez cette variable pour stocker le lien
  const ActusNews({Key? key, required this.link}) : super(key: key);

  @override
  _ActusNewsState createState() => _ActusNewsState();
}

class _ActusNewsState extends State<ActusNews> {
  late Stream<QuerySnapshot> _actusnewsStream;

  @override
  void initState() {
    super.initState();
    _actusnewsStream = FirebaseFirestore.instance
        .collection('Actus_News')
        .where('link', isEqualTo: widget.link) // Filtrer les enregistrements par le lien
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _actusnewsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final actusNewsList = snapshot.data!.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('ACTUS'),
            backgroundColor: Color(0xFFFD79A8), // Couleur de l'AppBar
          ),
          body: ListView(
            children: actusNewsList.map((actusNews) {
              final String date = actusNews['date'];
              final int likes = actusNews['likes'];
              final String link = actusNews['link'];
              final String name = actusNews['name'];
              final String poster = actusNews['poster'];
              final String text = actusNews['text'];

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      poster,
                      width: 600,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(text,
                          style: TextStyle(
                            fontSize: 17,),
                          textAlign: TextAlign.justify,
                          softWrap: true)),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse(link));
                        },
                        child: Text(
                          "Cliquez ici pour lire l'article sur le site oiginal",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                              fontSize: 15
                          ),
                        ),
                      ),)
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}



