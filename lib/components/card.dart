import 'package:basketball/models/match.dart';
import 'package:basketball/screens/edit_event.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final MatchEvent match;

  MatchCard({@required this.match}); 

   @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('EEE d MMM').format(this.match.dateTime);
    String formattedTime = DateFormat('K:mm a').format(this.match.dateTime);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(EditPage.id, arguments: this.match);
      },
          child: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(width: 2.0, color: Colors.black)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text("Venue: "),
                  ),
                  Container(child: Text(this.match.venue))
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Text("Date: "),
                  ),
                  Container(
                    child: Text("$formattedDate"),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Text("Time: "),
                  ),
                  Container(
                    child: Text("$formattedTime"),
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