import 'package:basketball/screens/event_screen.dart';
import 'package:basketball/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const id = "Sign In Screen";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance; 
  String email;
  String password; 

  void singIn() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(email: this.email, password: this.password); 

      if(user != null) {
        Navigator.of(context).pushNamed(EventScreen.id, arguments: user.user);
      } else {
        print("no user");
      }
    } catch(exception) {
      print("and i oop- " + exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Center(child: Container(
              child: Text("Sign In"),
            ),),

            // ---------------- NOTE: EMAIL
            TextField(
              onChanged: (value) {
                this.email = value; 
              },
              decoration: InputDecoration(
                hintText: "Email"
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: (value) {
                this.password = value;
              },
              decoration: InputDecoration(
                hintText: "Password"
              ),
            ),
            SizedBox(height: 20,),
            FlatButton(
              onPressed: () {
                this.singIn();
              },
              child: Text("Sign In"),
              color: Colors.blue,
            ),

            // -------------- NOTE: Sign Up
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SignUpScreen.id);
              },
              child: Text("Sign Up"),
              color: Colors.red,
            )
          ],),
        ),
      ),
    );
  }
}