import 'package:flutter/material.dart';
import 'client.dart';
import 'package:theater/models.dart';
import 'package:theater/bloc.dart';
import 'package:theater/common.dart';

class SessionRoute extends StatefulWidget {
  final Session session;

  SessionRoute({Key key, @required this.session}) : super(key: key);

  @override
  _SessionRouteState createState() => _SessionRouteState(session: session);
}

class _SessionRouteState extends State<SessionRoute> {
  final Session session;

  Bloc clientBloc;

  _SessionRouteState({this.session})
      : clientBloc = Bloc(tableName: 'clients', sessionId: session.id);

  dispose() {
    clientBloc.dispose();
    super.dispose();
  }

  Widget _buildRow(Client client) {
    String rowText = "";
    if (client.seatNumber != null) {
      rowText += "место ${client.seatNumber}";
    }

    void isPresentOnChanged(bool value) {
      if (client != null) {
        setState(() {
          client.isPresent = value;
        });
      }
    }

    return InkWell(
      onTap: () => _pushClientBuilder(client: client),
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
                      client.name,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
                    child: Text(
                      rowText,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Checkbox(
                    value: client.isPresent == null ? false : client.isPresent,
                    onChanged: isPresentOnChanged,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _pushClientBuilder({Client client}) async {
    bool anew = false;

    if (client == null) {
      anew = true;
      client =
          Client(time: DateTime.now(), isPresent: true, sessionId: session.id);
    }

    final DismissDialogAction action = await Navigator.push(
        context,
        MaterialPageRoute<DismissDialogAction>(
          builder: (BuildContext context) => ClientBuilder(client: client),
          fullscreenDialog: true,
        ));

    setState(() {
      if (action == DismissDialogAction.save) {
        if (anew) {
          clientBloc.add(client);
        } else {
          clientBloc.update(client);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(super.widget.session.name),
      ),
      body: buildStreamList(clientBloc, _buildRow),

      floatingActionButton: FloatingActionButton(
        onPressed: _pushClientBuilder,
        tooltip: 'Добавить зрителя',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
