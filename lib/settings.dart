import 'package:flutter/material.dart';
import 'package:theater/models.dart';
import 'package:theater/database_helpers.dart';

List<Session> _sessions = [
  Session(
      name: "Сеанс 4",
      time: DateTime.parse("2019-07-25 10:15:04Z"),
      totalSeats: 60),
];

List<Client> _clients = [
  Client(
      name: "Клиент 1",
      barcode: "234543432565",
      phoneNumber: "+79261457894",
      time: DateTime.parse("2019-07-20 20:18:04Z"),
      seatNumber: 44),
  Client(
      name: "Клиент 2",
      barcode: "23436345254",
      phoneNumber: "+79241557694",
      time: DateTime.parse("2019-07-20 20:19:04Z"),
      seatNumber: 14),
];

class SettingsBuilder extends StatefulWidget {
  final Function callback;

  SettingsBuilder({Key key, this.callback}) : super(key: key);

  @override
  _SettingsBuilderState createState() => _SettingsBuilderState();
}

class _SettingsBuilderState extends State<SettingsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Настройки"),
        ),
        body: Center(
          child: RaisedButton.icon(
            icon: Icon(Icons.sync),
            label: const Text('Синхронизировать'),
            onPressed: () async {
              await _test();
              super.widget.callback();
            },
          ),
        ));
  }
}

Future _test() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  final db = await helper.database;

  // добавляем новый сеанс
  Session session = _sessions[0];
  int sessionId = await helper.insert(session);
  for (Client client in _clients) {
    client.sessionId = sessionId;
    int id = await helper.insert(client);
  }

  // удаляем существующий вместе с подлежащими клиентами
  sessionId = 2;
  db.delete('clients', where: 'sessionId = ?', whereArgs: [sessionId]);
  db.delete('sessions', where: 'id = ?', whereArgs: [sessionId]);

  // обновляем существующего клиента
  int id = 1;
  sessionId = 1;
  Client client = await helper.getByID('clients', id);
  client.name = 'Супер Вася';
  await helper.update(client);
}
