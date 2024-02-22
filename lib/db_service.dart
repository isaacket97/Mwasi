import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class DBServices {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  static Future<void> createUser(String userId, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
      });
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de la création de l\'utilisateur dans la base de données : $e');
    }
  }

  Future<void> saveUser(CUser user, {required email}) async {
    try {
      await userCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de la sauvegarde de l\'utilisateur dans la base de données : $e');
    }
  }

}