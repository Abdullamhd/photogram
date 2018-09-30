import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photogram/user.dart';
import 'push_id.dart';

class ImagePreviewScreen extends StatefulWidget {
  File imageFile;
  User user ;

  ImagePreviewScreen({
    this.imageFile,
    this.user,
  });

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final _formKey = GlobalKey<FormState>();

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              validateandSend();
            },
          )
        ],
        title: Text(
          'send image ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.file(widget.imageFile),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'enter title', labelText: 'title'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please insert title ';
                    }
                  },
                  onSaved: (value) {
                    this.title = value;
                  },
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  void validateandSend() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print('form data ${title}');

      /***
       *
       * posts : collection
       *  -postID : document
       *    -uid : user id
       *    -photoUrl
       *    -date
       *
       *
       *
       */

      final String postID = PushIdGenerator.generatePushChildName();

      final StorageReference photoRef =
      FirebaseStorage.instance.ref().child('posts').child(postID);

      final StorageUploadTask task = photoRef.putFile(widget.imageFile);

      final Uri downloadUrl = (await task.future).downloadUrl;

      final String uriString = downloadUrl.toString();

      final postMap = {

        'uid': widget.user.uid,
        'photoUrl': uriString,
        'date': FieldValue.serverTimestamp() ,
        'title' : title
      };


      Firestore.instance.collection('posts')
          .document(postID)
          .setData(postMap)
          .then((_) {
        Navigator.pop(context);
      });
    }
  }}
