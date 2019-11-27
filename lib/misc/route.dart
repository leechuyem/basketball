import 'package:basketball/screens/account_details.dart';
import 'package:basketball/screens/create_event.dart';
import 'package:basketball/screens/edit_event.dart';
import 'package:basketball/screens/event_screen.dart';
import 'package:basketball/screens/sign_in_screen.dart';
import 'package:basketball/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case SignUpScreen.id:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case SignInScreen.id:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case EventScreen.id:
        return MaterialPageRoute(builder: (_) => EventScreen(loggedInUser: settings.arguments,));
      case CreateEvent.id:
        return MaterialPageRoute(builder: (_) => CreateEvent(loggedInUser: settings.arguments,));
      case EditPage.id:
        return MaterialPageRoute(builder: (_) => EditPage(match: settings.arguments,));
      case AccountDetails.id:
        return MaterialPageRoute(builder: (_) => AccountDetails(loggedInUser: settings.arguments,));
      default:
        return null; 
    }
  }
}