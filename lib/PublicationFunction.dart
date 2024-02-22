import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String owner = '';
  String name = '';
  String email = '';
  String? poster;
  String description = '';
  String date = '';
}

class MyDialogContent extends StatefulWidget {
  @override
  _MyDialogContentState createState() => _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  List<bool> fieldFilled = [false, false, false, false, false, false];
  final ownerController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  int currentStep = 0;
  String? imageURL;
  final totalSteps = 6;

  Future<String?> uploadImageToFirebase() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = firebaseStorageRef.putFile(file);

      try {
        await uploadTask.whenComplete(() async {
          final downloadUrl = await firebaseStorageRef.getDownloadURL();
          print('URL de téléchargement : $downloadUrl');
          setState(() {
            imageURL = downloadUrl;
          });
        });
      } catch (error) {
        print('Erreur lors du téléchargement : $error');
        return null;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: Color(0xFFFD79A8),
        onPrimary: Colors.white,
        surface: Color(0xFFFD79A8),
        onSurface: Colors.black,
      ),
    );

    return Theme(
      data: customTheme,
      child: AlertDialog(
        title: Text('Ajouter un projet'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              IndexedStack(
                index: currentStep,
                children: [
                  // Step 0
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Entrez votre nom',
                          border: OutlineInputBorder(),
                        ),
                        controller: ownerController,
                        onChanged: (value) {
                          setState(() {
                            fieldFilled[0] = value.isNotEmpty;
                          });
                        },
                      ),
                    ],
                  ),

                  // Step 1
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Entrez le titre de votre projet',
                          border: OutlineInputBorder(),
                        ),
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            fieldFilled[1] = value.isNotEmpty;
                          });
                        },
                      ),
                    ],
                  ),

                  // Step 2
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Entrez votre votre adresse e-mail',
                          border: OutlineInputBorder(),
                        ),
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            fieldFilled[2] = value.isNotEmpty;
                          });
                        },
                      ),
                    ],
                  ),

                  // Step 3
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Entrez la date d'aujourd'hui",
                          border: OutlineInputBorder(),
                        ),
                        controller: dateController,
                        onChanged: (value) {
                          setState(() {
                            fieldFilled[3] = value.isNotEmpty;
                          });
                        },
                      ),
                    ],
                  ),

                  // Step 4
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Entrez la description complète de votre projet',
                          border: OutlineInputBorder(),
                        ),
                        controller: descriptionController,
                        onChanged: (value) {
                          setState(() {
                            fieldFilled[4] = value.isNotEmpty;
                          });
                        },
                      ),
                    ],
                  ),

                  // Step 4
                  Column(
                    children: [
                      if (imageURL != null)
                        Image.network(
                          imageURL!,
                          height: 200,
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          await uploadImageToFirebase();
                        },
                        child: Center(child: Text('Importez une image',style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (currentStep > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
              child: Text('Précédent'),
            ),
          TextButton(
            onPressed: () {
              if (currentStep < totalSteps - 1) {
                if (currentStep == 0 && !fieldFilled[0]) {
                  // Le champ "Nom" n'est pas rempli
                  return;
                } else if (currentStep == 1 && !fieldFilled[1]) {
                  // Le champ "titre" n'est pas rempli
                  return;
                } else if (currentStep == 2 && !fieldFilled[2]) {
                  // Le champ "Adresse e-mail" n'est pas rempli
                  return;
                } else if (currentStep == 3 && !fieldFilled[3]) {
                  // Le champ "Date" n'est pas rempli
                  return;
                } else if (currentStep == 4 && !fieldFilled[4]) {
                  // Le champ "Description" n'est pas rempli
                  return;
                }
                setState(() {
                  currentStep++;
                });
              } else {
                final project = Project();
                project.owner = nameController.text;
                project.name = nameController.text;
                project.email = emailController.text;
                project.date = dateController.text;
                project.description = descriptionController.text;
                project.poster = imageURL;

                FirebaseFirestore.instance.collection('Projects').add({
                  'owner': project.owner,
                  'name': project.name,
                  'email': project.email,
                  'date': project.date,
                  'text': project.description,
                  'poster': project.poster,
                }).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Erreur lors de l\'ajout des projets : $error');
                });
              }
            },
            child: Text(currentStep < totalSteps - 1 ? 'Suivant' : 'Terminer'),
          ),
        ],
      ),
    );
  }
}

void showPopupDialog(BuildContext context) {
  showDialog(
    context:context,
    builder: (BuildContext context) {
      return MyDialogContent();
    },
  );
}