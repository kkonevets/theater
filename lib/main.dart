import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Session register';

    return MaterialApp(
        title: title, home: MyHomePage(title: "Session register"));
  }
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

class Session {
  Session({this.name, this.time, this.totalSeats});

  String name;
  TimeOfDay time;
  int totalSeats;
}

List<Session> _Sessions = [
  Session(name: "Сеанс 1", time: TimeOfDay(hour: 10, minute: 20)),
  Session(name: "Сеанс 2", time: TimeOfDay(hour: 13, minute: 0)),
  Session(name: "Сеанс 3", time: TimeOfDay(hour: 15, minute: 45)),
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  // #docregion _buildSuggestions
  Widget _buildSessions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _Sessions.length * 2 - 1, // including dividers
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return _buildRow(_Sessions[index]);
        });
  }

  Widget _dialogBuilder(BuildContext context) {
    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              controller: myController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Введите название сеанса'),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                    RaisedButton(
                        onPressed: () {
                          if (myController.text.isNotEmpty) {
                            setState(() {
                              _Sessions.add(Session(
                                  name: myController.text,
                                  time: TimeOfDay(hour: 10, minute: 20)));
                            });

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Ok')),
                  ],
                ))
          ]))
    ]);
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
        onPressed: () => showDialog(
            context: context, builder: (context) => _dialogBuilder(context)),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
