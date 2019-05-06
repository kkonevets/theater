import 'package:flutter/material.dart';
import 'client.dart';

class Session {
  Session({this.name, this.time, this.totalSeats});

  String name;
  TimeOfDay time;
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
    String rowText = "${client.name}";
    if (client.phoneNumber != null && client.phoneNumber.isNotEmpty) {
      rowText += ", тел: ${client.phoneNumber}";
    }
    if (client.seatNumber != null) {
      rowText += ", место ${client.seatNumber}";
    }

    return GestureDetector(
      onTap: () => _displayClientBuilder(context, client: client),
      child: ListTile(
        title: Text(
          rowText,
        ),
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
