import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theater/menu.dart';
import 'session.dart';
import 'session_builder.dart';

List<Session> _sessions = [
  Session(
      name: "Сеанс 1",
      time: DateTime.parse("2019-07-20 10:05:04Z"),
      totalSeats: 33),
  Session(
      name: "Сеанс 2",
      time: DateTime.parse("2019-07-20 14:20:04Z"),
      totalSeats: 40),
  Session(
      name: "Сеанс 3",
      time: DateTime.parse("2019-07-20 20:45:04Z"),
      totalSeats: 60),
];

class SessionList extends StatefulWidget {
  SessionList({Key key}) : super(key: key);

  final String title = "Сеансы";

  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  Widget _buildSessions() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _sessions.length, // including dividers
      itemBuilder: (context, i) {
        return _buildRow(_sessions[i]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildRow(Session session) {
    return InkWell(
      onTap: () => _pushSession(session),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
                    child: Text(
                      session.name,
                      style: TextStyle(fontSize: 18.0),
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
              ),
              InkWell(
                  onTap: () => _displaySessionBuilder(context, session),
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
      ),
    );
  }

  _displaySessionBuilder(BuildContext context, [Session session]) async {
    bool anew = false;
    if (session == null) {
      anew = true;
      session = Session(time: DateTime.now());
    }

    final Session modifiedSession = await showDialog(
      context: context,
      builder: (context) => SessionBuilder(session: session),
    );

    setState(() {
      if (modifiedSession != null && anew) {
        _sessions.add(session);
      }
    });
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
      drawer: new MenuDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => {},
          ),
        ],
      ),
      body: _buildSessions(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displaySessionBuilder(context),
        tooltip: 'Добавить сеанс',
        child: Icon(Icons.add),
      ),
    );
  }
}
