import 'package:basketball/screens/event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const id = "Sign Up Screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  String role = "Member";
  List<String> roleList = ['Member', 'Manager'];
  UserUpdateInfo userInfo = new UserUpdateInfo(); 
  String email;
  String password;

  void newSignUp() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(email: this.email, password: this.password);
      if (newUser != null) {
        await newUser.user.updateProfile(this.userInfo);
        if(this.role == "Manager") {
          await _firestore.collection('manager').document(newUser.user.uid).setData({
            'uid': newUser.user.uid
          });
        }

        Navigator.of(context).pushNamed(EventScreen.id, arguments: newUser.user);
      } else {}
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                child: Text("Sign Up"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              value: this.role,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  this.role = newValue;
                });
              },
              items: items()
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  this.userInfo.displayName = value;
                });
              },
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  this.email = value;
                });
              },
              decoration: InputDecoration(hintText: "Email"),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  this.password = value;
                });
              },
              decoration: InputDecoration(hintText: "Password"),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () {
                this.newSignUp();
              },
              child: Text("Sign Up"),
              color: Colors.blue,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Sign In"),
            )
          ],
        ),
      ),
    ));
  }

  List<DropdownMenuItem<String>> items () {
    var roles = ['Manager', 'Member'];
    List<DropdownMenuItem<String>> widets = new List<DropdownMenuItem<String>>();
    for(var i in roles) {
      Widget w = DropdownMenuItem(child: Text(i), value: i,);
      widets.add(w);
    }
    return widets; 
  }
}
