import 'package:flutter/material.dart';
import 'client.dart';

class Session {
  Session({this.name, this.time, this.totalSeats});
  fill(Session session) {
    this.name = session.name;
    this.time = session.time;
    this.totalSeats = session.totalSeats;
  }

  String name;
  DateTime time;
  int totalSeats;
}

List<Client> _clients = [
   Client(
       name: "Вася",
       barcode: "234543432565",
       phoneNumber: "+79261457894",
       time: DateTime.parse("2019-07-20 20:18:04Z"),
       seatNumber: 44),
   Client(
       name: "Петя",
       barcode: "23436345254",
       phoneNumber: "+79241557694",
       time: DateTime.parse("2019-07-20 20:19:04Z"),
       seatNumber: 14),
   Client(
       name: "Маша",
       barcode: "96968565849",
       phoneNumber: "+79061447824",
       time: DateTime.parse("2019-07-20 20:12:04Z"),
       seatNumber: 3),
   Client(
       name: "Света",
       barcode: "25958438573475",
       phoneNumber: "+7999345333",
       time: DateTime.parse("2019-07-20 20:20:04Z"),
       seatNumber: 2)
];

class SessionRoute extends StatefulWidget {
  final Session session;

  SessionRoute({Key key, @required this.session}) : super(key: key);

  @override
  _SessionRouteState createState() => _SessionRouteState();
}

class _SessionRouteState extends State<SessionRoute> {
  Widget _buildClients() {
    return ListView.builder(
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          return _buildRow(_clients[index]);
        });
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

    return GestureDetector(
      onTap: () => _displayClientBuilder(context, client: client),
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
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Checkbox(
                        value:
                            client.isPresent == null ? false : client.isPresent,
                        onChanged: isPresentOnChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 2.0,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _displayClientBuilder(BuildContext context, {Client client}) async {
    final Client modifiedClient = await showDialog(
      context: context,
      builder: (context) => ClientBuilder(
            client: client,
          ),
    );

    if (modifiedClient != null) {
      if (client == null) {
        setState(() {
          _clients.add(modifiedClient);
        });
      } else {
        final found =
            _clients.firstWhere((item) => item.hashCode == client.hashCode);
        setState(() => found.fill(modifiedClient));
      }
    }
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
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
