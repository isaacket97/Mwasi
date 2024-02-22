import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwasi_2/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mwasi_2/login_page.dart';
import 'dart:io';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController.instance;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users2');
  bool _isProfileComplete = false;

  Future<void> addProfilePicture() async {
    final picker = ImagePicker();

    // Sélectionner une image depuis la galerie
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Uploader l'image sur Firebase Storage
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(_authController.getCurrentUserId() + '.jpg');

      await storageReference.putFile(imageFile);

      // Obtenir l'URL de l'image uploadée
      String imageUrl = await storageReference.getDownloadURL();

      // Mettre à jour le champ 'profilePicture' dans la collection 'users'
      await _usersCollection.doc(_authController.getCurrentUserId()).update({
        'photoUrl': imageUrl,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Your profile picture has been added successfully'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
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

  Future<void> updateProfilePicture() async {
    final picker = ImagePicker();

    // Sélectionner une image depuis la galerie
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Uploader la nouvelle image sur Firebase Storage
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(_authController.getCurrentUserId() + '.jpg');

      await storageReference.putFile(imageFile);

      // Obtenir l'URL de la nouvelle image uploadée
      String newImageUrl = await storageReference.getDownloadURL();

      // Récupérer l'ancienne URL de l'image de profil depuis la collection 'users'
      DocumentSnapshot userSnapshot = await _usersCollection.doc(_authController.getCurrentUserId()).get();
      String oldImageUrl = (userSnapshot.data() as Map<String, dynamic>)['photoUrl'];

      // Supprimer l'ancienne image de profil de Firebase Storage
      if (oldImageUrl != null) {
        firebase_storage.Reference oldImageReference = firebase_storage.FirebaseStorage.instance.refFromURL(oldImageUrl);
        await oldImageReference.delete();
      }

      // Mettre à jour le champ 'profilePicture' dans la collection 'users' avec la nouvelle URL
      await _usersCollection.doc(_authController.getCurrentUserId()).update({
        'photoUrl': newImageUrl,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Your profile picture has been updated successfully'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
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

  @override
  void initState() {
    super.initState();
    // Vérifier si le profil de l'utilisateur est déjà complet lors du chargement de la page
    _checkProfileCompletion();
  }

  void _checkProfileCompletion() async {
    // Obtenir l'ID de l'utilisateur actuellement connecté
    String userId = _authController.getCurrentUserId();

    // Obtenir les données du profil de l'utilisateur à partir de Firebase
    DocumentSnapshot profileSnapshot =
    await _usersCollection.doc(userId).get();

    if (profileSnapshot.exists) {
      // Le profil existe, donc il est complet
      setState(() {
        _isProfileComplete = true;
      });
    }
  }

  void _saveProfile() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;


    // Obtenir l'ID de l'utilisateur actuellement connecté
    String userId = _authController.getCurrentUserId();

    // Enregistrer les informations du profil dans Firebase
    await _usersCollection.doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
      'uid': userId,
      'subscribers': []
    });

    setState(() {
      _isProfileComplete = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your profile has been saved successfully'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _logout(BuildContext context) {
    _authController.LogOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFD79A8),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            if (_isProfileComplete)
              StreamBuilder<DocumentSnapshot>(
                stream: _usersCollection.doc(_authController.getCurrentUserId()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error loading profile data');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData && snapshot.data!.exists) {
                    Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                    String firstName = userData['firstName'];
                    String lastName = userData['lastName'];

                    if (userData.containsKey('photoUrl')) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          ElevatedButton(
                              onPressed: updateProfilePicture,
                              child: Text('Update Profile Picture')),
                          Text(
                            '$firstName $lastName',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rosemary',
                            ),),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            child: Icon(Icons.person),
                          ),
                          ElevatedButton(
                              onPressed: addProfilePicture,
                              child: Text('Add Profile Picture')),
                          Text(
                            '$firstName $lastName',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rosemary',
                            ),),
                        ],
                      );
                    }

                  } else {
                    return Text('Profile not found');
                  }
                },
              ),
            if (!_isProfileComplete)
              Column(
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Firstname',
                    ),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Lastname',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text('Save the profile'),
                  ),
                ],
              ),
            SizedBox(height: 16),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => _logout(context),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFFD79A8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}