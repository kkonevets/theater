import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theater/menu.dart';
import 'package:theater/client_list.dart';
import 'package:theater/session.dart';
import 'package:theater/models.dart';
import 'package:theater/bloc.dart';

class SessionList extends StatefulWidget {
  SessionList({Key key}) : super(key: key);

  final String title = "Сеансы";

  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  final Bloc sessionBloc = Bloc(tableName: 'sessions');

  dispose() {
    sessionBloc.dispose();
    super.dispose();
  }

  Widget _buildSessions() {
    return StreamBuilder(
        stream: sessionBloc.stream,
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, itemPosition) {
                  Session session = snapshot.data[itemPosition];
                  return _buildRow(session);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            }
          } else {
            return Center(
              child: loadingData(),
            );
          }
        });
  }

  Widget loadingData() {
    //pull todos again
    sessionBloc.getItems();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
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
      if (modifiedSession != null) {
        if (anew) {
          sessionBloc.add(session);
        } else {
          sessionBloc.update(session);
        }
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
