import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user.dart';
import 'discussion_page.dart';

class CHAT extends StatefulWidget {
  @override
  _CHATState createState() => _CHATState();
}

class _CHATState extends State<CHAT> {
  List<CUser> searchResults = [];

  void navigateToDiscussionPage(CUser? selectedUser) {
    if (selectedUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiscussionPage(user: selectedUser),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              onChanged: (value) {
                // Gérer les changements de la valeur de recherche ici
                // Vous pouvez appeler une méthode pour effectuer la recherche
                searchUsers(value); // Appel de la méthode de recherche
              },
            ),
          ),
          Expanded(
            child: Center(
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final user = searchResults[index];
                  return ListTile(
                    title: Text(user.email),
                    subtitle: Text(user.uid),
                    onTap: () {
                      if (user != null) {
                        navigateToDiscussionPage(user);
                      }
                    },
                  );
                },
              )
                  : Text('Aucun résultat de recherche'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> searchUsers(String query) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await usersRef
        .where('email', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('email', isLessThan: query.toLowerCase() + 'z')
        .orderBy('email')
        .get();

    final List<CUser> users = [];

    for (final doc in querySnapshot.docs) {
      final user = CUser.fromJson(doc.data());
      users.add(user);
    }

    setState(() {
      searchResults = users; // Mettre à jour les résultats de la recherche
    });
  }
}