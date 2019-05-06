import 'package:flutter/material.dart';
import 'client.dart';

class Session {
  Session({this.name, this.time, this.totalSeats});

  String name;
  TimeOfDay time;
  int totalSeats;
}

class SessionRoute extends StatelessWidget {
  final Session session;
  List<Client> _clients = [
    Client(
        name: "Вася",
        barcode: "234543432565",
        phoneNumber: "+79261457894",
        time: DateTime.parse("2019-07-20 20:18:04Z")),
    Client(
        name: "Петя",
        barcode: "23436345254",
        phoneNumber: "+79241557694",
        time: DateTime.parse("2019-07-20 20:19:04Z")),
    Client(
        name: "Маша",
        barcode: "96968565849",
        phoneNumber: "+79061447824",
        time: DateTime.parse("2019-07-20 20:12:04Z")),
    Client(
        name: "Света",
        barcode: "25958438573475",
        phoneNumber: "+7999345333",
        time: DateTime.parse("2019-07-20 20:20:04Z"))
  ];

  // In the constructor, require a Todo
  SessionRoute({Key key, @required this.session}) : super(key: key);

  Widget _buildClients() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _clients.length,
        itemBuilder: (context, i) {
          return _buildRow(_clients[i]);
        });
  }

  Widget _buildRow(Client client) {
    return GestureDetector(
      // onTap: () => _pushClient(client),
      child: ListTile(
        title: Text(
          client.name,
        ),
      ),
    );
  }

  // void _pushClient(Client client) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(
  //         builder: (BuildContext context) =>
  //             () {} //ClientRoute(client: client),
  //         ),
  //   );
  // }

  Widget _displayClientBuilder(BuildContext context) {
    // return ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
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
