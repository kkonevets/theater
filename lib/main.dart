import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'session.dart';
import 'session_builder.dart';

List<Session> _sessions = [
  Session(name: "Сеанс 1", time: DateTime.parse("2019-07-20 10:05:04Z")),
  Session(name: "Сеанс 2", time: DateTime.parse("2019-07-20 14:20:04Z")),
  Session(name: "Сеанс 3", time: DateTime.parse("2019-07-20 20:45:04Z")),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(title: "Сеансы"));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildSessions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _sessions.length * 2 - 1, // including dividers
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return _buildRow(_sessions[index]);
        });
  }

  _displaySessionBuilder(BuildContext context, {Session session}) async {
    final Session modifiedSession = await showDialog(
      context: context,
      builder: (context) => SessionBuilder(session: session),
    );

    if (modifiedSession != null) {
      if (session == null) {
        setState(() {
          _sessions.add(modifiedSession);
        });
      } else {
        final found =
            _sessions.firstWhere((item) => item.hashCode == session.hashCode);
        setState(() => found.fill(modifiedSession));
      }
    }
  }

  Widget _buildRow(Session session) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: () => _pushSession(session),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
                      child: Text(
                        session.name,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
                      child: Text(
                        DateFormat.Hm().format(session.time),
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                )),
            GestureDetector(
                onTap: () => _displaySessionBuilder(context, session: session),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }

  void _pushSession(Session session) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SessionRoute(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildSessions(),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _displaySessionBuilder(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
