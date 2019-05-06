import 'package:flutter/material.dart';

class Session {
  Session({this.name, this.time, this.totalSeats});

  String name;
  TimeOfDay time;
  int totalSeats;
}

class SessionRoute extends StatelessWidget {
  final Session session;

  // In the constructor, require a Todo
  SessionRoute({Key key, @required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
