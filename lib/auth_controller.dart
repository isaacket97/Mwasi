import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mwasi_2/login_page.dart';
import 'package:mwasi_2/welcome_page.dart';

import 'user.dart';
import 'db_service.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  String getCurrentUserId() {
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async{
    if (user == null) {
      print("login page");
      Get.offAll(() => LoginPage());
    } else {
      final currentUser = CUser(email: user.email!, uid: user.uid, discussions: []);
      await DBServices().saveUser(CUser(email: user.email!, uid: user.uid, discussions: []), email: null);

      Get.offAll(() => AccueilPage(user: currentUser));
    }
  }



  void register(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DBServices.createUser(auth.currentUser!.uid, email);
    } catch (e) {
      Get.snackbar("About User", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText:
          Text(e.toString(), style: TextStyle(color: Colors.white)));
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("About Login", "Login message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText:
          Text(e.toString(), style: const TextStyle(color: Colors.white)));
    }
  }

  void LogOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  User get user => FirebaseAuth.instance.currentUser!;
  Stream<User?> get onChangedUser => auth.authStateChanges();
}