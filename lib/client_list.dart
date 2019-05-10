import 'package:flutter/material.dart';
import 'client.dart';
import 'package:theater/models.dart';
import 'package:theater/bloc.dart';

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

  Widget _buildClients() {
    return StreamBuilder(
        stream: clientBloc.stream,
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, itemPosition) {
                  Client client = snapshot.data[itemPosition];
                  return _buildRow(client);
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
    clientBloc.getItems();
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
      onTap: () => _displayClientBuilder(context, client),
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

  _displayClientBuilder(BuildContext context, [Client client]) async {
    bool anew = false;

    if (client == null) {
      anew = true;
      client =
          Client(time: DateTime.now(), isPresent: true, sessionId: session.id);
    }

    final Client modifiedClient = await showDialog(
      context: context,
      builder: (context) => ClientBuilder(client: client),
    );

    setState(() {
      if (modifiedClient != null) {
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
      body: _buildClients(),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayClientBuilder(context),
        tooltip: 'Добавить зрителя',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
