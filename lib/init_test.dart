import 'package:theater/models.dart';
import 'package:theater/database_helpers.dart';


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
      time: DateTime.parse("2019-07-20 20:44:04Z"),
      seatNumber: 12),
  Client(
      name: "Вова",
      barcode: "2543857347234",
      phoneNumber: "+7945593453",
      time: DateTime.parse("2019-07-20 20:15:04Z"),
      seatNumber: 5),
  Client(
      name: "Гага",
      barcode: "259523238475",
      phoneNumber: "+7999345333",
      time: DateTime.parse("2019-07-20 20:13:04Z"),
      seatNumber: 6),
  Client(
      name: "Тетя",
      barcode: "438544473475",
      phoneNumber: "+7899557333",
      time: DateTime.parse("2019-07-20 20:23:04Z"),
      seatNumber: 7),
  Client(
      name: "Анна",
      barcode: "3465644577",
      phoneNumber: "+734547534",
      time: DateTime.parse("2019-07-20 20:21:04Z"),
      seatNumber: 8),
  Client(
      name: "Федя",
      barcode: "2567653423",
      phoneNumber: "+790087654",
      time: DateTime.parse("2019-07-20 20:22:04Z"),
      seatNumber: 9)
];

void initializeTestData() async {
  DatabaseHelper helper = DatabaseHelper.instance;

  int frac = (_clients.length / _sessions.length).truncate();

  int i = 0;
  for (Session session in _sessions) {
    int sessionId = await helper.insert(session);
    for (Client client in _clients.sublist(i, i + frac)) {
      client.sessionId = sessionId;
      int id = await helper.insert(client);
    }
    i += frac;
  }
}
