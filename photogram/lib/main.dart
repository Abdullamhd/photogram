import 'dart:async';
import 'dart:io';

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

    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser firebaseUser){

      if (firebaseUser != null) {

        setState(() {

          user = User(
              userName: firebaseUser.displayName,
              uid: firebaseUser.uid
          );

        });

      } else {
        setState(() {
          user = null ;
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.brown,
        accentColor: Colors.brown.shade500
      ),
      title: 'Photogram',
      home: user == null ? LoginPage() : MainPage(
        user: user,
      ),
    );
  }
}

class MainPage extends StatefulWidget {

  User user ;


  MainPage({
    this.user
});



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
            icon: Icon(Icons.lock ,color: Colors.white,),
            onPressed:(){
              signOut();
            },

          )
        ],
      ),
      body: Center(
        child: Text('User name is : ${widget.user.userName}'),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send , color: Colors.white,),
        onPressed: (){
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
          MaterialPageRoute(builder: (context) => ImagePreviewScreen(
            imageFile: imageFile, user: widget.user,
          )),
        );



      }


    } catch(error){
      //todo upate UI , inform user about the error.
    }






    //




  }
}
