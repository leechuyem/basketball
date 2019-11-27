import 'package:basketball/misc/route.dart';
import 'package:basketball/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(Basketball());

class Basketball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      home: SignInScreen(),
    );

  }
}
