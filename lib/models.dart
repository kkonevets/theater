import 'package:meta/meta.dart';

abstract class Record {
  int id;
  String name;
  DateTime time;
  String tableName;

  Record({this.id, this.name, this.time, this.tableName});

  factory Record.fromMap(Map<String, dynamic> map, String tableName) {
    switch (tableName) {
      case 'sessions':
        return Session.fromMap(map);
      case 'clients':
        return Client.fromMap(map);
      default:
        return null;
    }
  }

  Map<String, dynamic> toMap();
}

class Session extends Record {
  int totalSeats;

  Session({String name, DateTime time, this.totalSeats})
      : super(name: name, time: time, tableName: "sessions");

  @override
  Session.fromMap(Map<String, dynamic> map)
      : totalSeats = map['totalSeats'],
        super(
            id: map["id"],
            name: map['name'],
            time: DateTime.fromMillisecondsSinceEpoch(map['time']),
            tableName: "sessions");

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'time': time.millisecondsSinceEpoch,
      'totalSeats': totalSeats,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}

class Client extends Record {
  int sessionId;
  String barcode;
  String phoneNumber;
  int seatNumber;
  bool isPresent;

  Client(
      {@required this.sessionId,
      String name,
      this.barcode,
      this.phoneNumber,
      DateTime time,
      this.seatNumber,
      this.isPresent = false})
      : super(name: name, time: time, tableName: "clients");

  @override
  Client.fromMap(Map<String, dynamic> map)
      : sessionId = map['sessionId'],
        barcode = map['barcode'],
        phoneNumber = map['phoneNumber'],
        seatNumber = map['seatNumber'],
        isPresent = map['isPresent'] == 0 ? false : true,
        super(
            id: map["id"],
            name: map['name'],
            time: DateTime.fromMillisecondsSinceEpoch(map['time']),
            tableName: "clients");

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'barcode': barcode,
      'phoneNumber': phoneNumber,
      'time': time.millisecondsSinceEpoch,
      'seatNumber': seatNumber,
      'isPresent': isPresent == false ? 0 : 1
    };
    if (id != null) {
      map['id'] = id;
    }
    if (sessionId != null) {
      map['sessionId'] = sessionId;
    }
    return map;
  }
}
