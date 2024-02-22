import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mwasi_2/auth_controller.dart';
import 'package:mwasi_2/profilePage.dart';
import 'Chat.dart';
import 'Projet.dart';
import 'user.dart';
import 'actu.dart';
import 'myActu.dart';

class AccueilPage extends StatefulWidget {
  final CUser? user; // Déclarez le paramètre user comme étant nullable

  AccueilPage({this.user}); // Ajoutez le constructeur prenant le paramètre email

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ACTU(),
    MyActu(),
    PROJET(),
    CHAT(),
  ];

  void navigateToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFD79A8),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Naviguer vers la page 1
                });
              },
              child: const Text(
                'Mwasi',
                style: TextStyle(
                    fontFamily: 'HarlowSoliditalic',
                    fontSize: 40,
                    //fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: navigateToProfilePage,
              child: Image.asset(
                'img/profile.png',
                width: 50,
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 0; // Naviguer vers la page 1
                  });
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_work_outlined,
                      color: Color(0xFFFD79A8),
                    ),
                    /*Image.asset(
                      'img/actu.png',
                      width: 24,
                    ),*/
                    Text('Actu',
                        style: TextStyle(
                            fontFamily: 'Rosemary',
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1; // Naviguer vers la page 2
                  });
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.newspaper_outlined,
                      color: Color(0xFFFD79A8),
                    ),
                    /*Image.asset(
                      'img/myActu.png',
                      width: 24,
                    ),*/
                    Text('My Actu',
                        style: TextStyle(
                            fontFamily: 'Rosemary',
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 2; // Naviguer vers la page 3
                  });
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assured_workload_outlined,
                      color: Color(0xFFFD79A8),
                    ),
                    /*Image.asset(
                      'img/projet.png',
                      width: 24,
                    ),*/
                    Text('Projet',
                        style: TextStyle(
                          fontFamily: 'Rosemary',
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  const Icon(CupertinoIcons.chat_bubble_2_fill,
                      color: Color(0xFFFD79A8));
                  setState(() {
                    _currentIndex = 3; // Naviguer vers la page 4
                  });
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble_2,
                      color: Color(0xFFFD79A8),
                    ),
                    /*Image.asset(
                      'img/chat.png',
                      width: 24,
                    ),*/
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontFamily: 'Rosemary',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
