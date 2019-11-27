import 'package:basketball/components/card.dart';
import 'package:basketball/models/match.dart';
import 'package:basketball/screens/account_details.dart';
import 'package:basketball/screens/create_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventScreen extends StatefulWidget {
  static const id = "EventScreen";
  final FirebaseUser loggedInUser;

  EventScreen({@required this.loggedInUser});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool userIsManager = false;
  bool showUpcoming = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRole();
  }

  void checkRole() async {
    var docRef = _firestore.collection('manager').document(widget.loggedInUser.uid);
    docRef.get().then((data) {
      if (data.exists) {
        setState(() {
          this.userIsManager = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            _auth.signOut();
            Navigator.of(context).pop();
          },
          icon: Icon(
            FontAwesomeIcons.signOutAlt,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Matches",
        ),
        actions: <Widget>[
          
          Builder(
            builder: (context) {
              if (this.userIsManager) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CreateEvent.id, arguments: widget.loggedInUser);
                  },
                  icon: Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.white,
                  ),
                );
              }
              return Container();
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.userAlt),
            onPressed: () {
              Navigator.of(context).pushNamed(AccountDetails.id, arguments: widget.loggedInUser);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    this.showUpcoming = true;
                  });
                },
                child: Text("Upcoming"),
                color: Colors.red,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    this.showUpcoming = false;
                  });
                },
                child: Text("Past"),
                color: Colors.blue,
              ),
            ],
          ),
          StreamBuilder(
              stream: _firestore.collection('basketball-game').snapshots(),
              builder: (context, snapshot) {
                List<Widget> widgets = new List<Widget>();

                try {
                  var events = snapshot.data.documents;
                  for (var event in events) {
                    MatchEvent matchEvent = new MatchEvent(
                        id: event.documentID,
                        venue: event.data['venue'],
                        dateTime: event.data['datetime'].toDate(),
                        payee: event.data['payee'] == null ? null : event.data['payee'],
                        amount: event.data['amount'] == null ? null : event.data['amount']);

                    if (this.showUpcoming) {
                      if (matchEvent.dateTime.isAfter(DateTime.now()) || matchEvent.dateTime.isAtSameMomentAs(DateTime.now())) {
                        Widget w = MatchCard(
                          match: matchEvent,
                        );

                        widgets.add(w);
                      }
                    } else {
                      if(matchEvent.dateTime.isBefore(DateTime.now())) {
                        Widget w = MatchCard(
                          match: matchEvent,
                        );

                        widgets.add(w);
                      }
                    }
                  }
                } catch (exceptions) {
                  print(exceptions);
                }

                return Column(
                  children: widgets,
                );
              }),
        ],
      )
          // child: Column(children: this.coffeeEvents.map((event) => CoffeeCard(coffeeEvent: event,)).toList()),
          ),
    );
  }
}
