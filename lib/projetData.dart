import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Projects extends StatefulWidget {
  final String id; // Ajoutez cette variable pour stocker le lien
  const Projects({Key? key, required this.id}) : super(key: key);

  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late Stream<QuerySnapshot> _ProjectsStream;

  @override
  void initState() {
    super.initState();
    _ProjectsStream = FirebaseFirestore.instance
        .collection('Projects')
        .where('name', isEqualTo: widget.id) // Filtrer les enregistrements par le lien
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _ProjectsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        final ProjectsList = snapshot.data!.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('PROJETS'),
            backgroundColor: Color(0xFFFD79A8), // Couleur de l'AppBar
          ),
          body: ListView(
            children: ProjectsList.map((Projects) {
              final String date = Projects['date'];
              final String email = Projects['email'];
              final String name = Projects['name'];
              final String poster = Projects['poster'];
              final String text = Projects['text'];
              final String owner = Projects['owner'];

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
                      child: Text("Ce projet est une idée de réalisation de : "+owner,
                          style: TextStyle(
                            fontSize: 17,),
                          textAlign: TextAlign.justify,
                          softWrap: true)),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Text("Vous pouvez contacter l'auteur de cette idée de projet à l'adresse email suivante : "+email,
                          style: TextStyle(
                            fontSize: 17,),
                          textAlign: TextAlign.justify,
                          softWrap: true))
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}