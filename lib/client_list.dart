import 'package:flutter/material.dart';
import 'client.dart';
import 'package:theater/models.dart';


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
    return ListView.separated(
      itemCount: _clients.length,
      itemBuilder: (context, index) {
        return _buildRow(_clients[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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
      client = Client(time: DateTime.now(), isPresent: true);
    }

    final Client modifiedClient = await showDialog(
      context: context,
      builder: (context) => ClientBuilder(client: client),
    );

    setState(() {
      if (modifiedClient != null && anew) {
        _clients.add(modifiedClient);
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
