import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateEvent extends StatefulWidget {
  static const id = "CreteEvent";
  final FirebaseUser loggedInUser;

  CreateEvent({@required this.loggedInUser});
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String venue;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: this.selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void createEvent() async {
    Timestamp timestamp = new Timestamp.fromDate(this.fullDateTime());

    DocumentReference result = await _firestore.collection('basketball-game').add({
      'venue': this.venue,
      'datetime': timestamp,
    });

    if (result.documentID != null) {
      Navigator.of(context).pop();
    } else {
      print("somethign went wrong");
    }
  }

  DateTime fullDateTime() {
    return new DateTime(this.selectedDate.year, this.selectedDate.month, this.selectedDate.day, this.selectedTime.hour, this.selectedTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Coffee Meetup"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  this.venue = value;
                },
                decoration: InputDecoration(hintText: "Venue"),
              ),
              FlatButton(
                onPressed: () => _selectDate(context),
                child: Text("Date"),
              ),
              FlatButton(
                onPressed: () => _selectTime(context),
                child: Text("Time"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  FlatButton(
                    onPressed: () {
                      this.createEvent();
                    },
                    child: Text("Create"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
