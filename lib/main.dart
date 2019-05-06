import 'package:flutter/material.dart';
import 'session.dart';
import 'session_builder.dart';

List<Session> _sessions = [
  Session(name: "Сеанс 1", time: TimeOfDay(hour: 10, minute: 20)),
  Session(name: "Сеанс 2", time: TimeOfDay(hour: 13, minute: 0)),
  Session(name: "Сеанс 3", time: TimeOfDay(hour: 15, minute: 45)),
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
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // #docregion _buildSuggestions
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

  _displaySessionBuilder(BuildContext context) async {
    final Session session = await showDialog(
      context: context,
      builder: (context) => DialogBuilder(),
    );

    setState(() {
      _sessions.add(session);
    });
  }

  Widget _buildRow(Session session) {
    return GestureDetector(
        onTap: () => _pushClients(session),
        child: ListTile(
          title: Text(
            session.name,
            style: _biggerFont,
          ),
        ));
  }

  void _pushClients(Session session) {
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
