import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostActuPage extends StatefulWidget {
  @override
  _PostActuPageState createState() => _PostActuPageState();

  static const routeName = '/post_myactu_page';
}

class _PostActuPageState extends State<PostActuPage> {
  late final TextEditingController _postController;
  List<String> imageUrls = [];

  Future _getImages() async{
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null){
      setState(() {
        imageUrls.addAll(pickedFiles.map((pickedFile) => pickedFile.path).toList());
      });
    }
  }

  Future<List<String>> _uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];
    try {
      for (String imagePath in imagePaths) {
        String fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance.ref().child('images/$fileName');
        await ref.putFile(File(imagePath));
        String imageUrl = await ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    } catch(e){
      print("Error uploading images : $e");
    }

    return imageUrls;
  }

  Future<void> _saveData(String text, List<String> imageUrls) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('posts').add({
          'userId': user.uid,
          'text': text,
          'images': imageUrls,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Fluttertoast.showToast(
          msg: 'Publication made',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.green,
        );
        setState(() {
          _postController.clear();
          imageUrls.clear();
        });
      }
    } catch (e) {
      print('Error saving data : $e');

      Fluttertoast.showToast(
        msg: 'Error when publishing : $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.red,
      );
    }
  }

  Widget _buildImagePreview(String imagePath){
    return Stack(
      children: [
        Image.file(
          File(imagePath),
          height: 200.0,
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                setState(() {
                  imageUrls.remove(imagePath);
                });
              }

          ),
        )
      ],
    );
  }

  @override
  void initState() {
    _postController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () async {
                  String postContent = _postController.text;
                  List<String> _imageUrls = await _uploadImages(imageUrls);
                  await _saveData(postContent, _imageUrls);
                },
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),))
          ],
          backgroundColor: Color(0xFFFD79A8),
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _postController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Write something...",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: _getImages,
                  child: const Text(
                    "Add a picture...",
                    style: TextStyle(
                      color: Colors.black54,
                      //fontSize:
                    ),),),
                SizedBox(height: 16.0,),
                Expanded(child: ListView.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return _buildImagePreview(imageUrls[index]);
                    })),
                /*Column(
              children: imageUrls.map((url){
                return _buildImagePreview(url);
              }).toList()*/
              ],
            )));
  }
}