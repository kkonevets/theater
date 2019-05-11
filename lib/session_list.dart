import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theater/menu.dart';
import 'package:theater/client_list.dart';
import 'package:theater/session.dart';
import 'package:theater/models.dart';
import 'package:theater/bloc.dart';
import 'package:theater/common.dart';

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

  Widget _buildRow(Session session) {
    return InkWell(
      onTap: () => _pushSession(session),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
                      child: Text(
                        session.name,
                        softWrap:true,
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
              ),
              InkWell(
                  onTap: () => _pushSessionBuilder(session: session),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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

  void _pushSession(Session session) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SessionRoute(session: session),
      ),
    );
  }

  void _pushSessionBuilder({Session session}) async {
    bool anew = false;
    if (session == null) {
      anew = true;
      session = Session(time: DateTime.now());
    }

    final DismissDialogAction action = await Navigator.push(
        context,
        MaterialPageRoute<DismissDialogAction>(
          builder: (BuildContext context) => SessionBuilder(session: session),
          fullscreenDialog: true,
        ));

    setState(() {
      if (action == DismissDialogAction.save) {
        if (anew) {
          sessionBloc.add(session);
        } else {
          sessionBloc.update(session);
        }
      }
    });
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
      body: buildStreamList(sessionBloc, _buildRow),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushSessionBuilder,
        tooltip: 'Добавить сеанс',
        child: Icon(Icons.add),
      ),
    );
  }
}
