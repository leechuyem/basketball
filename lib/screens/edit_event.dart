import 'package:basketball/models/match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EditPage extends StatefulWidget {
  static const id = "Edit Page";
  final MatchEvent match;

  EditPage({@required this.match});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _firestore = Firestore.instance;
  String payee; 
  String amount; 
  
  void delete() async {
    await _firestore.collection('basketball-game').document(widget.match.id).delete();
    Navigator.pop(context);
  }

  void update() async {
    await _firestore.collection('basketball-game').document(widget.match.id).setData({
      'venue': widget.match.venue,
      'datetime': widget.match.dateTime,
      'payee': this.payee,
      'amount': this.amount
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE d MMM').format(widget.match.dateTime);
    String formattedTime = DateFormat('K:mm a').format(widget.match.dateTime);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text("Venue: "),
            Text("${widget.match.venue}")
          ],),
          Row(children: <Widget>[
            Text("Date: "),
            Text("$formattedDate")
          ],),
          Row(children: <Widget>[
            Text("Time: "),
            Text("$formattedTime")
          ],),
          TextField(
            onChanged: (value) {
              setState(() {
                this.payee = value; 
              });
            },
            decoration: InputDecoration(
              hintText: widget.match.payee == null ? "Payer" : widget.match.payee
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                this.amount = value; 
              });
            },
            decoration: InputDecoration(
              hintText: widget.match.amount == null ? "amount" : widget.match.amount,
            ),
          ),
          Row(children: <Widget>[
            FlatButton(
              onPressed: () {
                this.delete();
              },
              child: Text("Delete"),
            ),
            FlatButton( 
              onPressed: () {
                this.update();
              },
              child: Text("Update"),
            )
          ],)
        ],),
      ),
    );
  }
}
