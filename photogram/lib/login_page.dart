


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  void loginWithGoogle() async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount signInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication = await signInAccount.authentication ;
    final FirebaseUser user = await auth.signInWithGoogle(idToken: authentication.idToken, accessToken: authentication.accessToken);

    print('_MyAppState.loginWithGoogle ${user.displayName} ');
  }




  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/h3.jpg' ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(.7), BlendMode.darken)
          )
      ),

      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlutterLogo(
              size: 200.0,
            ) ,

            RaisedButton(
              color: Colors.brown,
              onPressed: (){
                loginWithGoogle();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Login with google'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w200
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
