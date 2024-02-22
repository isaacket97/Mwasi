import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mwasi_2/auth_controller.dart';
import 'package:mwasi_2/post_myactu_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math';

class MyActu extends StatefulWidget {
  @override
  _MyActuState createState() => _MyActuState();
}

class _MyActuState extends State<MyActu> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController.instance;
  bool _isSubscribed = false;
  final TextEditingController searchController = TextEditingController();
  final String profileImageUrl = "";
  final String date = "";
  final String username = "";
  final String text = "";
  final List<String> imageUrls = [];
  List<String> searchResults = [];

  String formatDate(DateTime date, String format, String locale) {
    var formatter = DateFormat(format, locale);
    String formattedDate = formatter.format(date).toUpperCase();
    return formattedDate;
  }

  void subscribe(String subscriberId) async {
    String userId = _authController.getCurrentUserId();
    await FirebaseFirestore.instance.collection('users2').doc(userId).update({
      'subscribers': FieldValue.arrayUnion([subscriberId]),
    });
    setState(() {
      _isSubscribed = true;
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscriber added !'),
        duration: Duration(seconds: 2),
      ),
    );

  }

  void unsubscribe(String subscriberId) async {
    String userId = _authController.getCurrentUserId();
    await FirebaseFirestore.instance.collection('users2').doc(userId).update({
      'subscribers': FieldValue.arrayRemove([subscriberId]),
    });
    setState(() {
      _isSubscribed = false;
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscriber deleted !'),
        duration: Duration(seconds: 2),
      ),);
  }

  void searchUsers(String searchTerm) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users2')
        .where('lastName', isEqualTo: searchTerm)
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;

    QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore.instance
        .collection('users2')
        .where('firstName', isEqualTo: searchTerm)
        .get();

    docs.addAll(snapshot2.docs);

    if (docs.isNotEmpty) {
      // Récupérer les données du premier document trouvé
      var userData = docs[0].data();
      var firstName = userData['lastName'];
      var lastName = userData['firstName'];
      var profileImageUrl = userData['photoUrl'];
      var subscriberId = userData['uid'];

      // Afficher le profil correspondant
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                SizedBox(height: 8.0),
                Text(
                  '$firstName $lastName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isSubscribed)
                  TextButton(
                    onPressed: () {
                      unsubscribe(subscriberId);
                    },
                    child: Text('Unsubscribe'),
                  ),
                if (!_isSubscribed)
                  TextButton(
                    onPressed: () {
                      subscribe(subscriberId);
                    },
                    child: Text('Subscribe'),
                  ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Afficher un message indiquant que l'utilisateur n'a pas été trouvé
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('No user found with this name'),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  Future<List<String>> getMatchingPostIds() async {
    String currentUserUid = getCurrentUserUid();

    if (currentUserUid.isNotEmpty) {
      // Récupérer l'utilisateur actuel
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('users2')
          .doc(currentUserUid)
          .get();

      if (userSnapshot.exists) {
        // L'utilisateur actuel existe dans la collection "users"

        // Récupérer ses abonnés
        List<dynamic> subscribers = userSnapshot.get('subscribers');

        List<String> matchingPostIds = [];

        // Parcourir les abonnés
        for (var subscriberUid in subscribers) {
          // Récupérer les posts correspondants à l'UID de l'abonné
          QuerySnapshot<Map<String, dynamic>> postsSnapshot = await FirebaseFirestore.instance
              .collection('posts')
              .where('userId', isEqualTo: subscriberUid)
              .get();

          List<QueryDocumentSnapshot<Map<String, dynamic>>> postsDocs = postsSnapshot.docs;


          for (var postDoc in postsDocs) {
            var postId = postDoc.id;
            matchingPostIds.add(postId);
          }
        }
        Random random = Random();
        matchingPostIds.shuffle(random);
        return matchingPostIds;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for a person...',
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Color(0xAA6F364A),
                    ),
                    onSubmitted: (value) {
                      searchUsers(value);
                      searchController.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {
                    searchUsers(searchController.text);
                    searchController.clear();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostActuPage()));
                },
                child: const Text(
                  'Add a post',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            FutureBuilder<List<String>>(
              future: getMatchingPostIds(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading posts'));
                }

                if (snapshot.hasData) {
                  List<String> matchingPostIds = snapshot.data!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: matchingPostIds.length,
                      itemBuilder: (context, index) {
                        String postId = matchingPostIds[index];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('posts').doc(postId).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                            if (snapshot.hasError) {
                              return const Center(child: Text('Error when loading posts'));
                            }

                            if (snapshot.hasData) {
                              DocumentSnapshot<Map<String, dynamic>> postSnapshot = snapshot.data! as DocumentSnapshot<Map<String, dynamic>>;
                              String authorId = postSnapshot.get('userId');
                              Timestamp timestamp = postSnapshot.get('timestamp');
                              initializeDateFormatting('en', null);
                              String date = formatDate(timestamp.toDate(), 'dd MMMM yyyy', 'en');
                              String text = postSnapshot.get('text');
                              List<String> imageUrls = List<String>.from(postSnapshot.get('images'));

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance.collection('users2').doc(authorId).get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text('Error loading author data');
                                          }


                                          if (snapshot.hasData && snapshot.data!.exists) {
                                            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                                            String firstName = userData['firstName'];
                                            String lastName = userData['lastName'];
                                            String profileImageUrl = userData['photoUrl'];

                                            return Row(
                                                children : [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(profileImageUrl),
                                                  ),
                                                  const SizedBox(width : 8.0),
                                                  Text(
                                                    '$firstName $lastName',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ), ),
                                                  const SizedBox(width : 8.0),
                                                  Text(date, style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),),]
                                            );
                                          } else {
                                            return const Text('Author not found');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    text,
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(height: 8.0),
                                  if (imageUrls.isNotEmpty)
                                    Column(
                                      children: imageUrls.map((imageUrl) {
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 8.0),
                                          child: Image.network(imageUrl),
                                        );
                                      }).toList(),
                                    ),
                                  const Row(
                                    children: [
                                      Icon(Icons.thumb_up_off_alt),
                                      SizedBox(width: 4.0),
                                      Text('Like'),
                                      SizedBox(width: 16.0),
                                      Icon(Icons.comment_outlined),
                                      SizedBox(width: 4.0),
                                      Text('Comment'),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0), // Ajoutez le padding souhaité
                                    child: Container(
                                      height: 4.0,
                                      color:const Color(0x776F364A),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        );
                      },
                    ),
                  );

                }

                return const Center(child: Text('No posts found'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

