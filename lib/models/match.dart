import 'package:cloud_firestore/cloud_firestore.dart';

class MatchEvent {
  final String id; 
  final String venue;
  final String organiser;
  final DateTime dateTime;
  final String payee;
  final String amount; 

  MatchEvent({this.id, this.venue, this.organiser, this.dateTime, this.payee, this.amount});

  factory MatchEvent.fromFirebase(DocumentSnapshot data) => MatchEvent(
    venue: data['venue'],
    dateTime: data['datetime'].toDate()
  );

  static List<MatchEvent> decodeCoffeeEventList(List<DocumentSnapshot> data) {
    List<MatchEvent> eventList = new List<MatchEvent>();

    for(var event in data) {
      MatchEvent eve = MatchEvent.fromFirebase(event); 

      eventList.add(eve);
    }

    return eventList;
  }
}