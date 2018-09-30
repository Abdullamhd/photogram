import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photogram/login_page.dart';
import 'package:photogram/user.dart';
import 'package:image_picker/image_picker.dart';
import 'image_preview_screen.dart';

/**
 *  if user is login :
 *    displat MainPage
 *  else :
 *  display LoginPage
 *
 *
 */

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //

  User user;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged
        .listen((FirebaseUser firebaseUser) {
      if (firebaseUser != null) {
        setState(() {
          user =
              User(userName: firebaseUser.displayName, uid: firebaseUser.uid);
        });
      } else {
        setState(() {
          user = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.brown, accentColor: Colors.brown.shade500),
      title: 'Photogram',
      home: user == null
          ? LoginPage()
          : MainPage(
              user: user,
            ),
    );
  }
}

class MainPage extends StatefulWidget {
  User user;

  MainPage({this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            onPressed: () {
              signOut();
            },
          )
        ],
      ),
      body: ListTest(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          takePicture();
        },
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void takePicture() async {
    try {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

      if (imageFile != null) {
        // open image preivew screen

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImagePreviewScreen(
                    imageFile: imageFile,
                    user: widget.user,
                  )),
        );
      }
    } catch (error) {
      //todo upate UI , inform user about the error.
    }

    //
  }
}


class PhotosItems extends StatefulWidget {

  String title ;
  String photoUrl ;

  PhotosItems({
    this.title,
    this.photoUrl
});

  @override
  _PhotosItemsState createState() => _PhotosItemsState();
}

class _PhotosItemsState extends State<PhotosItems> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    blurRadius: 5.0,
                    spreadRadius: 5.0)
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              children: <Widget>[
                Image.network(widget.photoUrl),
                Positioned(
                  left: 0.0 ,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(

                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,

                            colors: [
                              Colors.transparent,
                              Colors.black
                            ]
                        )
                    ),

                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.title ,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                              Text(
                                'Secondary title ' ,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: <Widget>[
                            Text(
                              'likes' ,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            Text(
                              '239' ,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        )

                      ],
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ListTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('posts').snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return new ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return new PhotosItems(
              title: document['title'],
              photoUrl: document['photoUrl'],
            );
          },
        );
      },
    );
  }
}
