import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountDetails extends StatefulWidget {
  static const id = "Account Details";
  final FirebaseUser loggedInUser; 

  AccountDetails({@required this.loggedInUser});
  
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String total = "0"; 
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotal();
  }

  Future<FirebaseUser> getCurrentUser() async {
    try {
      final currentUser = await _auth.currentUser();
      if (currentUser != null) {
        return currentUser;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void getTotal() async {
    FirebaseUser currentUser = await getCurrentUser();

    if(currentUser.displayName != null) {
      var data = await  _firestore.collection('basketball-game').where('payee', isEqualTo: currentUser.displayName).getDocuments();

    int total = 0; 
    for(var i in data.documents) {
      if(i.data['amount'] != null) {
        total += int.parse(i.data['amount']);
      }
    }

    setState(() {
      this.total = total.toString();
    });
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Total Amount Paid: "),
              Text("$total")
            ],
          ),
        ),
      ),
    );
  }
}